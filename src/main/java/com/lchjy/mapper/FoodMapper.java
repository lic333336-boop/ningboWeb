package com.lchjy.mapper;

import com.lchjy.entity.NingboFood;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface FoodMapper {
    List<NingboFood> selectList(@Param("keyword") String keyword);

    NingboFood selectById(Integer id);

    int insert(NingboFood food);

    int update(NingboFood food);

    int deleteById(Integer id);
}
