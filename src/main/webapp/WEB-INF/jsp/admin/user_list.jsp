<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>用户管理 - 宁波文化旅游网</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body { margin: 0; padding: 0; font-family: "微软雅黑", sans-serif; display: flex; height: 100vh; overflow: hidden; }
        .sidebar { width: 240px; background-color: #001529; color: white; display: flex; flex-direction: column; }
        .logo-area { height: 64px; display: flex; align-items: center; justify-content: center; font-size: 20px; font-weight: bold; background-color: #002140; }
        .menu-item { padding: 15px 25px; cursor: pointer; color: rgba(255,255,255,0.65); transition: all 0.3s; text-decoration: none; display: block; }
        .menu-item:hover, .menu-item.active { color: white; background-color: #1890ff; }
        .main-content { flex: 1; background-color: #f0f2f5; padding: 20px; overflow-y: auto; }
        .header-bar { background: white; padding: 10px 20px; display: flex; justify-content: space-between; align-items: center; border-radius: 4px; margin-bottom: 20px; }
        .btn-add { background-color: #52c41a; color: white; padding: 8px 15px; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; display: inline-block;}
        .data-table { width: 100%; background: white; border-collapse: collapse; border-radius: 4px; overflow: hidden; box-shadow: 0 1px 4px rgba(0,0,0,0.05); }
        .data-table th, .data-table td { padding: 15px; text-align: left; border-bottom: 1px solid #f0f0f0; }
        .data-table th { background-color: #fafafa; font-weight: 500; }
        .thumb-img { width: 40px; height: 40px; object-fit: cover; border-radius: 50%; background: #eee; }
        .btn-edit { color: #1890ff; margin-right: 10px; cursor: pointer; }
        .btn-del { color: #ff4d4f; cursor: pointer; }
        .role-badge { padding: 2px 8px; border-radius: 10px; font-size: 12px; }
        .role-admin { background: #fff0f6; color: #eb2f96; border: 1px solid #ffadd2; }
        .role-user { background: #e6f7ff; color: #1890ff; border: 1px solid #91d5ff; }
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
    <div class="header-bar">
        <h3>用户数据列表</h3>
        <div>
            <a href="/index" style="margin-right: 15px; color: #1890ff; text-decoration: none;">返回首页</a>
            <a href="/admin/user/edit" class="btn-add">+ 新增用户</a>
        </div>
    </div>

    <table class="data-table">
        <thead>
        <tr>
            <th>ID</th>
            <th>头像</th>
            <th>用户名</th>
            <th>真实姓名</th>
            <th>角色</th>
            <th>邮箱/电话</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody id="tableBody">
            <!-- Data will be loaded here -->
        </tbody>
    </table>
</div>

<script>
    $(document).ready(function() {
        checkLogin();
        loadData();
    });

    function checkLogin() {
        var userStr = localStorage.getItem("currentUser");
        if (!userStr) { window.location.href = "/login"; return; }
        var user = JSON.parse(userStr);
        if (user.role !== 'admin') { window.location.href = "/index"; }
    }

    function loadData() {
        $.ajax({
            url: "/api/user/list",
            type: "GET",
            success: function(res) {
                if (res.code === 1) {
                    renderTable(res.data);
                } else {
                    alert("加载失败: " + res.msg);
                }
            }
        });
    }

    function renderTable(list) {
        var html = "";
        $.each(list, function(i, item) {
            var roleClass = item.role === 'admin' ? 'role-admin' : 'role-user';
            var roleText = item.role === 'admin' ? '管理员' : '普通用户';
            var avatar = item.avatar || 'https://via.placeholder.com/40?text=U';

            html += `
                <tr>
                    <td>\${item.id}</td>
                    <td><img src="\${avatar}" class="thumb-img"></td>
                    <td>\${item.username}</td>
                    <td>\${item.realName || '-'}</td>
                    <td><span class="role-badge \${roleClass}">\${roleText}</span></td>
                    <td>\${item.email || '-'}<br>\${item.phone || '-'}</td>
                    <td>
                        <a href="/admin/user/edit?id=\${item.id}" class="btn-edit">编辑</a>
                        <span class="btn-del" onclick="deleteItem(\${item.id})">删除</span>
                    </td>
                </tr>
            `;
        });
        $("#tableBody").html(html);
    }

    function deleteItem(id) {
        if(!confirm("确定要删除该用户吗？")) return;
        $.ajax({
            url: "/api/user/delete/" + id,
            type: "DELETE",
            success: function(res) {
                 if (res.code === 1) {
                     alert("删除成功");
                     loadData();
                 } else {
                     alert("删除失败: " + res.msg);
                 }
            }
        });
    }
</script>

</body>
</html>
