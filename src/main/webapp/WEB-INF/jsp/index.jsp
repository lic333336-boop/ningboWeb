<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>首页 - 宁波文化旅游网</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body { margin: 0; padding: 0; font-family: "微软雅黑", sans-serif; background-color: #f5f5f5; }
        .header { background-color: #001529; color: white; padding: 0 50px; height: 64px; display: flex; align-items: center; justify-content: space-between; }
        .logo { font-size: 20px; font-weight: bold; }
        .user-panel span { margin-right: 15px; font-size: 14px; }
        .btn-logout { cursor: pointer; color: #ff4d4f; text-decoration: underline; }
        .nav-menu { background: white; padding: 10px 50px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); display: flex; gap: 30px; }
        .nav-item { cursor: pointer; padding: 10px 0; color: #333; font-weight: 500; border-bottom: 2px solid transparent; }
        .nav-item.active { color: #1890ff; border-bottom: 2px solid #1890ff; }
        .nav-item:hover { color: #1890ff; }
        .main-content { width: 1000px; margin: 20px auto; background: white; padding: 30px; min-height: 500px; border-radius: 4px; }
        .search-area { display: flex; margin-bottom: 20px; border-bottom: 1px solid #eee; padding-bottom: 20px; }
        .search-area input { flex: 1; padding: 10px; border: 1px solid #ddd; border-radius: 4px 0 0 4px; outline: none; }
        .search-area button { padding: 10px 25px; background-color: #1890ff; color: white; border: none; border-radius: 0 4px 4px 0; cursor: pointer; }
        .item-card { display: flex; padding: 20px; border-bottom: 1px solid #f0f0f0; transition: background 0.2s; }
        .item-card:hover { background-color: #fafafa; }
        .item-img { width: 180px; height: 120px; object-fit: cover; border-radius: 4px; background-color: #eee; margin-right: 20px; }
        .item-info { flex: 1; }
        .item-title { font-size: 18px; color: #333; margin: 0 0 10px 0; font-weight: bold; }
        .item-desc { color: #666; font-size: 14px; line-height: 1.6; margin-bottom: 10px; }
        .item-meta { color: #999; font-size: 12px; }
        .price-tag { color: #f5222d; font-size: 16px; font-weight: bold; margin-right: 15px; }
    </style>
</head>
<body>

<div class="header">
    <div class="logo">🌊 宁波文化旅游</div>
    <div class="user-panel">
        <span id="welcomeUser">正在加载...</span>
        <span class="btn-logout" onclick="logout()">退出登录</span>
    </div>
</div>

<div class="nav-menu">
    <div class="nav-item active" onclick="switchTab('food')">家乡美食</div>
    <div class="nav-item" onclick="switchTab('scenery')">家乡景点</div>
    <div class="nav-item" onclick="switchTab('culture')">家乡文化</div>
</div>

<div class="main-content">
    <div class="search-area">
        <input type="text" id="searchInput" placeholder="请输入关键字搜索...">
        <button onclick="doSearch()">搜 索</button>
    </div>
    <div id="dataList">
        <p style="text-align:center; color:#999">数据加载中...</p>
    </div>
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
        loadData();
    });

    function switchTab(tabName) {
        currentTab = tabName;
        $(".nav-item").removeClass("active");
        if(tabName === 'food') $(".nav-item:eq(0)").addClass("active");
        if(tabName === 'scenery') $(".nav-item:eq(1)").addClass("active");
        if(tabName === 'culture') $(".nav-item:eq(2)").addClass("active");
        $("#searchInput").val("");
        loadData();
    }

    function doSearch() {
        loadData();
    }

    function logout() {
        if(confirm("确定要退出登录吗？")) {
            localStorage.removeItem("currentUser");
            window.location.href = "/login";
        }
    }

    function loadData() {
        var keyword = $("#searchInput").val();
        var apiUrl = "";
        if (currentTab === 'food') apiUrl = "/api/food/list";
        else if (currentTab === 'scenery') apiUrl = "/api/scenery/list";
        else if (currentTab === 'culture') apiUrl = "/api/culture/list";

        $.ajax({
            url: apiUrl, type: "GET", data: {keyword: keyword},
            success: function (res) {
                if (res.code === 1) {
                    renderList(res.data);
                } else {
                    $("#dataList").html("<p style='color:red'>加载失败：" + res.msg + "</p>");
                }
            },
            error: function () {
                $("#dataList").html("<p style='color:red'>服务器开小差了</p>");
            }
        });
    }
    function renderList(list) {
        if (!list || list.length === 0) {
            $("#dataList").html("<p style='text-align:center;padding:50px;color:#999'>暂无相关数据</p>");
            return;
        }
        var html = "";
        $.each(list, function(i, item) {
            var title = "", desc = "", img = "", meta = "";

            if (currentTab === 'food') {
                title = item.foodName;
                desc = item.description;
                img = item.foodImage;
                // 注意下面的 \${item.price}
                meta = `<span class="price-tag">￥\${item.price}</span> 📍 \${item.location}`;
            } else if (currentTab === 'scenery') {
                title = item.sceneryName;
                desc = item.description;
                img = item.sceneryImage;
                // 注意下面的 \${...}
                meta = `<span class="price-tag">门票: \${item.ticketPrice}</span> ⏰ \${item.openHours}`;
            } else if (currentTab === 'culture') {
                title = item.cultureTitle;
                desc = item.content;
                img = item.cultureImage;
                // 注意下面的 \${...}
                meta = `📅 \${item.historyPeriod}`;
            }

            if (!title) title = "暂无标题";
            if (!desc) desc = "暂无介绍";


            html += `
                <div class="item-card">
                    <img src="\${img}" class="item-img" onerror="this.src='https://via.placeholder.com/180x120?text=No+Img'">
                    <div class="item-info">
                        <h3 class="item-title">\${title}</h3>
                        <div class="item-desc">\${desc}</div>
                        <div class="item-meta">\${meta}</div>
                    </div>
                </div>
            `;
        });
            $("#dataList").html(html);
        }


</script>
</body>
</html>