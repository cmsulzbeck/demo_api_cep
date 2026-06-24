package com.api_cep.demo.exceptions;

import lombok.*;

import java.time.LocalDateTime;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ApiError {
    private String message;
    private LocalDateTime timeStamp;
    private int status;
    private String path;
    private String externalResponse;
}
