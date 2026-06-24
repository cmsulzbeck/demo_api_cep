package com.api_cep.demo.wiremock.service;

import com.api_cep.demo.dto.CepDTO;
import com.api_cep.demo.exceptions.CepServiceException;
import com.api_cep.demo.service.CepService;
import com.github.tomakehurst.wiremock.junit5.WireMockRuntimeInfo;
import com.github.tomakehurst.wiremock.junit5.WireMockTest;
import org.junit.jupiter.api.Test;
import org.springframework.web.client.RestClient;

import static com.github.tomakehurst.wiremock.client.WireMock.*;
import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@WireMockTest
public class CepServiceWireMockTest {

    @Test
    void getCep_shouldReturnCepData(WireMockRuntimeInfo wireMockRuntimeInfo) {
        stubFor(get(urlEqualTo("/cep/05351000"))
                .willReturn(okJson("""
                        {
                            "cep": "05351000",
                            "streetName": "Avenida Doutor Cândido Motta Filho",
                            "district": "Cidade São Francisco",
                            "uf": "SP"
                        }
                        """)));

        CepService cepService = new CepService(
                RestClient.builder(),
                wireMockRuntimeInfo.getHttpBaseUrl()
        );

        CepDTO response = cepService.getCep("05351000");

        assertThat(response.getCep()).isEqualTo("05351000");
        assertThat(response.getStreetName()).isEqualTo("Avenida Doutor Cândido Motta Filho");
        assertThat(response.getDistrict()).isEqualTo("Cidade São Francisco");
        assertThat(response.getUf()).isEqualTo("SP");

        verify(getRequestedFor(urlEqualTo("/cep/05351000")));
    }

    @Test
    void getCep_shouldReturnErrorWhenCepDoesntExist(WireMockRuntimeInfo wireMockRuntimeInfo) {
        stubFor(get(urlEqualTo("/cep/00000000"))
                .willReturn(notFound()
                        .withHeader("Content-Type", "application/json")
                        .withBody("""
                                {
                                    "code": "CEP_NOT_FOUND",
                                    "message": "CEP was not found in the mocked external API"
                                }
                                """)));

        CepService cepService = new CepService(
                RestClient.builder(),
                wireMockRuntimeInfo.getHttpBaseUrl()
        );

        assertThatThrownBy(() -> cepService.getCep("00000000"))
                .isInstanceOfSatisfying(CepServiceException.class, exception -> {
                    assertThat(exception.getStatusCode().value()).isEqualTo(404);
                    assertThat(exception.getExternalResponse()).contains("CEP_NOT_FOUND");
                    assertThat(exception.getExternalResponse()).contains("CEP was not found in the mocked external API");
                });

        verify(getRequestedFor(urlEqualTo("/cep/00000000")));
    }
}
