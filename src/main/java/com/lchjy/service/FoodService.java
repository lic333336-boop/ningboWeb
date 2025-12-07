package com.lchjy.service;

import com.lchjy.entity.NingboFood;
import java.util.List;

public interface FoodService {
    List<NingboFood> list(String keyword);

    NingboFood getById(Integer id);

    void add(NingboFood food);

    void update(NingboFood food);

    void delete(Integer id);
}
