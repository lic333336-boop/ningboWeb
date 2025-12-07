package com.lchjy.service;

import com.lchjy.entity.UserInfo;
import java.util.List;

public interface UserService {
    UserInfo login(UserInfo userInfo);

    void register(UserInfo userInfo);

    void update(UserInfo userInfo);

    void delete(Integer id);

    List<UserInfo> findAll();


    UserInfo findById(Integer id);
}
