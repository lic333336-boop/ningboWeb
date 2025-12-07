package com.lchjy.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class NingboFood {
    private Integer id;
    private String foodName;
    private String description;
    private BigDecimal price;
    private String location;
    private String foodImage;
}
