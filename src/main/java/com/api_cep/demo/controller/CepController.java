package com.api_cep.demo.controller;

import com.api_cep.demo.dto.CepDTO;
import com.api_cep.demo.exceptions.ApiError;
import com.api_cep.demo.exceptions.CepServiceException;
import com.api_cep.demo.service.CepService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import tools.jackson.databind.ObjectMapper;

import java.time.LocalDateTime;

@Slf4j
@RestController
@RequestMapping("/cep")
@RequiredArgsConstructor
public class CepController {

    private final CepService cepService;

    @GetMapping(value = "/{cep}")
    public ResponseEntity<CepDTO> getCepData(@PathVariable String cep) {
        log.info("Iniciando request GET de cep: {}", cep);
        CepDTO cepDTO = cepService.getCep(cep);
        ObjectMapper mapper = new ObjectMapper();
        log.info("Objeto CEP construído: {}", mapper.writerWithDefaultPrettyPrinter().writeValueAsString(cepDTO));

        return ResponseEntity.ok(cepDTO);
    }

    @ExceptionHandler(CepServiceException.class)
    ResponseEntity<ApiError> handle(CepServiceException e, HttpServletRequest request) {
        ApiError apiError = ApiError.builder()
                .timeStamp(LocalDateTime.now())
                .status(e.getStatusCode().value())
                .message(e.getMessage())
                .path(request.getRequestURI())
                .externalResponse(e.getExternalResponse())
                .build();

        return ResponseEntity
                .status(e.getStatusCode())
                .body(apiError);
    }
}
