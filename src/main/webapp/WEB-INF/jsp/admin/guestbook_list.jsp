<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>留言管理 - 宁波文化旅游网</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body { margin: 0; padding: 0; font-family: "微软雅黑", sans-serif; display: flex; height: 100vh; overflow: hidden; }
        .sidebar { width: 240px; background-color: #001529; color: white; display: flex; flex-direction: column; }
        .logo-area { height: 64px; display: flex; align-items: center; justify-content: center; font-size: 20px; font-weight: bold; background-color: #002140; }
        .menu-item { padding: 15px 25px; cursor: pointer; color: rgba(255,255,255,0.65); transition: all 0.3s; text-decoration: none; display: block; }
        .menu-item:hover, .menu-item.active { color: white; background-color: #1890ff; }
        .main-content { flex: 1; background-color: #f0f2f5; padding: 20px; overflow-y: auto; }
        .header-bar { background: white; padding: 10px 20px; display: flex; justify-content: space-between; align-items: center; border-radius: 4px; margin-bottom: 20px; }
        .data-table { width: 100%; background: white; border-collapse: collapse; border-radius: 4px; overflow: hidden; box-shadow: 0 1px 4px rgba(0,0,0,0.05); table-layout: fixed; }
        .data-table th, .data-table td { padding: 15px; text-align: left; border-bottom: 1px solid #f0f0f0; word-break: break-all; }
        .data-table th { background-color: #fafafa; font-weight: 500; }
        .data-table th:nth-child(1), .data-table td:nth-child(1) { width: 60px; }
        .data-table th:nth-child(2), .data-table td:nth-child(2) { width: 120px; }
        .data-table th:nth-child(3), .data-table td:nth-child(3) { width: auto; max-width: 400px; }
        .data-table th:nth-child(4), .data-table td:nth-child(4) { width: 150px; }
        .data-table th:nth-child(5), .data-table td:nth-child(5) { width: 80px; }
        .btn-del { color: #ff4d4f; cursor: pointer; }
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
    <a href="/admin/scenery" class="menu-item">景点管理</a>
    <a href="/admin/culture" class="menu-item">文化管理</a>
    <a href="/admin/user" class="menu-item">用户管理</a>
    <a href="/admin/guestbook" class="menu-item active">留言管理</a>
</div>

<div class="main-content">
    <div class="header-bar">
        <h3>留言数据列表</h3>
        <div>
            <a href="/index" style="margin-right: 15px; color: #1890ff; text-decoration: none;">返回首页</a>
        </div>
    </div>

    <table class="data-table">
        <thead>
        <tr>
            <th>ID</th>
            <th>昵称</th>
            <th>留言内容</th>
            <th>留言时间</th>
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
    var currentPage = 1; // Track current page
    
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

    function loadData(page) {
        if (!page) page = 1;
        
        currentPage = page; // Store current page

        $.ajax({
            url: "/api/guestbook/list",
            type: "GET",
            data: {
                page: page,
                limit: 10
            },
            success: function(res) {
                if (res.code === 1) {
                    // If current page is empty and we're not on page 1, go to previous page
                    if (res.data.list.length === 0 && page > 1) {
                        loadData(page - 1);
                        return;
                    }
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
            var time = formatDate(item.createTime);
            html += `
                <tr>
                    <td>\${item.id}</td>
                    <td>\${item.nickname}</td>
                    <td>\${item.content}</td>
                    <td>\${time}</td>
                    <td>
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
        if(!confirm("确定要删除这条留言吗？此操作不可恢复。")) return;
        $.ajax({
            url: "/api/guestbook/delete/" + id,
            type: "DELETE",
            success: function(res) {
                 if (res.code === 1) {
                     alert("删除成功");
                     loadData(currentPage); // Stay on current page
                 } else {
                     alert("删除失败: " + res.msg);
                 }
            }
        });
    }

    function formatDate(dateStr) {
        if (!dateStr) return "";
        var date = new Date(dateStr);
        var year = date.getFullYear();
        var month = String(date.getMonth() + 1).padStart(2, '0');
        var day = String(date.getDate()).padStart(2, '0');
        var hours = String(date.getHours()).padStart(2, '0');
        var minutes = String(date.getMinutes()).padStart(2, '0');
        return `\${year}-\${month}-\${day} \${hours}:\${minutes}`;
    }
</script>

</body>
</html>
