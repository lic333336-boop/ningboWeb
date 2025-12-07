<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>编辑美食 - 宁波文化旅游网</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body { margin: 0; padding: 0; font-family: "微软雅黑", sans-serif; display: flex; height: 100vh; overflow: hidden; }
        .sidebar { width: 240px; background-color: #001529; color: white; display: flex; flex-direction: column; }
        .logo-area { height: 64px; display: flex; align-items: center; justify-content: center; font-size: 20px; font-weight: bold; background-color: #002140; }
        .menu-item { padding: 15px 25px; cursor: pointer; color: rgba(255,255,255,0.65); transition: all 0.3s; text-decoration: none; display: block; }
        .menu-item:hover, .menu-item.active { color: white; background-color: #1890ff; }
        .main-content { flex: 1; background-color: #f0f2f5; padding: 20px; overflow-y: auto; }
        .form-card { background: white; padding: 30px; border-radius: 4px; width: 600px; margin: 0 auto; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 500; }
        .form-control { width: 100%; padding: 10px; border: 1px solid #d9d9d9; border-radius: 4px; box-sizing: border-box; }
        .btn-submit { background-color: #1890ff; color: white; padding: 10px 30px; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; }
        .btn-cancel { background-color: #f5f5f5; color: #333; padding: 10px 30px; border: 1px solid #d9d9d9; border-radius: 4px; cursor: pointer; margin-left: 10px; text-decoration: none; display: inline-block; }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="logo-area">管理系统</div>
    <a href="/admin/food" class="menu-item active">美食管理</a>
    <a href="/admin/scenery" class="menu-item">景点管理</a>
    <a href="/admin/culture" class="menu-item">文化管理</a>
    <a href="/admin/user" class="menu-item">用户管理</a>
</div>

<div class="main-content">
    <div class="form-card">
        <h2 id="pageTitle">新增美食</h2>
        <input type="hidden" id="foodId">
        
        <div class="form-group">
            <label>美食名称</label>
            <input type="text" class="form-control" id="foodName" placeholder="例如：宁波汤圆">
        </div>
        
        <div class="form-group">
            <label>美食图片</label>
            <input type="file" class="form-control" id="fileInput">
            <input type="hidden" id="foodImage">
            <img id="preview" src="" style="max-width: 200px; margin-top: 10px; display: none;">
        </div>

        <div class="form-group">
            <label>价格</label>
            <input type="number" class="form-control" id="price" placeholder="0.00">
        </div>

        <div class="form-group">
            <label>推荐地点</label>
            <input type="text" class="form-control" id="location" placeholder="例如：缸鸭狗">
        </div>

        <div class="form-group">
            <label>美食简介</label>
            <textarea class="form-control" id="description" rows="4" placeholder="请输入简介..."></textarea>
        </div>

        <div style="text-align: right;">
            <button class="btn-submit" onclick="submitForm()">保存提交</button>
            <a href="/admin/food" class="btn-cancel">取消</a>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        checkLogin();
        // 获取URL参数id
        var id = getUrlParam('id');
        if (id) {
            $("#pageTitle").text("编辑美食");
            $("#foodId").val(id);
            loadDetail(id);
        }
    });

    function checkLogin() {
        var userStr = localStorage.getItem("currentUser");
        if (!userStr) { window.location.href = "/login"; return; }
        var user = JSON.parse(userStr);
        if (user.role !== 'admin') { window.location.href = "/index"; }
    }

    function getUrlParam(name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
        var r = window.location.search.substr(1).match(reg);
        if (r != null) return unescape(r[2]); return null;
    }

    function loadDetail(id) {
        $.ajax({
            url: "/api/food/" + id,
            type: "GET",
            success: function(res) {
                if (res.code === 1) {
                    var data = res.data;
                    $("#foodName").val(data.foodName);
                    $("#foodImage").val(data.foodImage);
                    if(data.foodImage) {
                        $("#preview").attr("src", data.foodImage).show();
                    }
                    $("#price").val(data.price);
                    $("#location").val(data.location);
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
                success: function(res) {
                    if (res.code === 1) {
                        saveData(res.data);
                    } else {
                        alert("图片上传失败: " + res.msg);
                    }
                },
                error: function() {
                    alert("图片上传网络错误");
                }
            });
        } else {
            saveData($("#foodImage").val());
        }
    }

    function saveData(imgUrl) {
        var id = $("#foodId").val();
        var data = {
            "foodName": $("#foodName").val(),
            "foodImage": imgUrl,
            "price": $("#price").val(),
            "location": $("#location").val(),
            "description": $("#description").val()
        };

        var url = "/api/food/add";
        if (id) {
            url = "/api/food/update";
            data.id = id;
        }

        $.ajax({
            url: url,
            type: "POST",
            contentType: "application/json",
            data: JSON.stringify(data),
            success: function(res) {
                if (res.code === 1) {
                    alert("保存成功");
                    window.location.href = "/admin/food";
                } else {
                    alert("保存失败: " + res.msg);
                }
            }
        });
    }
</script>

</body>
</html>
