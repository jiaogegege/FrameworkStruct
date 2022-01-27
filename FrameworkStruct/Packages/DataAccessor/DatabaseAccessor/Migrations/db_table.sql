DROP TABLE IF EXISTS `app_user`;
CREATE TABLE `app_user` (
`id` varchar(128) PRIMARY KEY NOT NULL,
`user_phone` varchar(100) DEFAULT NULL,
`user_password` varchar(255) DEFAULT NULL,
`delete_flag` tinyint(4) DEFAULT '0',
`update_date` datetime DEFAULT NULL,
`create_date` datetime DEFAULT NULL
);

DROP TABLE IF EXISTS `app_user_config`;
CREATE TABLE `app_user_config` (
`id` varchar(128) PRIMARY KEY NOT NULL,
`app_user_id` varchar(128) DEFAULT NULL,
`is_perfect` tinyint(4) DEFAULT '0',
`real_name` varchar(255) DEFAULT NULL,
`nick_name` varchar(255) DEFAULT NULL,
`sex` varchar(8) DEFAULT NULL,
`birthday` datetime DEFAULT NULL,
`height` double DEFAULT NULL,
`weight` double DEFAULT NULL,
`province` varchar(255) DEFAULT NULL,
`city` varchar(255) DEFAULT NULL,
`area` varchar(255) DEFAULT NULL,
`head_pic` varchar(512) DEFAULT NULL,
`first_login` tinyint(4) DEFAULT '0',
`delete_flag` tinyint(4) DEFAULT '0',
`update_date` datetime DEFAULT NULL,
`create_date` datetime DEFAULT NULL
);

DROP TABLE IF EXISTS `app_config`;
CREATE TABLE `app_config` (
`id` varchar(128) PRIMARY KEY NOT NULL,
`app_user_id` varchar(128) DEFAULT NULL,
`config_key` varchar(255) DEFAULT NULL,
`config_value` varchar(512) DEFAULT NULL,
`ext_column_one` varchar(512) DEFAULT NULL,
`ext_column_two` varchar(512) DEFAULT NULL,
`delete_flag` tinyint(4) DEFAULT '0',
`update_date` datetime DEFAULT NULL,
`create_date` datetime DEFAULT NULL
);
