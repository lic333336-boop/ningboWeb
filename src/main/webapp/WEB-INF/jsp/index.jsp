<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8"/>
    <title>首页 - 宁波文化旅游网</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body { margin: 0; padding: 0; font-family: "微软雅黑", sans-serif; background-color: #f0f2f5; }
        .header { background-color: white; color: #333; padding: 0 50px; height: 64px; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 2px 8px rgba(0,0,0,0.06); position: sticky; top: 0; z-index: 100; }
        .logo { font-size: 22px; font-weight: bold; color: #1890ff; display: flex; align-items: center; }
        .logo img { height: 32px; margin-right: 10px; }
        .user-panel span { margin-right: 15px; font-size: 14px; }
        .btn-logout { cursor: pointer; color: #ff4d4f; }
        
        .banner { height: 300px; background: url('https://images.unsplash.com/photo-1548013146-72479768bada?q=80&w=2076&auto=format&fit=crop') center/cover; display: flex; align-items: center; justify-content: center; color: white; text-shadow: 0 2px 4px rgba(0,0,0,0.5); font-size: 36px; font-weight: bold; margin-bottom: 30px; }

        .container { width: 1200px; margin: 0 auto; padding-bottom: 50px; }
        
        .nav-menu { display: flex; justify-content: center; gap: 40px; margin-bottom: 30px; background: white; padding: 15px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.04); }
        .nav-item { cursor: pointer; font-size: 16px; font-weight: 500; color: #666; padding: 5px 10px; transition: all 0.3s; }
        .nav-item.active { color: #1890ff; font-weight: bold; border-bottom: 2px solid #1890ff; }
        .nav-item:hover { color: #1890ff; }

        .search-area { text-align: center; margin-bottom: 40px; }
        .search-area input { width: 400px; padding: 12px 20px; border: 1px solid #ddd; border-radius: 25px 0 0 25px; outline: none; font-size: 16px; transition: border 0.3s; }
        .search-area input:focus { border-color: #1890ff; }
        .search-area button { padding: 12px 30px; background-color: #1890ff; color: white; border: none; border-radius: 0 25px 25px 0; cursor: pointer; font-size: 16px; transition: background 0.3s; }
        .search-area button:hover { background-color: #40a9ff; }

        .grid-container { display: grid; grid-template-columns: repeat(4, 1fr); gap: 25px; }
        .card { background: white; border-radius: 8px; overflow: hidden; transition: transform 0.3s, box-shadow 0.3s; cursor: pointer; border: 1px solid #eee; display: flex; flex-direction: column; }
        .card:hover { transform: translateY(-5px); box-shadow: 0 8px 20px rgba(0,0,0,0.1); }
        .card-img { width: 100%; height: 180px; object-fit: cover; background-color: #f5f5f5; }
        .card-body { padding: 15px; flex: 1; display: flex; flex-direction: column; }
        .card-title { font-size: 18px; font-weight: bold; margin: 0 0 10px 0; color: #333; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .card-desc { font-size: 13px; color: #666; line-height: 1.5; margin-bottom: 15px; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden; flex: 1; }
        .card-meta { display: flex; justify-content: space-between; align-items: center; border-top: 1px solid #f0f0f0; padding-top: 10px; font-size: 12px; color: #999; }
        .price { color: #f5222d; font-size: 16px; font-weight: bold; }
        .btn-detail { background: #e6f7ff; color: #1890ff; padding: 4px 10px; border-radius: 4px; font-size: 12px; }
        .pagination { margin-top: 40px; display: flex; justify-content: center; }
        .page-item { padding: 8px 16px; border: 1px solid #d9d9d9; margin: 0 5px; cursor: pointer; border-radius: 4px; background: white; transition: all 0.3s; }
        .page-item:hover { color: #1890ff; border-color: #1890ff; }
        .page-item.active { background: #1890ff; color: white; border-color: #1890ff; }
        .page-item.disabled { background: #f5f5f5; color: #ccc; cursor: not-allowed; }
    </style>
</head>
<body>

<div class="header">
    <div class="logo">
        <img src="https://via.placeholder.com/32x32?text=NB" alt="Logo">
        宁波文化旅游
    </div>
    <div class="user-panel">
        <span id="welcomeUser">正在加载...</span>
        <span class="btn-logout" onclick="logout()">退出登录</span>
    </div>
</div>

<div class="banner">
    书藏古今，港通天下
</div>

<div class="container">
    <div class="search-area">
        <input type="text" id="searchInput" placeholder="搜索你感兴趣的美食、景点...">
        <button onclick="doSearch()">搜索</button>
    </div>

    <div class="nav-menu">
        <div class="nav-item active" onclick="switchTab('food')">家乡美食</div>
        <div class="nav-item" onclick="switchTab('scenery')">家乡景点</div>
        <div class="nav-item" onclick="switchTab('culture')">家乡文化</div>
    </div>

    <div id="dataList" class="grid-container">
        <!-- Cards will be injected here -->
    </div>
    <div id="pagination" class="pagination"></div>
</div>

<script>
    var currentTab = 'food';

    $(document).ready(function() {
        var userStr = localStorage.getItem("currentUser");
        if (!userStr) {
            window.location.href = "/login";
            return;
        }
        var user = JSON.parse(userStr);
        $("#welcomeUser").text("你好，" + (user.realName || user.username));
        
        // 如果是管理员，显示返回后台链接
        if(user.role === 'admin') {
            $(".user-panel").prepend('<a href="/admin" style="margin-right:15px; color:#1890ff; text-decoration:none;">进入后台</a>');
        }

        loadData();
    });

    function switchTab(tabName) {
        currentTab = tabName;
        $(".nav-item").removeClass("active");
        if(tabName === 'food') $(".nav-item:eq(0)").addClass("active");
        if(tabName === 'scenery') $(".nav-item:eq(1)").addClass("active");
        if(tabName === 'culture') $(".nav-item:eq(2)").addClass("active");
        $("#searchInput").val("");
        loadData(1);
    }

    function doSearch() {
        loadData(1);
    }

    function logout() {
        if(confirm("确定要退出登录吗？")) {
            localStorage.removeItem("currentUser");
            window.location.href = "/login";
        }
    }

    function loadData(page) {
        if (!page) page = 1;
        var keyword = $("#searchInput").val();
        var apiUrl = "";
        if (currentTab === 'food') apiUrl = "/api/food/list";
        else if (currentTab === 'scenery') apiUrl = "/api/scenery/list";
        else if (currentTab === 'culture') apiUrl = "/api/culture/list";

        $("#dataList").html('<p style="grid-column: 1 / -1; text-align:center; color:#999;">加载中...</p>');

        $.ajax({
            url: apiUrl, 
            type: "GET", 
            data: {
                keyword: keyword,
                page: page,
                limit: 8 // Front desk 8 data per page
            },
            success: function (res) {
                if (res.code === 1) {
                    renderGrid(res.data.list); // PageInfo contains list
                    renderPagination(res.data);
                } else {
                    $("#dataList").html("<p style='grid-column: 1 / -1; color:red; text-align:center;'>加载失败：" + res.msg + "</p>");
                }
            },
            error: function () {
                $("#dataList").html("<p style='grid-column: 1 / -1; color:red; text-align:center;'>服务器开小差了</p>");
            }
        });
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

    function renderGrid(list) {
        if (!list || list.length === 0) {
            $("#dataList").html("<p style='grid-column: 1 / -1; text-align:center; padding:50px; color:#999'>暂无相关数据</p>");
            return;
        }
        var html = "";
        $.each(list, function(i, item) {
            var title = "", desc = "", img = "", meta = "";

            if (currentTab === 'food') {
                title = item.foodName;
                desc = item.description;
                img = item.foodImage;
                meta = `<span class="price">￥\${item.price}</span> <span>\${item.location}</span>`;
            } else if (currentTab === 'scenery') {
                title = item.sceneryName;
                desc = item.description;
                img = item.sceneryImage;
                meta = `<span class="price">\${item.ticketPrice}</span> <span>\${item.openHours}</span>`;
            } else if (currentTab === 'culture') {
                title = item.cultureTitle;
                desc = item.content;
                img = item.cultureImage;
                meta = `<span>\${item.historyPeriod}</span>`;
            }

            if (!title) title = "暂无标题";
            if (!desc) desc = "暂无介绍";

            html += `
                <div class="card">
                    <img src="\${img}" class="card-img" onerror="this.src='https://via.placeholder.com/300x200?text=No+Img'">
                    <div class="card-body">
                        <h3 class="card-title" title="\${title}">\${title}</h3>
                        <div class="card-desc">\${desc}</div>
                        <div class="card-meta">
                            \${meta}
                            <!-- <span class="btn-detail">查看详情</span> -->
                        </div>
                    </div>
                </div>
            `;
        });
        $("#dataList").html(html);
    }
</script>
</body>
</html>