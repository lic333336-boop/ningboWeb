package com.lchjy.service.impl;

import com.lchjy.entity.NingboScenery;
import com.lchjy.mapper.SceneryMapper;
import com.lchjy.service.SceneryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

@Service
public class SceneryServiceImpl implements SceneryService {

    @Autowired
    private SceneryMapper sceneryMapper;

    @Override
    public PageInfo<NingboScenery> list(String keyword, int pageNum, int pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<NingboScenery> list = sceneryMapper.selectList(keyword);
        return new PageInfo<>(list);
    }

    @Override
    public NingboScenery getById(Integer id) {
        return sceneryMapper.selectById(id);
    }

    @Override
    public void add(NingboScenery scenery) {
        sceneryMapper.insert(scenery);
    }

    @Override
    public void update(NingboScenery scenery) {
        sceneryMapper.update(scenery);
    }

    @Override
    public void delete(Integer id) {
        sceneryMapper.deleteById(id);
    }
}
