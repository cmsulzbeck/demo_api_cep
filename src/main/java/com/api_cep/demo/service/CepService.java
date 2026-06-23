package com.api_cep.demo.service;

import com.api_cep.demo.dto.CepDTO;
import com.api_cep.demo.repository.LogRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestTemplate;

@Service
@Slf4j
public class CepService {

    private final RestClient restClient;
    private final String correiosBaseUrl;

    public CepService(RestClient.Builder restClientBuilder, @Value("${correios.api.base-url}") String correiosBaseUrl) {
        this.restClient = RestClient.builder().build();
        this.correiosBaseUrl = correiosBaseUrl;
    }

    public CepDTO getCep(String cep) {

        return restClient.get()
                .uri(correiosBaseUrl + "/cep/{cep}", cep)
                .retrieve()
                .body(CepDTO.class);
    }
}
