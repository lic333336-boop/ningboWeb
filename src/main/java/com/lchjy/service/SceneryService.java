package com.lchjy.service;

import com.lchjy.entity.NingboScenery;
import java.util.List;

public interface SceneryService {
    List<NingboScenery> list(String keyword);

    NingboScenery getById(Integer id);

    void add(NingboScenery scenery);

    void update(NingboScenery scenery);

    void delete(Integer id);
}
