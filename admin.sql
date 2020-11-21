CREATE DATABASE IF EXISTS car_project;

USE car_project;

-- 管理员表
CREATE TABLE admin(
  id INT PRIMARY KEY AUTO_INCREMENT COMMENT '管理员编号',
  account VARCHAR(10) NOT NULL COMMENT '账号',
  `password` VARCHAR(6) NOT NULL COMMENT '密码',
  header_img VARCHAR(100) NOT NULL COMMENT'头像',
  email VARCHAR(30) NOT NULL COMMENT '邮箱',
  phone VARCHAR(11) NOT NULL COMMENT '手机号'
)ENGINE=INNODB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8

SELECT IFNULL(MAX(log_id)+1,1) FROM admin_conlog

-- 管理员登录记录表
CREATE TABLE admin_conlog(
  log_id INT PRIMARY KEY AUTO_INCREMENT COMMENT'足迹编号',
  admin_id VARCHAR(10) NOT NULL COMMENT '管理员账号',
  log_time DATETIME NOT NULL COMMENT '登录时间',
  log_address VARCHAR(15) NOT NULL COMMENT'登录地点',
  log_ip VARCHAR(15) NOT NULL COMMENT '登录IP地址',
  log_hostname VARCHAR(50) NOT NULL COMMENT '登录的主机名'
  log_status BOOLEAN NOT NULL COMMENT'登录状态，是否异常，0 ：异常，1：正常'
)ENGINE=INNODB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4

SELECT log_address,log_ip,COUNT(*) AS counts FROM admin_conlog WHERE admin_id = 'admin' GROUP BY log_address AND log_ip ORDER BY counts DESC

SELECT * FROM admin_conlog

-- 查询出 admin_id 为 admin 的 7 天内的数据
SELECT * FROM admin_conlog WHERE DATE_SUB(CURDATE(),INTERVAL 7 DAY) <= DATE(log_time) AND admin_id = 'admin'

SELECT DATE_SUB(CURDATE(),INTERVAL 7 DAY)

DELETE FROM admin_conlog
-- 用户表
CREATE TABLE `USER`(
 user_id INT PRIMARY KEY AUTO_INCREMENT COMMENT'用户编号',
 username VARCHAR(20) NOT NULL COMMENT '用户昵称',
 `password` VARCHAR(20) NOT NULL COMMENT '用户密码',
 email VARCHAR(30) NOT NULL COMMENT '邮箱',
 brithday DATE DEFAULT NULL COMMENT '生日',
 sex CHAR(2) DEFAULT 2 COMMENT '0 = 男 1 = 女 2 = 保密', 
 CHECK(sex = '0' OR sex = '1' OR sex = '2')
)ENGINE=INNODB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8

-- 用户个人主页信息表
CREATE TABLE userInfo (
  id INT PRIMARY KEY AUTO_INCREMENT COMMENT'用户信息编号',
  userInfo_id INT NOT NULL COMMENT'用户编号',
  header_img_src VARCHAR(100) COMMENT'用户头像',
  home_bg_img_src VARCHAR(100) COMMENT '用户个人主页背景图片'
)ENGINE=INNODB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8
ALTER TABLE userInfo ADD CONSTRAINT FK_userInfo_id FOREIGN KEY (userInfo_id) REFERENCES USER(user_id) -- 用户个人主页 > 用户 一对一关系,使用 inner join 内连接查询
DESC USER

-- 订单表
CREATE TABLE `ORDER`(
 order_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '订单编号',
 user_id INT NOT NULL COMMENT '用户编号',
 goods_id INT NOT NULL COMMENT '商品编号',
  iphone VARCHAR(12) COMMENT '联系方式',
 address VARCHAR(200) COMMENT '地址',
 price FLOAT(6,2) COMMENT '订单总金额',
 order_time DATETIME COMMENT '下单时间',
 order_status CHAR(2) COMMENT '订单状态： 0 = 待发货 1=已发货 2=派送中 3=已收货 4 = 待评价 5 = 已评价 6 = 已退款'  
)ENGINE=INNODB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8
ALTER TABLE `ORDER` ADD CONSTRAINT FK_user_order_id FOREIGN KEY (user_id) REFERENCES `user`(user_id) -- 订单（n） > 用户 （1） 多对一关系
ALTER TABLE `ORDER` ADD CONSTRAINT FK_goods_order_id FOREIGN KEY (goods_id) REFERENCES `goods`(good_id) -- 订单（1） > 商品（n） 一对多关系

-- 商品分类表
CREATE TABLE goods_class (
  class_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '商品分类编号',
  class_name VARCHAR(50) NOT NULL  COMMENT '商品分类名称',
  `sort` INT NOT NULL COMMENT '排序',
  `status` BOOLEAN NOT NULL COMMENT'状态：是否启用，true : 启用，false : 关闭',
  `addTime` DATETIME NOT NULL COMMENT '添加时间'
)ENGINE=INNODB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8
SELECT IFNULL(MAX(class_id+1),1) FROM goods_class
SELECT * FROM goods_class

