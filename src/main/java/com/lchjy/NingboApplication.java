package com.lchjy;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.lchjy.mapper")
public class NingboApplication {

    public static void main(String[] args) {
        SpringApplication.run(NingboApplication.class, args);
    }

}
