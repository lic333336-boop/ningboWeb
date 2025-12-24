<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>编辑文化 - 宁波文化旅游网</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: "微软雅黑", sans-serif;
            display: flex;
            height: 100vh;
            overflow: hidden;
        }

        .sidebar {
            width: 240px;
            background-color: #001529;
            color: white;
            display: flex;
            flex-direction: column;
        }

        .logo-area {
            height: 64px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            font-weight: bold;
            background-color: #002140;
        }

        .menu-item {
            padding: 15px 25px;
            cursor: pointer;
            color: rgba(255, 255, 255, 0.65);
            transition: all 0.3s;
            text-decoration: none;
            display: block;
        }

        .menu-item:hover, .menu-item.active {
            color: white;
            background-color: #1890ff;
        }

        .main-content {
            flex: 1;
            background-color: #f0f2f5;
            padding: 20px;
            overflow-y: auto;
        }

        .form-card {
            background: white;
            padding: 30px;
            border-radius: 4px;
            width: 600px;
            margin: 0 auto;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
        }

        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #d9d9d9;
            border-radius: 4px;
            box-sizing: border-box;
        }

        .btn-submit {
            background-color: #1890ff;
            color: white;
            padding: 10px 30px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }

        .btn-cancel {
            background-color: #f5f5f5;
            color: #333;
            padding: 10px 30px;
            border: 1px solid #d9d9d9;
            border-radius: 4px;
            cursor: pointer;
            margin-left: 10px;
            text-decoration: none;
            display: inline-block;
        }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="logo-area">管理系统</div>
    <a href="/admin/food" class="menu-item">美食管理</a>
    <a href="/admin/scenery" class="menu-item">景点管理</a>
    <a href="/admin/culture" class="menu-item active">文化管理</a>
    <a href="/admin/user" class="menu-item">用户管理</a>
</div>

<div class="main-content">
    <div class="form-card">
        <h2 id="pageTitle">新增文化</h2>
        <input type="hidden" id="cultureId">

        <div class="form-group">
            <label>文化标题</label>
            <input type="text" class="form-control" id="cultureTitle" placeholder="例如：宁波商帮">
        </div>

        <div class="form-group">
            <label>文化图片</label>
            <input type="file" class="form-control" id="fileInput">
            <input type="hidden" id="cultureImage">
            <img id="preview" src="" style="max-width: 200px; margin-top: 10px; display: none;">
        </div>

        <div class="form-group">
            <label>历史时期</label>
            <input type="text" class="form-control" id="historyPeriod" placeholder="例如：明清时期">
        </div>

        <div class="form-group">
            <label>文化意义</label>
            <textarea class="form-control" id="significance" rows="2" placeholder="简述文化意义..."></textarea>
        </div>

        <div class="form-group">
            <label>详细内容</label>
            <textarea class="form-control" id="content" rows="4" placeholder="请输入详细介绍..."></textarea>
        </div>

        <div style="text-align: right;">
            <button class="btn-submit" onclick="submitForm()">保存提交</button>
            <a href="/admin/culture" class="btn-cancel">取消</a>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        checkLogin();
        var id = getUrlParam('id');
        if (id) {
            $("#pageTitle").text("编辑文化");
            $("#cultureId").val(id);
            loadDetail(id);
        }
    });

    function checkLogin() {
        var userStr = localStorage.getItem("currentUser");
        if (!userStr) {
            window.location.href = "/login";
            return;
        }
        var user = JSON.parse(userStr);
        if (user.role !== 'admin') {
            window.location.href = "/index";
        }
    }

    function getUrlParam(name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
        var r = window.location.search.substr(1).match(reg);
        if (r != null) return unescape(r[2]);
        return null;
    }

    function loadDetail(id) {
        $.ajax({
            url: "/api/culture/" + id,
            type: "GET",
            success: function (res) {
                if (res.code === 1) {
                    var data = res.data;
                    $("#cultureTitle").val(data.cultureTitle);
                    $("#cultureImage").val(data.cultureImage);
                    if (data.cultureImage) {
                        $("#preview").attr("src", data.cultureImage).show();
                    }
                    $("#historyPeriod").val(data.historyPeriod);
                    $("#significance").val(data.significance);
                    $("#content").val(data.content);
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
                success: function (res) {
                    if (res.code === 1) {
                        saveData(res.data);
                    } else {
                        alert("图片上传失败: " + res.msg);
                    }
                },
                error: function () {
                    alert("图片上传网络错误");
                }
            });
        } else {
            saveData($("#cultureImage").val());
        }
    }

    function saveData(imgUrl) {
        var id = $("#cultureId").val();
        var data = {
            "cultureTitle": $("#cultureTitle").val(),
            "cultureImage": imgUrl,
            "historyPeriod": $("#historyPeriod").val(),
            "significance": $("#significance").val(),
            "content": $("#content").val()
        };

        var url = "/api/culture/add";
        if (id) {
            url = "/api/culture/update";
            data.id = id;
        }

        $.ajax({
            url: url,
            type: "POST",
            contentType: "application/json",
            data: JSON.stringify(data),
            success: function (res) {
                if (res.code === 1) {
                    alert("保存成功");
                    window.location.href = "/admin/culture";
                } else {
                    alert("保存失败: " + res.msg);
                }
            }
        });
    }
</script>

</body>
</html>
