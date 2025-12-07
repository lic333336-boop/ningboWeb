package com.lchjy.mapper;

import com.lchjy.entity.NingboScenery;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface SceneryMapper {
    List<NingboScenery> selectList(@Param("keyword") String keyword);

    NingboScenery selectById(Integer id);

    int insert(NingboScenery scenery);

    int update(NingboScenery scenery);

    int deleteById(Integer id);
}
