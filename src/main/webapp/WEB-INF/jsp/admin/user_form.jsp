<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>编辑用户 - 宁波文化旅游网</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body { margin: 0; padding: 0; font-family: "微软雅黑", sans-serif; display: flex; height: 100vh; overflow: hidden; }
        .sidebar { width: 240px; background-color: #001529; color: white; display: flex; flex-direction: column; }
        .logo-area { height: 64px; display: flex; align-items: center; justify-content: center; font-size: 20px; font-weight: bold; background-color: #002140; }
        .menu-item { padding: 15px 25px; cursor: pointer; color: rgba(255,255,255,0.65); transition: all 0.3s; text-decoration: none; display: block; }
        .menu-item:hover, .menu-item.active { color: white; background-color: #1890ff; }
        .main-content { flex: 1; background-color: #f0f2f5; padding: 20px; overflow-y: auto; }
        .form-card { background: white; padding: 30px; border-radius: 4px; width: 600px; margin: 0 auto; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 500; }
        .form-control { width: 100%; padding: 10px; border: 1px solid #d9d9d9; border-radius: 4px; box-sizing: border-box; }
        .btn-submit { background-color: #1890ff; color: white; padding: 10px 30px; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; }
        .btn-cancel { background-color: #f5f5f5; color: #333; padding: 10px 30px; border: 1px solid #d9d9d9; border-radius: 4px; cursor: pointer; margin-left: 10px; text-decoration: none; display: inline-block; }
        select.form-control { height: 40px; }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="logo-area">管理系统</div>
    <a href="/admin/food" class="menu-item">美食管理</a>
    <a href="/admin/scenery" class="menu-item">景点管理</a>
    <a href="/admin/culture" class="menu-item">文化管理</a>
    <a href="/admin/user" class="menu-item active">用户管理</a>
</div>

<div class="main-content">
    <div class="form-card">
        <h2 id="pageTitle">新增用户</h2>
        <input type="hidden" id="userId">
        
        <div class="form-group">
            <label>用户名</label>
            <input type="text" class="form-control" id="username" placeholder="请输入用户名">
        </div>

        <div class="form-group">
            <label>密码</label>
            <input type="password" class="form-control" id="password" placeholder="请输入密码 (编辑时不填则不修改)">
        </div>

        <div class="form-group">
            <label>真实姓名</label>
            <input type="text" class="form-control" id="realName" placeholder="请输入真实姓名">
        </div>
        
        <div class="form-group">
            <label>角色</label>
            <select class="form-control" id="role">
                <option value="user">普通用户</option>
                <option value="admin">管理员</option>
            </select>
        </div>

        <div class="form-group">
            <label>电话</label>
            <input type="text" class="form-control" id="phone" placeholder="请输入电话">
        </div>

        <div class="form-group">
            <label>邮箱</label>
            <input type="email" class="form-control" id="email" placeholder="请输入邮箱">
        </div>
        
        <div class="form-group">
            <label>用户头像</label>
            <input type="file" class="form-control" id="fileInput">
            <input type="hidden" id="avatar">
            <img id="preview" src="" style="max-width: 200px; margin-top: 10px; display: none;">
        </div>

        <div style="text-align: right;">
            <button class="btn-submit" onclick="submitForm()">保存提交</button>
            <a href="/admin/user" class="btn-cancel">取消</a>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        checkLogin();
        var id = getUrlParam('id');
        if (id) {
            $("#pageTitle").text("编辑用户");
            $("#userId").val(id);
            // 编辑模式下用户名通常不可改为已存在的，这里暂不限制只做回显
            $("#username").attr("disabled", "disabled").css("background", "#eee");
            loadDetail(id);
        }
    });

    function checkLogin() {
        var userStr = localStorage.getItem("currentUser");
        if (!userStr) { window.location.href = "/login"; return; }
        var user = JSON.parse(userStr);
        if (user.role !== 'admin') { window.location.href = "/index"; }
    }

    function getUrlParam(name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
        var r = window.location.search.substr(1).match(reg);
        if (r != null) return unescape(r[2]); return null;
    }

    function loadDetail(id) {
        $.ajax({
            url: "/api/user/" + id,
            type: "GET",
            success: function(res) {
                if (res.code === 1) {
                    var data = res.data;
                    $("#username").val(data.username);
                    $("#realName").val(data.realName);
                    $("#role").val(data.role || 'user');
                    $("#phone").val(data.phone);
                    $("#email").val(data.email);
                    $("#avatar").val(data.avatar);
                    if(data.avatar) {
                        $("#preview").attr("src", data.avatar).show();
                    }
                } else {
                    alert("加载数据失败");
                }
            }
        });
    }

    function submitForm() {
        var file = $("#fileInput")[0].files[0];
        if (file) {
            var formData = new FormData();
            formData.append("file", file);
            $.ajax({
                url: "/api/common/upload",
                type: "POST",
                data: formData,
                processData: false,
                contentType: false,
                success: function(res) {
                    if (res.code === 1) {
                        saveData(res.data);
                    } else {
                        alert("头像上传失败: " + res.msg);
                    }
                },
                error: function() {
                    alert("头像上传网络错误");
                }
            });
        } else {
            saveData($("#avatar").val());
        }
    }

    function saveData(imgUrl) {
        var id = $("#userId").val();
        var data = {
            "username": $("#username").val(),
            "realName": $("#realName").val(),
            "role": $("#role").val(),
            "phone": $("#phone").val(),
            "email": $("#email").val(),
            "avatar": imgUrl
        };
        
        var pwd = $("#password").val();
        if (pwd) {
            data.password = pwd;
        }

        var url = "/api/user/register"; // add
        if (id) {
            url = "/api/user/update";
            data.id = id;
            // 如果是更新，且没有填密码，后端应该逻辑是不更新密码，或者前端不传password字段
            // 这里假设后端Update逻辑处理了null password的情况
        } else {
            // 新增时密码必填
            if (!pwd) {
                alert("新增用户必须填写密码");
                return;
            }
        }

        $.ajax({
            url: url,
            type: "POST",
            contentType: "application/json",
            data: JSON.stringify(data),
            success: function(res) {
                if (res.code === 1) {
                    alert("保存成功");
                    window.location.href = "/admin/user";
                } else {
                    alert("保存失败: " + res.msg);
                }
            }
        });
    }
</script>

</body>
</html>
