package com.lchjy.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class NingboScenery {
    private Integer id;
    private String sceneryName;
    private String description;
    private String address;
    private String ticketPrice;
    private String openHours;
    private String sceneryImage;
}
