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
    fileprivate var dbQueue: FMDatabaseQueue?
    
    
    //MARK: 方法
    //私有化初始化方法
    private override init()
    {
        super.init()
        //数据库文件路径
        let dbPath = SandBoxAccessor.getDatabasePath()
        FSLog(dbPath)
        //判断数据库文件是否存在
        let isDbExist = SandBoxAccessor.shared.isExist(path: dbPath)
        
        //创建数据库操作队列对象，如果返回nil，说明创建不成功，一般都会成功
        self.dbQueue = FMDatabaseQueue(path: dbPath)
        
        //如果打开不成功，那么打印错误信息
        guard self.dbQueue != nil else {
            FSLog("创建数据库失败")
            return
        }
        
        //如果打开成功，那么继续接下来的操作
        
        //如果不存在数据库文件，那么说明数据库还没创建过，那么创建数据库表
        if !isDbExist
        {
            self.createDbTable()
        }
        
        //查询数据库版本号，判断是否要更新数据库
        
    }
    
    override func copy() -> Any
    {
        return self
    }
        
    override func mutableCopy() -> Any
    {
        return self
    }
    
    //创建数据库表
    fileprivate func createDbTable()
    {
        if let path = SandBoxAccessor.getSQLFilePath(fileName: sdDatabaseOriginSQLFile)
        {
            //获取文件内容
            do {
                var sqlContent = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue) as String
                sqlContent = self.trimSqlString(originStr: sqlContent)
                //分割sql语句
                let sqlArr = sqlContent.components(separatedBy: ";")
                //执行sql语句
                for str in sqlArr
                {
                    let sql = str.trim()
                    if isValidString(sql)   //如果是有效字符串，那么执行sql语句
                    {
                        self.update(sql: sql) { ret in
                            if ret == false
                            {
                                FSLog("create table error: " + sql)
                            }
                        }
                    }
                }
            }
            catch {
                FSLog(error.localizedDescription)
            }
        }
        else
        {
            FSLog("get db table struct sql file error")
        }
    }
    
    //处理sql字符串，去除换行和头尾空格
    fileprivate func trimSqlString(originStr: String) -> String
    {
        var str = originStr.replacingOccurrences(of: "\r\n", with: "\n")
        str = str.replacingOccurrences(of: "\\n", with: "\n")
        str = str.replacingOccurrences(of: "\n", with: "\n")
        str = str.replacingOccurrences(of: "\r", with: "")
        return str
    }
    
    //查询数据库版本号，并判断是否要更新版本
    fileprivate func checkAndUpdateDbVersion()
    {
        
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
    /**************************************** 通用基础方法 Section Begin **************************************/
    ///执行一条Update的sql语句
    func update(sql: String, callback: ((_ ret: Bool) -> Void)?)
    {
        if let queue = self.dbQueue
        {
            queue.inDatabase { db in
                do {
                    try db.executeUpdate(sql, values: nil)
                    if let cb = callback
                    {
                        cb(true)
                    }
                } catch {
                    FSLog("db update error: " + error.localizedDescription)
                    if let cb = callback
                    {
                        cb(false)
                    }
                }
            }
        }
    }
    
    ///执行一条query的sql语句
    ///如果发生了错误，那么回传false和nil
    func query(sql: String, callback: ((_ ret: Bool, _ result: FMResultSet?) -> Void))
    {
        if let queue = self.dbQueue
        {
            queue.inDatabase { db in
                do {
                    let ret = try db.executeQuery(sql, values: nil)
                    callback(true, ret)
                } catch {
                    FSLog("db query error: " + error.localizedDescription)
                    //如果发生异常，那么回传false
                    callback(false, nil)
                }
            }
        }
    }
    
    ///在事务中执行多条update语句
    ///参数：sqls：要执行的sql语句数组；callback：回调，返回执行是否成功,如果不成功则回滚
    ///完整的sql语句在传入时就拼接好
    func transactionUpdate(sqls: Array<String>, callback: ((_ ret: Bool) -> Void)?)
    {
        if let queue = self.dbQueue
        {
            queue.inTransaction { db, rollback in
                do {
                    for sql in sqls
                    {
                        try db.executeUpdate(sql, values: nil)
                    }
                    //全部执行完后，执行回调
                    if let cb = callback
                    {
                        cb(true)
                    }
                } catch {
                    FSLog("db update error: " + error.localizedDescription)
                    rollback.pointee = true
                    //如果发生异常，那么回传false
                    if let cb = callback
                    {
                        cb(false)
                    }
                }
            }
        }
    }
    
    ///在事务中执行多条query语句
    ///参数：sqls：要执行的sql语句数组；callback：回调，返回查询是否成功和结果的数组
    ///完整的sql语句在传入时就拼接好
    ///一般不要这么用，最好还是单独执行一条语句，除非确实需要同时查询多个结果
    func transactionQuery(sqls: Array<String>, callback: ((_ ret: Bool, _ results: Array<FMResultSet>) -> Void))
    {
        if let queue = self.dbQueue
        {
            queue.inTransaction { db, rollback in
                do {
                    var retArray: Array<FMResultSet> = []
                    for sql in sqls
                    {
                        let ret = try db.executeQuery(sql, values: nil)
                        retArray.append(ret)
                    }
                    //全部查询完后，执行回调
                    callback(true, retArray)
                } catch {
                    FSLog("db query error: " + error.localizedDescription)
                    rollback.pointee = true
                    //如果发生异常，那么回传false
                    callback(false, [])
                }
            }
        }
    }
    /**************************************** 通用基础方法 Section End **************************************/
    
    /**************************************** 查询和更新方法 Section Begin ***************************************/
    //查询数据库版本号
    func queryDbVersion()
    {
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /**************************************** 查询和更新方法 Section End ***************************************/
    
}
