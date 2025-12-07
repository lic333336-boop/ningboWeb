package com.lchjy.service.impl;

import com.lchjy.entity.NingboScenery;
import com.lchjy.mapper.SceneryMapper;
import com.lchjy.service.SceneryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class SceneryServiceImpl implements SceneryService {

    @Autowired
    private SceneryMapper sceneryMapper;

    @Override
    public List<NingboScenery> list(String keyword) {
        return sceneryMapper.selectList(keyword);
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
