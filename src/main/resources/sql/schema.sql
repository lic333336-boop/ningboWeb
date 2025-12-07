CREATE DATABASE IF NOT EXISTS ningbo DEFAULT CHARSET utf8mb4;

USE ningbo;

CREATE TABLE IF NOT EXISTS user_info (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(100) NOT NULL COMMENT '密码',
    real_name VARCHAR(50) COMMENT '真实姓名',
    email VARCHAR(100) COMMENT '邮箱',
    phone VARCHAR(20) COMMENT '电话',
    avatar VARCHAR(255) COMMENT '头像图片路径',
    role VARCHAR(10) DEFAULT 'user' COMMENT '角色: user/admin',
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间'
) COMMENT '用户信息表';

CREATE TABLE IF NOT EXISTS ningbo_food (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
    food_name VARCHAR(100) NOT NULL COMMENT '美食名称',
    description TEXT COMMENT '美食介绍',
    price DECIMAL(10, 2) COMMENT '参考价格',
    location VARCHAR(200) COMMENT '推荐地点',
    food_image VARCHAR(255) COMMENT '美食图片路径'
) COMMENT '家乡美食表';

CREATE TABLE IF NOT EXISTS ningbo_scenery (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
    scenery_name VARCHAR(100) NOT NULL COMMENT '景点名称',
    description TEXT COMMENT '景点介绍',
    address VARCHAR(200) COMMENT '详细地址',
    ticket_price VARCHAR(50) COMMENT '门票价格',
    open_hours VARCHAR(100) COMMENT '开放时间',
    scenery_image VARCHAR(255) COMMENT '景点图片路径'
) COMMENT '家乡景点表';

CREATE TABLE IF NOT EXISTS ningbo_culture (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
    culture_title VARCHAR(100) NOT NULL COMMENT '文化标题',
    content TEXT COMMENT '详细内容',
    history_period VARCHAR(100) COMMENT '历史时期',
    significance VARCHAR(200) COMMENT '文化意义',
    culture_image VARCHAR(255) COMMENT '相关图片路径'
) COMMENT '家乡文化表';

# USE ningbo;

-- 1. 用户信息测试数据
-- 密码建议存储加密后的，这里为了测试方便存明文，真实项目请加密
# DELETE FROM user_info;
# INSERT INTO user_info (username, password, real_name, email, phone, role) VALUES
#                                                                               ('admin', '123456', '系统管理员', 'admin@ningbo.com', '13800138000', 'admin'),
#                                                                               ('student', '123456', '李同学', 'student@ningbo.com', '13900139000', 'user');
#
# -- 2. 家乡美食测试数据
# DELETE FROM ningbo_food;
# INSERT INTO ningbo_food (food_name, description, price, location, food_image) VALUES
#                                                                                   ('宁波汤圆', '宁波汤圆是浙江省宁波市的一种著名小吃，历史悠久。主要原料是糯米粉和黑芝麻猪油馅，口感软糯香甜。', 25.00, '缸鸭狗 (天一广场店)', '/images/tangyuan.jpg'),
#                                                                                   ('红膏呛蟹', '红膏呛蟹是宁波菜的代表作之一，选用鲜活梭子蟹，经盐水腌制而成，咸鲜滑嫩，下饭神器。', 88.00, '宁海食府', '/images/qiangxie.jpg'),
#                                                                                   ('宁波年糕', '宁波慈城年糕最负盛名，洁白如玉，口感软韧。可以炒食也可以煮汤，荠菜肉丝炒年糕是一绝。', 18.00, '慈城古镇', '/images/niangao.jpg'),
#                                                                                   ('冰糖甲鱼', '冰糖甲鱼是宁波十大名菜之首，色泽红亮，口感软糯滋补，咸甜适口，独具风味。', 128.00, '状元楼', '/images/jiayu.jpg');
#
# -- 3. 家乡景点测试数据
# DELETE FROM ningbo_scenery;
# INSERT INTO ningbo_scenery (scenery_name, description, address, ticket_price, open_hours, scenery_image) VALUES
#                                                                                                              ('天一阁', '中国现存最早的私家藏书楼，也是亚洲现有最古老的图书馆和世界最早的三大家族图书馆之一。', '宁波市海曙区天一街10号', '30元', '08:30-17:30', '/images/tianyige.jpg'),
#                                                                                                              ('老外滩', '比上海外滩历史更悠久，拥有大量欧式建筑，现在是宁波著名的酒吧街和时尚地标。', '宁波市江北区中马路', '免费', '全天开放', '/images/waitan.jpg'),
#                                                                                                              ('溪口雪窦山', '国家5A级旅游景区，蒋氏故里，拥有全球最高的露天弥勒大佛。', '宁波市奉化区溪口镇', '210元', '08:00-17:00', '/images/xikou.jpg'),
#                                                                                                              ('东钱湖', '浙江省最大的天然淡水湖，被郭沫若先生誉为“西湖风光，太湖气魄”。', '宁波市鄞州区东钱湖镇', '免费 (部分景点收费)', '全天开放', '/images/dongqianhu.jpg');
#
# -- 4. 家乡文化测试数据
# DELETE FROM ningbo_culture;
# INSERT INTO ningbo_culture (culture_title, content, history_period, significance, culture_image) VALUES
#                                                                                                      ('河姆渡文化', '河姆渡遗址的发现，证明了长江流域和黄河流域一样都是中华文明的发祥地。出土了大量人工栽培水稻和干栏式建筑遗迹。', '新石器时代 (距今约7000年)', '改写了中国文明史，证明长江流域是中华文明摇篮之一', '/images/hemudu.jpg'),
#                                                                                                      ('十里红妆', '宁海地区的传统婚俗，嫁妆队伍绵延数里，极尽奢华，展现了浙东地区的精湛手工艺和婚嫁文化。', '明清时期', '国家级非物质文化遗产', '/images/hongzhuang.jpg'),
#                                                                                                      ('宁波商帮', '中国传统十大商帮之一，以“无宁不成市”闻名天下。在航运、金融、服装等行业影响巨大。', '近代', '推动了中国工商业的近代化发展', '/images/shangbang.jpg');