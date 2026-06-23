package com.api_cep.demo.repository;

import com.api_cep.demo.entity.Log;
import org.springframework.data.jpa.repository.JpaRepository;

public interface LogRepository extends JpaRepository<Log, Long> {
}