/* 删除商品分类操作*/
DROP PROCEDURE IF EXISTS `dropCategory`;
DELIMITER $$
CREATE PROCEDURE `dropCategory`(IN _class_id INT)
BEGIN
  START TRANSACTION;
	SET FOREIGN_KEY_CHECKS = 0;
	DELETE FROM goods_class WHERE class_id = _class_id;
	SET FOREIGN_KEY_CHECKS = 1;
  COMMIT;
END $$
DELIMITER $$

-- 商品表
CREATE TABLE goods (
 good_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '商品编号',
 good_name VARCHAR(100) NOT NULL COMMENT '商品名称',
 good_class_id INT NOT NULL COMMENT '商品分类编号',
 goods_brand_id INT NOT NULL COMMENT '所属品牌编号',
 good_price FLOAT(6.2) NOT NULL COMMENT '商品价格',
 good_inventory INT NOT NULL COMMENT '商品库存',
 good_product TEXT NOT NULL COMMENT '商品简介',
 good_sales INT NOT NULL COMMENT '已销售数量',
 good_evaluation INT NOT NULL COMMENT '已评价数量',
 good_img_src VARCHAR(100) NOT NULL COMMENT '商品版心图片路径'
)ENGINE=INNODB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8
SELECT * FROM goods AS g LEFT JOIN 
        goods_brand AS b ON g.goods_brand_id = b.goods_brand_id ORDER BY b.goods_brand_id DESC 

SELECT COUNT(4) FROM goods LIMIT 5
/*
 good_options_id INT NOT NULL COMMENT '商品参数表编号',
 video_src VARCHAR(100) NOT NULL COMMENT '商品详情视频路径',
 good_img_1 VARCHAR(100) NOT NULL COMMENT '商品详情图片路径1',
 good_img_2 VARCHAR(100) NOT NULL COMMENT '商品详情图片路径2',
 good_img_3 VARCHAR(100) NOT NULL COMMENT '商品详情图片路径3',
 good_img_4 VARCHAR(100) NOT NULL COMMENT '商品详情图片路径4',
 good_img_5 VARCHAR(100) NOT NULL COMMENT '商品详情图片路径5'
*/
ALTER TABLE goods ADD CONSTRAINT FK_goods_class_id_2 FOREIGN KEY (good_class_id) REFERENCES goods_class(class_id) -- 商品分类（1） > 商品（n） 一对多关系
ALTER TABLE goods ADD CONSTRAINT FK_goods_brand_id FOREIGN KEY (goods_brand_id) REFERENCES goods_brand(goods_brand_id)  -- 商品品牌（1） > 商品 （n） 一对多关系

-- 商品品牌表
CREATE TABLE goods_brand (
 goods_brand_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '商品品牌编号',
 goods_brand_name VARCHAR(20) NOT NULL COMMENT '商品品牌名称',
 goods_brand_img_src VARCHAR(100) NOT NULL COMMENT '商品品牌图片路径',
 goods_brand_describe VARCHAR(200) NOT NULL COMMENT '品牌描述',
 goods_brand_sort INT NOT NULL COMMENT '品牌数据排序',
 goods_brand_status BOOLEAN NOT NULL COMMENT '品牌状态：是否启用，true : 启用，false : 关闭',
 goods_brand_addTime DATETIME NOT NULL COMMENT '品牌添加时间'
)ENGINE=INNODB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8

SELECT * FROM goods_brand WHERE goods_brand_addTime IN (
                SELECT goods_brand_addTime FROM goods_brand WHERE DATE_FORMAT(goods_brand_addTime,'%Y-%m-%d') = '2020-02-11')
                ORDER BY goods_brand_sort LIMIT 6,6

/* 删除商品分类操作*/
DROP PROCEDURE IF EXISTS `dropBrand`;
DELIMITER $$
CREATE PROCEDURE `dropBrand`(IN _brand_id INT)
BEGIN
  START TRANSACTION;
	SET FOREIGN_KEY_CHECKS = 0;
	DELETE FROM goods_brand WHERE goods_brand_id = _brand_id;
	SET FOREIGN_KEY_CHECKS = 1;
  COMMIT;
END $$
DELIMITER $$

-- 商品参数表【用于商品详情页】
CREATE TABLE goods_options (
 good_options_id INT PRIMARY KEY AUTO_INCREMENT COMMENT'商品参数编号',
 good_id INT NOT NULL COMMENT'对应的商品编号',
 good_options_name VARCHAR(30) NOT NULL COMMENT '商品参数名',
 good_options_value VARCHAR(30) NOT NULL COMMENT '商品参数值'
)ENGINE=INNODB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8
ALTER TABLE goods_options ADD CONSTRAINT FK_good_options_id FOREIGN KEY (good_options_id) REFERENCES goods(good_id)

