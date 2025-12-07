<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>注册 - 宁波文化旅游网</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body { font-family: "微软雅黑", sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; background-color: #f0f2f5; }
        .reg-box { background: white; padding: 40px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); width: 350px; }
        .reg-box h2 { text-align: center; margin-bottom: 20px; color: #333; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; color: #666; }
        .form-group input { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
        .btn { width: 100%; padding: 10px; background-color: #52c41a; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; margin-top: 10px; }
        .btn:hover { background-color: #73d13d; }
        .link { margin-top: 15px; display: block; text-align: center; color: #1890ff; text-decoration: none; font-size: 14px; }
    </style>
</head>
<body>

<div class="reg-box">
    <h2>新用户注册</h2>

    <div class="form-group">
        <label>用户名</label>
        <input type="text" id="username">
    </div>
    <div class="form-group">
        <label>密码</label>
        <input type="password" id="password">
    </div>
    <div class="form-group">
        <label>真实姓名</label>
        <input type="text" id="realName">
    </div>
    <div class="form-group">
        <label>手机号</label>
        <input type="text" id="phone">
    </div>

    <button class="btn" onclick="doRegister()">注 册</button>
    <a href="/login" class="link">已有账号？去登录</a>
</div>

<script>
    function doRegister() {
        var data = {
            username: $("#username").val(),
            password: $("#password").val(),
            realName: $("#realName").val(),
            phone: $("#phone").val()
        };

        if(!data.username || !data.password) {
            alert("用户名和密码必填");
            return;
        }

        $.ajax({
            url: "/api/user/register",
            type: "POST",
            contentType: "application/json",
            data: JSON.stringify(data),
            success: function(res) {
                if (res.code === 1) {
                    alert("注册成功！即将跳转登录页");
                    window.location.href = "/login";
                } else {
                    alert("注册失败：" + res.msg);
                }
            },
            error: function() {
                alert("请求出错");
            }
        });
    }
</script>

</body>
</html>