package com.api_cep.demo.filter;

import com.api_cep.demo.entity.Log;
import com.api_cep.demo.repository.LogRepository;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import org.springframework.web.util.ContentCachingRequestWrapper;
import org.springframework.web.util.ContentCachingResponseWrapper;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;

@Component
@AllArgsConstructor
public class LogFilter extends OncePerRequestFilter {

    private final LogRepository logRepository;

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain
    ) throws ServletException, IOException {
        int CACHE_LIMIT = 1;
        ContentCachingRequestWrapper wrappedRequest = new ContentCachingRequestWrapper(request, CACHE_LIMIT);
        ContentCachingResponseWrapper wrappedResponse = new ContentCachingResponseWrapper(response);

        try {
            filterChain.doFilter(wrappedRequest, wrappedResponse);

            String requestData = new String(wrappedRequest.getContentAsByteArray(), StandardCharsets.UTF_8);
            String returnedData = new String(wrappedResponse.getContentAsByteArray(), StandardCharsets.UTF_8);

            // TODO testar se passar um ID aqui resulta em erro de inserção no banco de dados
            Log log = Log.builder()
                    .callTime(LocalDateTime.now())
                    .requestData(requestData)
                    .returnedData(returnedData)
                    .operationType(request.getMethod())
                    .statusCode(response.getStatus())
                    .build();

            logRepository.save(log);
        } finally {
            wrappedResponse.copyBodyToResponse();
        }
    }
}
