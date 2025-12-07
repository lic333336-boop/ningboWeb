package com.lchjy.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * 页面跳转控制器
 * 负责将 URL 请求转发到 WEB-INF/jsp/ 下的对应 .jsp 文件
 */
@Controller
public class PageController {

    // 默认访问根目录 -> 跳转登录页
    @GetMapping("/")
    public String root() {
        return "login";
    }

    // 登录页
    @GetMapping("/login")
    public String login() {
        return "login";
    }

    // 注册页
    @GetMapping("/register")
    public String register() {
        return "register";
    }

    // 网站首页 (展示所有模块入口和美食)
    @GetMapping("/index")
    public String index() {
        return "index";
    }

    // 家乡美食页
    @GetMapping("/food")
    public String food() {
        return "food"; // 对应 food.jsp
    }

    // 家乡景点页
    @GetMapping("/scenery")
    public String scenery() {
        return "scenery"; // 对应 scenery.jsp
    }

    // 家乡文化页
    @GetMapping("/culture")
    public String culture() {
        return "culture"; // 对应 culture.jsp
    }
}