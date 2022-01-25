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
    case db_verson_key  //数据库版本号
    
}

//初始数据库版本号，当数据库第一次创建并建立表之后，插入数据库版本号`1.0.0`
let db_OriginVersion = "1.0.0"
