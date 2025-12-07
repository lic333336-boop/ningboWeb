package com.lchjy.controller;

import com.lchjy.entity.UserInfo;
import com.lchjy.service.UserService;
import com.lchjy.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/user")
public class UserController {

    @Autowired
    private UserService userService;

    @PostMapping("/login")
    public Result login(@RequestBody UserInfo userInfo) {
        log.info("用户登录请求: userInfo={}", userInfo);
        UserInfo user = userService.login(userInfo);
        if (user != null) {
            return Result.success(user);
        }
        return Result.error("用户名或密码错误");
    }

    @PostMapping("/register")
    public Result register(@RequestBody UserInfo userInfo) {
        log.info("用户注册请求: {}", userInfo);
        try {
            userService.register(userInfo);
            return Result.success();
        } catch (Exception e) {
            log.error("注册失败", e);
            return Result.error("注册失败: " + e.getMessage());
        }
    }

    @PostMapping("/update")
    public Result update(@RequestBody UserInfo userInfo) {
        log.info("用户更新请求: {}", userInfo);
        userService.update(userInfo);
        return Result.success();
    }

    @DeleteMapping("/delete/{id}")
    public Result delete(@PathVariable Integer id) {
        log.info("用户删除请求: id={}", id);
        userService.delete(id);
        return Result.success();
    }

    @GetMapping("/list")
    public Result list() {
        return Result.success(userService.findAll());
    }
}