-- 评价关系表
CREATE TABLE user_evaluation_of_goods (
  evaluation_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '评价编号',
  user_evaluation_id INT NOT NULL COMMENT '用户编号',
  goods_evaluation_id INT NOT NULL COMMENT '商品编号'
)ENGINE=INNODB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8
ALTER TABLE user_evaluation_of_goods ADD CONSTRAINT FK_evaluation_user_id FOREIGN KEY (user_evaluation_id) REFERENCES `user`(user_id) -- 用户（1） > 用户评价（n） 一对多 关系
ALTER TABLE user_evaluation_of_goods ADD CONSTRAINT FK_evaluation_goods_id FOREIGN KEY (goods_evaluation_id) REFERENCES `goods`(good_id) -- 商品（1） > 用户评价（n） 一对多 关系


-- 商品收藏表
CREATE TABLE user_collection_of_goods (
 collection_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '收藏夹编号',
 user_collection_id INT NOT NULL COMMENT '用户编号',
 goods_collection_id INT NOT NULL COMMENT '商品编号'
)ENGINE=INNODB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8
ALTER TABLE user_collection_of_goods ADD CONSTRAINT FK_collection_user_id FOREIGN KEY (user_collection_id) REFERENCES `user`(user_id) -- 用户（1） > 用户收藏（n） 一对多 关系
ALTER TABLE user_collection_of_goods ADD CONSTRAINT FK_collection_goods_id FOREIGN KEY (goods_collection_id) REFERENCES `goods`(good_id) -- 商品（1） > 用户收藏（n） 一对多 关系

-- 网站首页版心图片表
CREATE TABLE banners(
 banner_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '版心图片编号',
 banner_product VARCHAR(100) NOT NULL COMMENT '版心图片含义',
 banner_img_src VARCHAR(100) NOT NULL COMMENT '版心图片路径'，
 banner_time DATETIME NOT NULL COMMENT '添加时间'
)ENGINE=INNODB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8

SELECT * FROM banners
-- 用户反馈表
CREATE TABLE User_feedback (
 feed_back_id INT PRIMARY KEY AUTO_INCREMENT COMMENT'反馈编号',
 user_id INT NOT NULL COMMENT'用户编号', -- 一对一关系 user_id > feedback_id 用户编号（1） > 用户反馈（1）
 feed_back_type CHAR(2) DEFAULT '0' NOT NULL COMMENT'反馈类型：0 界面设计改进，1 使用问题 ，2 商品信息问题，3 账号异常问题',
 CHECK (feed_back_type = '0' OR feed_back_type = '1' OR feed_back_type = '2' OR feed_back_type = '3'),
 feed_back_content TEXT NOT NULL COMMENT'反馈内容',
 feed_back_time DATETIME NOT NULL COMMENT'反馈时间',
 user_ipone VARCHAR(30) NOT NULL COMMENT'反馈用户联系方式',
 admin_id INT NOT NULL COMMENT '处理管理员编号',
 feedback_status BOOLEAN DEFAULT FALSE COMMENT '反馈处理状态' -- 默认为 FALSE,一旦管理员回复了此反馈单，则状态为 TRUE
)ENGINE=INNODB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8
ALTER TABLE User_feedback ADD CONSTRAINT FK_feedback_id FOREIGN KEY (admin_id) REFERENCES admin(id)

-- 管理员回复表（针对用户反馈）
CREATE TABLE Admin_feedback (
  admin_feed_id INT PRIMARY KEY AUTO_INCREMENT COMMENT'处理反馈编号',
  feed_back_id INT NOT NULL COMMENT'反馈单编号', -- 一对一关系 admin_feed_id > feed_back_id 管理员处理反馈编号（1） > 反馈单编号（1）
  admin_feed_content TEXT NOT NULL COMMENT '反馈处理内容', -- 用于发送给用户通知
  admin_feed_time DATETIME NOT NULL COMMENT'反馈处理时间',
  user_IS_read BOOLEAN DEFAULT FALSE COMMENT'用户是否已读此消息' -- 用于即时提示用户读取消息。
)ENGINE=INNODB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8
ALTER TABLE Admin_feedback ADD CONSTRAINT FK_Admin_feedback FOREIGN KEY (admin_feed_id) REFERENCES User_feedback(feed_back_id)

UPDATE Admin_feedback SET user_IS_read = FALSE;
SELECT * FROM Admin_feedback
SELECT admin_id FROM Admin_feedback AS A 
        LEFT JOIN User_feedback AS U ON A.feed_back_id = U.feed_back_id WHERE U.user_id = 1 AND A.user_IS_read = FALSE
-- 查看已解决的用户反馈
SELECT * FROM Admin_feedback AS F LEFT JOIN User_feedback  AS u ON u.feed_back_id = F.feed_back_id WHERE u.feed_back_type = 1 LIMIT 1
SELECT * FROM Admin_feedback AS F LEFT JOIN User_feedback  AS u ON u.feed_back_id = F.feed_back_id WHERE u.feed_back_type = 4
SELECT * FROM User_feedback WHERE feedback_status = TRUE
SELECT *  FROM Admin_feedback AS A LEFT JOIN User_feedback AS U ON A.feed_back_id = U.feed_back_id WHERE U.user_id = 1
SELECT * FROM User_feedback AS F 
    LEFT JOIN USER  AS u ON u.user_id = F.user_id WHERE admin_id = 1 AND F.feedback_status = false