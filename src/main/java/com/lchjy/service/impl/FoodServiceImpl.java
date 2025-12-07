package com.lchjy.service.impl;

import com.lchjy.entity.NingboFood;
import com.lchjy.mapper.FoodMapper;
import com.lchjy.service.FoodService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

@Service
public class FoodServiceImpl implements FoodService {

    @Autowired
    private FoodMapper foodMapper;

    @Override
    public PageInfo<NingboFood> list(String keyword, int pageNum, int pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<NingboFood> list = foodMapper.selectList(keyword);
        return new PageInfo<>(list);
    }

    @Override
    public NingboFood getById(Integer id) {
        return foodMapper.selectById(id);
    }

    @Override
    public void add(NingboFood food) {
        foodMapper.insert(food);
    }

    @Override
    public void update(NingboFood food) {
        foodMapper.update(food);
    }

    @Override
    public void delete(Integer id) {
        foodMapper.deleteById(id);
    }
}
