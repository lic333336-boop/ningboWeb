package com.lchjy.mapper;

import com.lchjy.entity.UserInfo;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface UserMapper {
    UserInfo findByUsername(String username);

    int insert(UserInfo userInfo);

    int update(UserInfo userInfo);

    int deleteById(Integer id);

    List<UserInfo> findAll();
}
