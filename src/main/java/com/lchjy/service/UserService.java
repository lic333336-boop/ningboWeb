package com.lchjy.service;

import com.lchjy.entity.UserInfo;
import com.github.pagehelper.PageInfo;
import java.util.List;

public interface UserService {
    UserInfo login(UserInfo userInfo);

    void register(UserInfo userInfo);

    void update(UserInfo userInfo);

    void delete(Integer id);

    PageInfo<UserInfo> list(String keyword, int pageNum, int pageSize);

    UserInfo findById(Integer id);
}
