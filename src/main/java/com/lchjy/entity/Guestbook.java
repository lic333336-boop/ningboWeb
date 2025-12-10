package com.lchjy.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Guestbook {
    private Integer id;
    private String nickname;
    private String content;
    private Date createTime;
}
