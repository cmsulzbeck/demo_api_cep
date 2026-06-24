# AWS EC2 Docker Deployment

This project can be deployed to AWS with Terraform-managed EC2 instances running Docker Compose.

## Prerequisites

- AWS CLI configured with credentials.
- Terraform `>= 1.6`.
- Docker image for the API pushed to a registry reachable from EC2, for example Docker Hub or ECR.
- Docker Desktop or Docker Engine available locally to build and push the API image.

## Build And Publish The API Image

Example using Docker Hub:

```powershell
docker build -t your-dockerhub-user/api-cep:qa .
docker push your-dockerhub-user/api-cep:qa

docker build -t your-dockerhub-user/api-cep:blue .
docker push your-dockerhub-user/api-cep:blue

docker build -t your-dockerhub-user/api-cep:green .
docker push your-dockerhub-user/api-cep:green
```

Use ECR instead if your AWS account requires private images.

## QA Deployment

Create a real tfvars file:

```powershell
Copy-Item infra/terraform/envs/qa/terraform.tfvars.example infra/terraform/envs/qa/terraform.tfvars
```

Edit `infra/terraform/envs/qa/terraform.tfvars` and set:

```hcl
api_image = "your-dockerhub-user/api-cep:qa"
```

Deploy:

```powershell
cd infra/terraform/envs/qa
terraform init
terraform plan
terraform apply
```

Terraform outputs the QA ALB DNS name. Test it:

```powershell
Invoke-RestMethod http://<qa-alb-dns-name>/cep/05351000
```

## PROD Blue-Green Deployment

Create a real tfvars file:

```powershell
Copy-Item infra/terraform/envs/prod/terraform.tfvars.example infra/terraform/envs/prod/terraform.tfvars
```

Edit `infra/terraform/envs/prod/terraform.tfvars`:

```hcl
active_color = "blue"

api_image_blue  = "your-dockerhub-user/api-cep:blue"
api_image_green = "your-dockerhub-user/api-cep:green"
```

Deploy:

```powershell
cd infra/terraform/envs/prod
terraform init
terraform plan
terraform apply
```

Terraform creates:

- One shared HSQLDB EC2 host.
- One blue app EC2 host.
- One green app EC2 host.
- One public ALB.
- Two target groups, one for each color.

The ALB listener forwards traffic to the target group named by `active_color`.

## Switch PROD Traffic

To switch from blue to green, edit `infra/terraform/envs/prod/terraform.tfvars`:

```hcl
active_color = "green"
```

Then apply:

```powershell
terraform plan
terraform apply
```

To roll back, change it back:

```hcl
active_color = "blue"
```

Then apply again.

## Validate Logs In The Database

Call the deployed API:

```powershell
Invoke-RestMethod http://<alb-dns-name>/cep/05351000
Invoke-RestMethod http://<alb-dns-name>/cep/00000000
```

Connect to the environment database from an allowed host using HSQLDB Database Manager:

```powershell
java -cp "target/dependency/*" org.hsqldb.util.DatabaseManagerSwing
```

Use:

```text
Type: HSQL Database Engine Server
Driver: org.hsqldb.jdbc.JDBCDriver
URL: jdbc:hsqldb:hsql://<database-host>:9001/demo
User: SA
Password:
```

Then query:

```sql
SELECT *
FROM LOG
ORDER BY ID DESC;
```

## Notes

- HSQLDB is kept here because the current application already uses it. For a real production workload, replace it with RDS and add the corresponding JDBC driver to the application.
- The Terraform security groups allow HTTP to the ALB from `allowed_http_cidrs`. Restrict this in real QA/PROD environments.
- EC2 instances get the AWS Systems Manager role, so you can use SSM Session Manager instead of opening SSH.
