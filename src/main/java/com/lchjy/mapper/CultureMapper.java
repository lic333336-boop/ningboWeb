package com.lchjy.mapper;

import com.lchjy.entity.NingboCulture;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface CultureMapper {
    List<NingboCulture> selectList(@Param("keyword") String keyword);

    NingboCulture selectById(Integer id);

    int insert(NingboCulture culture);

    int update(NingboCulture culture);

    int deleteById(Integer id);
}
