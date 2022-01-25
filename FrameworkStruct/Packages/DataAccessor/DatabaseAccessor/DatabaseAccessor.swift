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
    fileprivate var database: FMDatabase!
    //数据库操作队列
    fileprivate var dbQueue: FMDatabaseQueue!
    
    
    //MARK: 方法
    //私有化初始化方法
    private override init()
    {
        super.init()
        //数据库文件路径
        let dbPath = SandBoxAccessor.getDatabasePath()
        //判断数据库文件是否存在
        let isDbExist = SandBoxAccessor.shared.isExist(path: dbPath)
        
        //创建或获取数据库，如果数据库文件不存在，则自动创建
        self.database = FMDatabase(path: dbPath)
        //创建数据库操作队列
        self.dbQueue = FMDatabaseQueue(path: dbPath)
        
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
