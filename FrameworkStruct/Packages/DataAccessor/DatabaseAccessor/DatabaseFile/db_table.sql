DROP TABLE IF EXISTS `app_user`;
CREATE TABLE `app_user` (
`id` varchar(64) PRIMARY KEY NOT NULL,
`real_name` varchar(50) DEFAULT NULL,
`nick_name` varchar(50) DEFAULT NULL,
`sex` varchar(5) DEFAULT NULL,
`user_phone` varchar(100) DEFAULT NULL,
`user_password` varchar(255) DEFAULT NULL,
`birth_date` datetime DEFAULT NULL,
`head_pic` varchar(50) DEFAULT NULL,
`delete_flag` tinyint(4) DEFAULT '0',
`update_date` datetime DEFAULT NULL,
`create_date` datetime DEFAULT NULL
);

DROP TABLE IF EXISTS `app_user_config`;
CREATE TABLE `app_user_config` (
`id` varchar(64) PRIMARY KEY NOT NULL,
`app_user_id` varchar(64) DEFAULT NULL,
`is_perfect` tinyint(4) DEFAULT '0',
`province` varchar(20) DEFAULT NULL,
`city` varchar(20) DEFAULT NULL,
`area` varchar(20) DEFAULT NULL,
`height` double DEFAULT NULL,
`weight` double DEFAULT NULL,
`user_status` tinyint(4) DEFAULT NULL,
`first_login` tinyint(4) DEFAULT '0',
`delete_flag` tinyint(4) DEFAULT '0',
`update_date` datetime DEFAULT NULL,
`create_date` datetime DEFAULT NULL
);

DROP TABLE IF EXISTS `app_config`;
CREATE TABLE `app_config` (
`id` varchar(64) PRIMARY KEY NOT NULL,
`app_user_id` varchar(32) DEFAULT NULL,
`config_key` varchar(20) DEFAULT NULL,
`config_value` varchar(255) DEFAULT NULL,
`ext_column_one` varchar(255) DEFAULT NULL,
`ext_column_two` varchar(255) DEFAULT NULL,
`delete_flag` tinyint(4) DEFAULT '0',
`update_date` datetime DEFAULT NULL,
`create_date` datetime DEFAULT NULL
);
