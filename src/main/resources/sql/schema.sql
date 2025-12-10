CREATE DATABASE IF NOT EXISTS ningbo DEFAULT CHARSET utf8mb4;

USE ningbo;

CREATE TABLE IF NOT EXISTS user_info
(
    id          INT AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
    username    VARCHAR(50)  NOT NULL UNIQUE COMMENT '用户名',
    password    VARCHAR(100) NOT NULL COMMENT '密码',
    real_name   VARCHAR(50) COMMENT '真实姓名',
    email       VARCHAR(100) COMMENT '邮箱',
    phone       VARCHAR(20) COMMENT '电话',
    avatar      VARCHAR(255) COMMENT '头像图片路径',
    role        VARCHAR(10) DEFAULT 'user' COMMENT '角色: user/admin',
    create_time TIMESTAMP   DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间'
) COMMENT '用户信息表';

CREATE TABLE IF NOT EXISTS ningbo_food
(
    id          INT AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
    food_name   VARCHAR(100) NOT NULL COMMENT '美食名称',
    description TEXT COMMENT '美食介绍',
    price       DECIMAL(10, 2) COMMENT '参考价格',
    location    VARCHAR(200) COMMENT '推荐地点',
    food_image  VARCHAR(255) COMMENT '美食图片路径'
) COMMENT '家乡美食表';

CREATE TABLE IF NOT EXISTS ningbo_scenery
(
    id            INT AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
    scenery_name  VARCHAR(100) NOT NULL COMMENT '景点名称',
    description   TEXT COMMENT '景点介绍',
    address       VARCHAR(200) COMMENT '详细地址',
    ticket_price  VARCHAR(50) COMMENT '门票价格',
    open_hours    VARCHAR(100) COMMENT '开放时间',
    scenery_image VARCHAR(255) COMMENT '景点图片路径'
) COMMENT '家乡景点表';

CREATE TABLE IF NOT EXISTS ningbo_culture
(
    id             INT AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
    culture_title  VARCHAR(100) NOT NULL COMMENT '文化标题',
    content        TEXT COMMENT '详细内容',
    history_period VARCHAR(100) COMMENT '历史时期',
    significance   VARCHAR(200) COMMENT '文化意义',
    culture_image  VARCHAR(255) COMMENT '相关图片路径'
) COMMENT '家乡文化表';

CREATE TABLE `ningbo_guestbook`
(
    `id`          int(11) NOT NULL AUTO_INCREMENT,
    `nickname`    varchar(50)  DEFAULT NULL COMMENT '留言人昵称',
    `content`     varchar(500) DEFAULT NULL COMMENT '留言内容',
    `create_time` datetime     DEFAULT CURRENT_TIMESTAMP COMMENT '留言时间',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='留言板';