package com.lchjy.service;

import com.lchjy.entity.NingboFood;
import com.github.pagehelper.PageInfo;
import java.util.List;

public interface FoodService {
    PageInfo<NingboFood> list(String keyword, int pageNum, int pageSize);

    NingboFood getById(Integer id);

    void add(NingboFood food);

    void update(NingboFood food);

    void delete(Integer id);
}
