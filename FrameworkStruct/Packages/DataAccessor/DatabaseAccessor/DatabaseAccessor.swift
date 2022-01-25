//
//  DatabaseAccessor.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/1/15.
//

/**
 * 数据库存取器
 *
 * 概述：对SQLite数据库进行存取和相关资源的管理，使用FMDatabaseQueue进行数据库操作，线程安全，支持数据库迁移和升级
 *
 * - Parameters:
 *  - <#参数1#>: <#说明#>
 *
 * - Returns: <#说明#>
 *
 * 注意事项：<#说明#>
 *
 */
import UIKit

class DatabaseAccessor: OriginAccessor
{
    //MARK: 属性
    //单例
    static let shared = DatabaseAccessor()

    //数据库操作队列对象
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
        
        //创建数据库操作队列对象
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
