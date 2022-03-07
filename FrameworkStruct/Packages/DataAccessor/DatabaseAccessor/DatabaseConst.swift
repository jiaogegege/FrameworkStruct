//
//  DatabaseConst.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/1/15.
//

import Foundation

//数据库中存储的数据的key定义
typealias DBKeyType = String

//数据库中存储的一些数据的key
enum DatabaseKey: DBKeyType
{
    case dbVersion  //数据库版本号
    
}

//初始数据库版本号，当数据库第一次创建并建立表之后，插入数据库版本号`1_0_0`
let db_OriginVersion = "1_0_0"

//数据库更新版本号列表，和对应版本号的sql文件对应
let db_updateVersionList = ["1_0_1", "1_0_2"]
