<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8"/>
    <title>留言板 - 宁波文化旅游网</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body { margin: 0; padding: 0; font-family: "微软雅黑", sans-serif; background-color: #f0f2f5; min-height: 100vh; display: flex; flex-direction: column; }
        .header { background-color: white; color: #333; padding: 0 50px; height: 64px; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 2px 8px rgba(0,0,0,0.06); position: sticky; top: 0; z-index: 100; }
        .logo { font-size: 22px; font-weight: bold; color: #1890ff; cursor: pointer; }
        .user-panel span { margin-right: 15px; font-size: 14px; }
        .btn-logout { cursor: pointer; color: #ff4d4f; }
        
        .container { width: 900px; margin: 30px auto; padding-bottom: 50px; flex: 1; }
        .page-title { text-align: center; font-size: 32px; font-weight: bold; color: #333; margin-bottom: 40px; }
        
        .message-form { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); margin-bottom: 30px; }
        .form-group { margin-bottom: 20px; }
        .form-label { display: block; margin-bottom: 8px; font-weight: 500; color: #333; }
        .form-input { width: 100%; padding: 12px; border: 1px solid #d9d9d9; border-radius: 4px; font-size: 14px; outline: none; box-sizing: border-box; }
        .form-input:focus { border-color: #1890ff; }
        .form-textarea { width: 100%; padding: 12px; border: 1px solid #d9d9d9; border-radius: 4px; font-size: 14px; outline: none; resize: vertical; min-height: 100px; box-sizing: border-box; font-family: inherit; }
        .form-textarea:focus { border-color: #1890ff; }
        .btn-submit { background: #1890ff; color: white; padding: 12px 40px; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; font-weight: 500; transition: background 0.3s; }
        .btn-submit:hover { background: #40a9ff; }
        .btn-back { background: #52c41a; color: white; padding: 12px 40px; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; font-weight: 500; margin-left: 15px; text-decoration: none; display: inline-block; }
        
        .message-list { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); }
        .list-title { font-size: 20px; font-weight: bold; color: #333; margin-bottom: 20px; padding-bottom: 15px; border-bottom: 2px solid #f0f0f0; }
        .message-item { padding: 20px 0; border-bottom: 1px solid #f0f0f0; }
        .message-item:last-child { border-bottom: none; }
        .message-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; }
        .message-nickname { font-weight: 500; color: #1890ff; font-size: 16px; }
        .message-time { color: #999; font-size: 13px; }
        .message-content { color: #333; font-size: 14px; line-height: 1.6; word-break: break-all; word-wrap: break-word; }
        .empty-message { text-align: center; padding: 60px 0; color: #999; font-size: 14px; }
        
        .pagination { margin-top: 30px; display: flex; justify-content: center; }
        .page-item { padding: 8px 16px; border: 1px solid #d9d9d9; margin: 0 5px; cursor: pointer; border-radius: 4px; background: white; transition: all 0.3s; }
        .page-item:hover { color: #1890ff; border-color: #1890ff; }
        .page-item.active { background: #1890ff; color: white; border-color: #1890ff; }
        .page-item.disabled { background: #f5f5f5; color: #ccc; cursor: not-allowed; }
        
        .footer { background: #001529; color: rgba(255,255,255,0.65); padding: 40px 0; text-align: center; margin-top: auto; }
        .footer p { margin: 8px 0; font-size: 14px; }
    </style>
</head>
<body>

<div class="header">
    <div class="logo" onclick="location.href='/index'">宁波文化旅游</div>
    <div class="user-panel">
        <span id="welcomeUser">正在加载...</span>
        <span class="btn-logout" onclick="logout()">退出登录</span>
    </div>
</div>

<div class="container">
    <h1 class="page-title">留言板</h1>
    
    <!-- 留言表单 -->
    <div class="message-form">
        <div class="form-group">
            <label class="form-label">昵称</label>
            <input type="text" id="nickname" class="form-input" placeholder="请输入您的昵称" maxlength="50">
        </div>
        <div class="form-group">
            <label class="form-label">留言内容</label>
            <textarea id="content" class="form-textarea" placeholder="请输入留言内容..." maxlength="500"></textarea>
        </div>
        <div style="text-align: right;">
            <a href="/index" class="btn-back">返回首页</a>
            <button class="btn-submit" onclick="submitMessage()">提交留言</button>
        </div>
    </div>
    
    <!-- 留言列表 -->
    <div class="message-list">
        <div class="list-title">全部留言</div>
        <div id="messageList">
            <div class="empty-message">加载中...</div>
        </div>
        <div id="pagination" class="pagination"></div>
    </div>
</div>

<div class="footer">
    <p>个人版权信息</p>
    <p>成员一 学号:23H034160125 姓名 李晨豪 邮箱:419289657@qq.com 电话:13857712790</p>
    <p>成员二 学号:23H034160105 姓名:蒋鈺 邮箱:3517460776@qq.com 电话:15257468755</p>
</div>

<script>
    $(document).ready(function() {
        checkLogin();
        loadMessages();
    });

    function checkLogin() {
        var userStr = localStorage.getItem("currentUser");
        if (!userStr) {
            window.location.href = "/login";
            return;
        }
        var user = JSON.parse(userStr);
        $("#welcomeUser").text("你好," + (user.realName || user.username));
        
        // 如果是管理员,显示返回后台链接
        if(user.role === 'admin') {
            $(".user-panel").prepend('<a href="/admin" style="margin-right:15px; color:#1890ff; text-decoration:none;">进入后台</a>');
        }
        
        // 自动填充昵称
        if (user.realName) {
            $("#nickname").val(user.realName);
        } else if (user.username) {
            $("#nickname").val(user.username);
        }
    }

    function logout() {
        if(confirm("确定要退出登录吗?")) {
            localStorage.removeItem("currentUser");
            window.location.href = "/login";
        }
    }

    function submitMessage() {
        var nickname = $("#nickname").val().trim();
        var content = $("#content").val().trim();
        
        if (!nickname) {
            alert("请输入昵称");
            return;
        }
        if (!content) {
            alert("请输入留言内容");
            return;
        }
        
        $.ajax({
            url: "/api/guestbook/add",
            type: "POST",
            contentType: "application/json",
            data: JSON.stringify({
                nickname: nickname,
                content: content
            }),
            success: function(res) {
                if (res.code === 1) {
                    alert("留言成功!");
                    $("#content").val(""); // 清空留言内容
                    loadMessages(1); // 重新加载第一页
                } else {
                    alert("留言失败: " + res.msg);
                }
            },
            error: function() {
                alert("服务器错误,请稍后重试");
            }
        });
    }

    function loadMessages(page) {
        if (!page) page = 1;
        
        $.ajax({
            url: "/api/guestbook/list",
            type: "GET",
            data: {
                page: page,
                limit: 10
            },
            success: function(res) {
                if (res.code === 1) {
                    renderMessages(res.data.list);
                    renderPagination(res.data);
                } else {
                    $("#messageList").html('<div class="empty-message">加载失败: ' + res.msg + '</div>');
                }
            },
            error: function() {
                $("#messageList").html('<div class="empty-message">服务器错误,请稍后重试</div>');
            }
        });
    }

    function renderMessages(list) {
        if (!list || list.length === 0) {
            $("#messageList").html('<div class="empty-message">还没有留言,快来抢沙发吧!</div>');
            return;
        }
        
        var html = "";
        $.each(list, function(i, item) {
            var time = formatDate(item.createTime);
            html += `
                <div class="message-item">
                    <div class="message-header">
                        <span class="message-nickname">\${item.nickname}</span>
                        <span class="message-time">\${time}</span>
                    </div>
                    <div class="message-content">\${item.content}</div>
                </div>
            `;
        });
        $("#messageList").html(html);
    }

    function renderPagination(pageInfo) {
        var html = "";
        
        // Prev
        if (pageInfo.hasPreviousPage) {
            html += `<span class="page-item" onclick="loadMessages(\${pageInfo.prePage})">上一页</span>`;
        } else {
            html += `<span class="page-item disabled">上一页</span>`;
        }
        
        // Pages
        $.each(pageInfo.navigatepageNums, function(i, num) {
            var activeClass = (num === pageInfo.pageNum) ? "active" : "";
            html += `<span class="page-item \${activeClass}" onclick="loadMessages(\${num})">\${num}</span>`;
        });
        
        // Next
        if (pageInfo.hasNextPage) {
            html += `<span class="page-item" onclick="loadMessages(\${pageInfo.nextPage})">下一页</span>`;
        } else {
            html += `<span class="page-item disabled">下一页</span>`;
        }
        
        $("#pagination").html(html);
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
