<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <meta charset="UTF-8" />
    <title>登录 - 宁波文化旅游网</title>
    <!-- 引入 jQuery (使用CDN) -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
      body {
        font-family: "微软雅黑", sans-serif;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        background-color: #f0f2f5;
      }
      .login-box {
        background: white;
        padding: 40px;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        width: 350px;
        text-align: center;
      }
      .login-box h2 {
        margin-bottom: 20px;
        color: #333;
      }
      .form-group {
        margin-bottom: 15px;
        text-align: left;
      }
      .form-group label {
        display: block;
        margin-bottom: 5px;
        color: #666;
      }
      .form-group input {
        width: 100%;
        padding: 10px;
        border: 1px solid #ddd;
        border-radius: 4px;
        box-sizing: border-box;
      }
      .btn {
        width: 100%;
        padding: 10px;
        background-color: #1890ff;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-size: 16px;
      }
      .btn:hover {
        background-color: #40a9ff;
      }
      .link {
        margin-top: 15px;
        display: block;
        color: #1890ff;
        text-decoration: none;
        font-size: 14px;
      }
      .error-msg {
        color: red;
        margin-bottom: 10px;
        display: none;
      }
    </style>
  </head>
  <body>
    <div class="login-box">
      <h2>用户登录</h2>
      <p class="error-msg" id="errorMsg"></p>

      <div class="form-group">
        <label>用户名</label>
        <input
          type="text"
          id="username"
          placeholder="请输入用户名 (admin/student)"
        />
      </div>
      <div class="form-group">
        <label>密码</label>
        <input
          type="password"
          id="password"
          placeholder="请输入密码 (123456)"
        />
      </div>

      <button class="btn" onclick="doLogin()">登 录</button>

      <a href="/register" class="link">没有账号？立即注册</a>
    </div>

    <script>
      function doLogin() {
        var username = $("#username").val();
        var password = $("#password").val();

        if (!username || !password) {
          $("#errorMsg").text("用户名和密码不能为空").show();
          return;
        }

        // 发送 AJAX 请求
        $.ajax({
          url: "/api/user/login",
          type: "POST",
          contentType: "application/json",
          data: JSON.stringify({
            username: username,
            password: password,
          }),

          success: function (res) {
            console.log("登录响应:", res);
            if (res.code === 1) {
              // 登录成功，保存用户信息到本地存储
              // [修改点] 将 "user" 改为 "currentUser" 以匹配 index.jsp
              localStorage.setItem("currentUser", JSON.stringify(res.data));

              // 根据角色跳转
              if (res.data.role === "admin") {
                window.location.href = "/admin";
              } else {
                window.location.href = "/index";
              }
            } else {
              $("#errorMsg")
                .text(res.msg || "登录失败，请检查用户名或密码")
                .show();
            }
          },
          error: function () {
            $("#errorMsg").text("网络错误，请稍后重试").show();
          },
        });
      }
    </script>
  </body>
</html>
