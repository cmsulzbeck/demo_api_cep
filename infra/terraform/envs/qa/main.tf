locals {
  name_prefix = "${var.project_name}-${var.environment}"

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }

  project_root = abspath("${path.module}/../../../..")

  wiremock_mappings = [
    {
      filename = "cep-05351000.json"
      content  = file("${local.project_root}/src/test/resources/wiremock/mappings/cep-05351000.json")
    },
    {
      filename = "cep-00000000-error.json"
      content  = file("${local.project_root}/src/test/resources/wiremock/mappings/cep-00000000-error.json")
    }
  ]

  user_data = templatefile("${local.project_root}/infra/scripts/user-data.sh.tftpl", {
    compose_file               = file("${local.project_root}/compose.aws.yaml")
    wiremock_mappings          = local.wiremock_mappings
    api_image                  = var.api_image
    wiremock_image             = var.wiremock_image
    hsqldb_image               = var.hsqldb_image
    spring_datasource_url      = "jdbc:hsqldb:hsql://database/demo"
    spring_datasource_username = var.database_username
    spring_datasource_password = var.database_password
    correios_api_base_url      = "http://wiremock:8080"
    compose_services           = "database wiremock api"
  })
}

module "network" {
  source = "../../modules/network"

  name                = local.name_prefix
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  availability_zones  = var.availability_zones
  tags                = local.tags
}

module "security" {
  source = "../../modules/security"

  name               = local.name_prefix
  vpc_id             = module.network.vpc_id
  allowed_http_cidrs = var.allowed_http_cidrs
  allowed_ssh_cidrs  = var.allowed_ssh_cidrs
  tags               = local.tags
}

module "app" {
  source = "../../modules/ec2-docker-app"

  name          = "${local.name_prefix}-app"
  instance_type = var.instance_type
  subnet_id     = module.network.public_subnet_ids[0]
  security_group_ids = [
    module.security.app_security_group_id,
    module.security.database_security_group_id
  ]
  key_name  = var.key_name
  user_data = local.user_data
  tags      = local.tags
}

module "alb" {
  source = "../../modules/alb"

  name                = "${local.name_prefix}-alb"
  vpc_id              = module.network.vpc_id
  subnet_ids          = module.network.public_subnet_ids
  security_group_id   = module.security.alb_security_group_id
  active_target_group = "qa"
  tags                = local.tags

  target_groups = {
    qa = {
      name                 = "${local.name_prefix}-tg"
      port                 = 8080
      instance_ids         = [module.app.instance_id]
      health_check_path    = "/cep/05351000"
      health_check_matcher = "200-399"
    }
  }
}
