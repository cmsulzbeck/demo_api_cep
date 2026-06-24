package com.api_cep.demo.exceptions;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.http.HttpStatusCode;

@Getter
public class CepServiceException extends RuntimeException {
    private final HttpStatusCode statusCode;
    private final String externalResponse;

    public CepServiceException(String message, HttpStatusCode statusCode, String externalResponse) {
        super(message);
        this.statusCode = statusCode;
        this.externalResponse = externalResponse;
    }
}
