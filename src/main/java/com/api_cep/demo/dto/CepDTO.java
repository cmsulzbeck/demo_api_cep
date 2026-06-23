package com.api_cep.demo.dto;

import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CepDTO {
    private String cep;
    private String streetName;
    private String district;
    private String uf;
}
