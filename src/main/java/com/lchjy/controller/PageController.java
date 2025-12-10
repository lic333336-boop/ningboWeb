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

    // 留言板页
    @GetMapping("/guestbook")
    public String guestbook() {
        return "guestbook"; // 对应 guestbook.jsp
    }

    // --- 后台管理相关映射 ---

    // 后台首页 (直接跳转到第一个模块：美食管理)
    @GetMapping("/admin")
    public String admin() {
        return "redirect:/admin/food";
    }

    // 后台-美食管理列表
    @GetMapping("/admin/food")
    public String adminFood() {
        return "admin/food_list";
    }

    // 后台-美食新增/编辑页
    @GetMapping("/admin/food/edit")
    public String adminFoodEdit() {
        return "admin/food_form";
    }

    // 后台-景点管理列表
    @GetMapping("/admin/scenery")
    public String adminScenery() {
        return "admin/scenery_list";
    }

    // 后台-景点新增/编辑页
    @GetMapping("/admin/scenery/edit")
    public String adminSceneryEdit() {
        return "admin/scenery_form";
    }

    // 后台-文化管理列表
    @GetMapping("/admin/culture")
    public String adminCulture() {
        return "admin/culture_list";
    }

    // 后台-文化新增/编辑页
    @GetMapping("/admin/culture/edit")
    public String adminCultureEdit() {
        return "admin/culture_form";
    }

    // 后台-用户管理列表
    @GetMapping("/admin/user")
    public String adminUser() {
        return "admin/user_list";
    }

    // 后台-用户新增/编辑页
    @GetMapping("/admin/user/edit")
    public String adminUserEdit() {
        return "admin/user_form";
    }

    // 后台-留言管理列表
    @GetMapping("/admin/guestbook")
    public String adminGuestbook() {
        return "admin/guestbook_list";
    }
}