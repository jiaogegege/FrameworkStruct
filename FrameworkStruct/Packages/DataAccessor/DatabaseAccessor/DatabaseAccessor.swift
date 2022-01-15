//
//  DatabaseAccessor.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/1/15.
//

import UIKit

class DatabaseAccessor: OriginAccessor
{
    //MARK: 属性
    //单例
    static let shared = DatabaseAccessor()
    
    //数据库对象
    var database: FMDatabase!
    
    
    //MARK: 方法
    //私有化初始化方法
    private override init()
    {
        super.init()
    }
    
    override func copy() -> Any
    {
        return self
    }
        
    override func mutableCopy() -> Any
    {
        return self
    }
    
    //返回数据源相关信息
    override func accessorDataSourceInfo() -> Dictionary<String, String> {
        let infoDict = ["type": "database"]
        return infoDict
    }
    
}


//接口方法
extension DatabaseAccessor: ExternalInterface
{
    
}
