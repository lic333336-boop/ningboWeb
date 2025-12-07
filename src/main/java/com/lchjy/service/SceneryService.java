package com.lchjy.service;

import com.lchjy.entity.NingboScenery;
import com.github.pagehelper.PageInfo;
import java.util.List;

public interface SceneryService {
    PageInfo<NingboScenery> list(String keyword, int pageNum, int pageSize);

    NingboScenery getById(Integer id);

    void add(NingboScenery scenery);

    void update(NingboScenery scenery);

    void delete(Integer id);
}
