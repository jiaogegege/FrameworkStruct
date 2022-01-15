//
//  DatabaseConst.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/1/15.
//

import Foundation

//数据库中存储的数据的key定义
typealias DBKeyType = String


//数据库版本号
enum DatabaseKey: DBKeyType
{
    case db_verson_key  //数据库版本号
    
}
