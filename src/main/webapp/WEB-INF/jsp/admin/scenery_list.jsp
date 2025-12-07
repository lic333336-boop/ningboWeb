<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>景点管理 - 宁波文化旅游网</title>
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
        .thumb-img { width: 60px; height: 40px; object-fit: cover; border-radius: 2px; background: #eee; }
        .btn-edit { color: #1890ff; margin-right: 10px; cursor: pointer; }
        .btn-del { color: #ff4d4f; cursor: pointer; }
        .search-area { display: flex; align-items: center; }
        .search-input { padding: 8px; border: 1px solid #d9d9d9; border-radius: 4px; border-right: none; border-top-right-radius: 0; border-bottom-right-radius: 0; outline: none; }
        .btn-search { padding: 8px 15px; background: #1890ff; color: white; border: none; border-radius: 4px; border-top-left-radius: 0; border-bottom-left-radius: 0; cursor: pointer; }
        .pagination { margin-top: 20px; display: flex; justify-content: flex-end; }
        .page-item { padding: 5px 12px; border: 1px solid #d9d9d9; margin-left: 5px; cursor: pointer; border-radius: 4px; }
        .page-item.active { background: #1890ff; color: white; border-color: #1890ff; }
        .page-item.disabled { background: #f5f5f5; color: #ccc; cursor: not-allowed; }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="logo-area">管理系统</div>
    <a href="/admin/food" class="menu-item">美食管理</a>
    <a href="/admin/scenery" class="menu-item active">景点管理</a>
    <a href="/admin/culture" class="menu-item">文化管理</a>
    <a href="/admin/user" class="menu-item">用户管理</a>
</div>

<div class="main-content">
    <div class="header-bar">
        <h3>景点数据列表</h3>
        <div class="search-area">
            <input type="text" id="keyword" class="search-input" placeholder="请输入关键词...">
            <button class="btn-search" onclick="loadData(1)">搜索</button>
        </div>
        <div>
            <a href="/index" style="margin-right: 15px; color: #1890ff; text-decoration: none;">返回首页</a>
            <a href="/admin/scenery/edit" class="btn-add">+ 新增景点</a>
        </div>
    </div>

    <table class="data-table">
        <thead>
        <tr>
            <th>ID</th>
            <th>图片</th>
            <th>名称</th>
            <th>门票</th>
            <th>开放时间</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody id="tableBody">
            <!-- Data will be loaded here -->
        </tbody>
    </table>
    <div id="pagination" class="pagination"></div>
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

    function loadData(page, keyword) {
        if (!page) page = 1;
        if (!keyword) keyword = $("#keyword").val();

        $.ajax({
            url: "/api/scenery/list",
            type: "GET",
            data: {
                page: page,
                limit: 10,
                keyword: keyword
            },
            success: function(res) {
                if (res.code === 1) {
                    renderTable(res.data.list);
                    renderPagination(res.data);
                } else {
                    alert("加载失败: " + res.msg);
                }
            }
        });
    }

    function renderTable(list) {
        var html = "";
        $.each(list, function(i, item) {
            html += `
                <tr>
                    <td>\${item.id}</td>
                    <td><img src="\${item.sceneryImage}" class="thumb-img"></td>
                    <td>\${item.sceneryName}</td>
                    <td>\${item.ticketPrice}</td>
                    <td>\${item.openHours}</td>
                    <td>
                        <a href="/admin/scenery/edit?id=\${item.id}" class="btn-edit">编辑</a>
                        <span class="btn-del" onclick="deleteItem(\${item.id})">删除</span>
                    </td>
                </tr>
            `;
        });
        $("#tableBody").html(html);
    }

    function renderPagination(pageInfo) {
        var html = "";
        
        // Prev
        if (pageInfo.hasPreviousPage) {
            html += `<span class="page-item" onclick="loadData(\${pageInfo.prePage})">上一页</span>`;
        } else {
            html += `<span class="page-item disabled">上一页</span>`;
        }
        
        // Pages
        $.each(pageInfo.navigatepageNums, function(i, num) {
            var activeClass = (num === pageInfo.pageNum) ? "active" : "";
            html += `<span class="page-item \${activeClass}" onclick="loadData(\${num})">\${num}</span>`;
        });
        
        // Next
        if (pageInfo.hasNextPage) {
            html += `<span class="page-item" onclick="loadData(\${pageInfo.nextPage})">下一页</span>`;
        } else {
            html += `<span class="page-item disabled">下一页</span>`;
        }
        
        $("#pagination").html(html);
    }

    function deleteItem(id) {
        if(!confirm("确定要删除这条数据吗？此操作不可恢复。")) return;
        $.ajax({
            url: "/api/scenery/delete/" + id,
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
