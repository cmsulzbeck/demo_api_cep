package com.api_cep.demo.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "log")
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Log {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private LocalDateTime callTime;

    private String operationType;

    private Integer statusCode;

    @Column(length = 10000)
    private String requestData;

    @Column(length = 10000)
    private String returnedData;
}
