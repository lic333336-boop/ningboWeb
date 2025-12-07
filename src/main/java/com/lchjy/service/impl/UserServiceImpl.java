package com.lchjy.service.impl;

import com.lchjy.entity.UserInfo;
import com.lchjy.mapper.UserMapper;
import com.lchjy.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Override
    public UserInfo login(UserInfo userInfo) {
        // 1. 根据用户名查询数据库里的用户
        UserInfo dbUser = userMapper.findByUsername(userInfo.getUsername());

        // 2. 如果查不到，返回 null
        if (dbUser == null) {
            log.warn("登录失败: 用户名 '{}' 不存在", userInfo.getUsername());
            return null;
        }

        // 3. 【关键】比对密码
        // 注意：数据库里的密码 (dbUser.getPassword()) 必须和 用户输入的 (userInfo.getPassword()) 一致
        if (!dbUser.getPassword().equals(userInfo.getPassword())) {
            log.warn("登录失败: 用户 '{}' 密码错误", userInfo.getUsername());
            return null; // 密码不对，也返回 null
        }

        // 4. 全部匹配，返回用户对象
        return dbUser;
    }

    @Override
    public void register(UserInfo userInfo) {
        // 简单实现，实际应包含加密等
        userMapper.insert(userInfo);
    }

    @Override
    public void update(UserInfo userInfo) {
        userMapper.update(userInfo);
    }

    @Override
    public void delete(Integer id) {
        userMapper.deleteById(id);
    }

    @Override
    public List<UserInfo> findAll() {
        return userMapper.findAll();
    }

    @Override
    public UserInfo findById(Integer id) {
        return userMapper.findById(id);
    }
}
