package com.lchjy.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class NingboCulture {
    private Integer id;
    private String cultureTitle;
    private String content;
    private String historyPeriod;
    private String significance;
    private String cultureImage;
}
