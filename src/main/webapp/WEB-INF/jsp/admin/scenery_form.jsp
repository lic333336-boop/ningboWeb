<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>编辑景点 - 宁波文化旅游网</title>
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
    <a href="/admin/scenery" class="menu-item active">景点管理</a>
    <a href="/admin/culture" class="menu-item">文化管理</a>
    <a href="/admin/user" class="menu-item">用户管理</a>
</div>

<div class="main-content">
    <div class="form-card">
        <h2 id="pageTitle">新增景点</h2>
        <input type="hidden" id="sceneryId">

        <div class="form-group">
            <label>景点名称</label>
            <input type="text" class="form-control" id="sceneryName" placeholder="例如：天一阁">
        </div>

        <div class="form-group">
            <label>景点图片</label>
            <input type="file" class="form-control" id="fileInput">
            <input type="hidden" id="sceneryImage">
            <img id="preview" src="" style="max-width: 200px; margin-top: 10px; display: none;">
        </div>

        <div class="form-group">
            <label>门票价格</label>
            <input type="text" class="form-control" id="ticketPrice" placeholder="例如：30元 / 免费">
        </div>

        <div class="form-group">
            <label>开放时间</label>
            <input type="text" class="form-control" id="openHours" placeholder="例如：8:00 - 17:30">
        </div>

        <div class="form-group">
            <label>地址</label>
            <input type="text" class="form-control" id="address" placeholder="例如：宁波市海曙区...">
        </div>

        <div class="form-group">
            <label>景点简介</label>
            <textarea class="form-control" id="description" rows="4" placeholder="请输入简介..."></textarea>
        </div>

        <div style="text-align: right;">
            <button class="btn-submit" onclick="submitForm()">保存提交</button>
            <a href="/admin/scenery" class="btn-cancel">取消</a>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        checkLogin();
        var id = getUrlParam('id');
        if (id) {
            $("#pageTitle").text("编辑景点");
            $("#sceneryId").val(id);
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
            url: "/api/scenery/" + id,
            type: "GET",
            success: function (res) {
                if (res.code === 1) {
                    var data = res.data;
                    $("#sceneryName").val(data.sceneryName);
                    $("#sceneryImage").val(data.sceneryImage);
                    if (data.sceneryImage) {
                        $("#preview").attr("src", data.sceneryImage).show();
                    }
                    $("#ticketPrice").val(data.ticketPrice);
                    $("#openHours").val(data.openHours);
                    $("#address").val(data.address);
                    $("#description").val(data.description);
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
            saveData($("#sceneryImage").val());
        }
    }

    function saveData(imgUrl) {
        var id = $("#sceneryId").val();
        var data = {
            "sceneryName": $("#sceneryName").val(),
            "sceneryImage": imgUrl,
            "ticketPrice": $("#ticketPrice").val(),
            "openHours": $("#openHours").val(),
            "address": $("#address").val(),
            "description": $("#description").val()
        };

        var url = "/api/scenery/add";
        if (id) {
            url = "/api/scenery/update";
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
                    window.location.href = "/admin/scenery";
                } else {
                    alert("保存失败: " + res.msg);
                }
            }
        });
    }
</script>

</body>
</html>
