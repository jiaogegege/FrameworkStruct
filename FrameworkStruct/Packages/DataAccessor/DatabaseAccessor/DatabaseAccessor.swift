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

/**
 数据库存取器代理协议，主要通知外部程序存取器的一些状态变化
 */
protocol DatabaseAccessorDelegate {
    ///当前正在升级数据库
    
    ///数据库升级完毕
    
}

class DatabaseAccessor: OriginAccessor
{
    //MARK: 属性
    //单例
    static let shared = DatabaseAccessor()
    
    //状态管理器
    var stMgr: StatusManager = StatusManager(capacity: 10)
    
    //加密管理器
    var encryptMgr: EncryptManager = EncryptManager.shared

    //数据库操作队列对象
    fileprivate var dbQueue: FMDatabaseQueue?
    //数据库对象，从`dbQueue`中获取
    fileprivate weak var db: FMDatabase?
    //锁
    fileprivate var lock: NSRecursiveLock?
    
    
    //MARK: 方法
    //私有化初始化方法
    private override init()
    {
        super.init()
        
        //开始创建
        stMgr.setStatus(WorkState.creating, forKey: DBAStatusKey.workState)
        
        //数据库文件路径
        let dbPath = SandBoxAccessor.shared.getDatabasePath()
        FSLog(dbPath)
        
        //判断数据库文件是否存在
        let isDbExist = SandBoxAccessor.shared.isExist(path: dbPath)
        
        //创建数据库操作队列对象，如果返回nil，说明创建不成功，一般都会成功
        self.dbQueue = FMDatabaseQueue(path: dbPath)
        self.db = self.dbQueue?.value(forKey: "_db") as? FMDatabase
        
        //如果打开不成功，那么打印错误信息
        guard self.dbQueue != nil else {
            //创建失败
            stMgr.setStatus(WorkState.failure, forKey: DBAStatusKey.workState)
            FSLog("create db failure")
            return
        }
        
        //初始化锁
        lock = NSRecursiveLock()
        
        /****** 如果打开成功，那么继续接下来的操作 ******/
        
        //如果不存在数据库文件，那么说明数据库还没创建过，那么创建数据库表
        if !isDbExist
        {
            self.createDbTable()
        }
        
        //创建成功
        stMgr.setStatus(WorkState.created, forKey: DBAStatusKey.workState)
        
        //查询数据库版本号，判断是否要更新数据库
        self.checkAndUpdateDbVersion()
        
        //如果操作完毕后，状态是`updated`，那么将状态设置为ready
        if self.currentState != .failure
        {
            stMgr.setStatus(WorkState.ready, forKey: DBAStatusKey.workState)
        }
        
//        FSLog("DatabaseAccessor: finish initialize")
        /****************************数据库初始化完成**************************/
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
        if let path = SandBoxAccessor.shared.getSQLFilePath(fileName: sdDatabaseOriginSQLFile)
        {
            //获取sql文件并执行sql语句
            self.executeSqlStatementFromFile(filePath: path)
            //创建成功后写入数据库版本号
            self.insertOrUpdateDbVersion(db_OriginVersion)
        }
        else
        {
            FSLog("get db table struct sql file error")
        }
    }
    
    //规格化，处理sql字符串，替换换行
    fileprivate func normalizeSqlString(originStr: String) -> String
    {
        var str = originStr.replacingOccurrences(of: "\r\n", with: "\n")
        str = str.replacingOccurrences(of: "\\n", with: "\n")
        str = str.replacingOccurrences(of: "\n", with: "\n")
        str = str.replacingOccurrences(of: "\r", with: "")
        return str
    }
    
    //执行一个sql文件中的sql语句，主要用来修改数据库结构和内容，并非查询
    fileprivate func executeSqlStatementFromFile(filePath: String)
    {
        //获取文件内容
        do {
            var sqlContent = try NSString(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue) as String
            sqlContent = self.normalizeSqlString(originStr: sqlContent)
            //分割sql语句
            let sqlArr = sqlContent.components(separatedBy: ";")
            //执行sql语句
            for str in sqlArr
            {
                let sql = str.trim()
                if isValidString(sql)   //如果是有效字符串，那么执行sql语句
                {
                    if !self.update(sql: sql)
                    {
                        FSLog("execute sql error: " + sql)
                    }
                }
            }
        }
        catch {
            FSLog(error.localizedDescription)
        }
    }
    
    //查询数据库版本号，并判断是否要更新版本
    fileprivate func checkAndUpdateDbVersion()
    {
        //开始升级
        stMgr.setStatus(WorkState.updating, forKey: DBAStatusKey.workState)
        
        for ver in db_updateVersionList
        {
            if self.needUpdate(ver)
            {
                //获取对应版本号的sql文件
                if let path = SandBoxAccessor.shared.getSQLFilePath(fileName: ver)
                {
                    //执行sql语句
                    self.executeSqlStatementFromFile(filePath: path)
                    //创建成功后写入数据库版本号
                    self.updateDbVersion(ver)
                }
                else
                {
                    //升级失败
                    stMgr.setStatus(WorkState.failure, forKey: DBAStatusKey.workState)
                    FSLog("get sql file error")
                    
                    //如果某个版本升级失败则退出
                    return
                }
            }
        }
        
        //升级完毕
        stMgr.setStatus(WorkState.updated, forKey: DBAStatusKey.workState)
    }
    
    //判断是否需要更新该版本，版本号形如：1_0_1
    fileprivate func needUpdate(_ newVersion: String) -> Bool
    {
        //获取当前数据库版本号
        let oldVersion = self.queryDbVersion()
        //如果传入的版本号比当前版本号大，那么要更新
        if let old = oldVersion
        {
            if old < newVersion
            {
                return true
            }
        }
        
        return false
    }
    
    
    //返回数据源相关信息：type/tables(所有数据库表名)
    override func accessorDataSourceInfo() -> Dictionary<String, String> {
        let infoDict = ["type": "database", "tables": self.queryAllTableName().joined(separator: ", ")]
        return infoDict
    }
    
}


//内部类型
extension DatabaseAccessor: InternalType
{
    //数据库存取器状态key
    enum DBAStatusKey: SMKeyType {
        case workState  //工作状态
    }
    
    //工作状态枚举
    enum WorkState: Int {
        case creating = 0   //正在创建数据库
        case created    //创建数据库成功
        case updating   //正在升级数据库
        case updated    //升级数据库完毕
        case ready      //就绪状态，此时可以读写数据
        case failure    //数据库创建和升级失败，建议重启app或者删除重新安装
    }
    
}


//接口方法
extension DatabaseAccessor: ExternalInterface
{
    /**
     sqlite_master  结构如下

    SQLite Master Table Schema

    -----------------------------------------------------------------

    Name                       Description

    -----------------------------------------------------------------

    type          The object’s type (table, index, view, trigger)

    name          The object’s name

    tbl_name      The table the object is associated with

    rootpage      The object’s root page index in the database (where it begins)

    sql           The object’s SQL definition (DDL)
     */
    
    /**************************************** 通用基础方法 Section Begin **************************************/
    ///获取存取器当前状态
    var currentState: WorkState {
        return stMgr.status(forKey: DBAStatusKey.workState) as! DatabaseAccessor.WorkState
    }
    
    ///打开数据库，在程序生命周期内手动打开数据库，不会对数据库进行完整性校验和版本升级
    func open()
    {
        if self.dbQueue == nil  //没有的时候才创建
        {
            //数据库文件路径
            let dbPath = SandBoxAccessor.shared.getDatabasePath()
            FSLog(dbPath)
            
            //创建数据库操作队列对象，如果返回nil，说明创建不成功，一般都会成功
            self.dbQueue = FMDatabaseQueue(path: dbPath)
            self.db = self.dbQueue?.value(forKey: "_db") as? FMDatabase
            
            //初始化锁
            lock = NSRecursiveLock()
        }
    }
    
    ///关闭数据库，在程序生命周期内手动关闭数据库
    func close()
    {
        self.dbQueue?.close()
        self.dbQueue = nil
        self.db = nil
        self.lock = nil
    }
    
    ///执行一条Update的sql语句
    func update(sql: String) -> Bool
    {
        var ret = false
        if dbQueue != nil, db != nil
        {
            lock?.lock()
            do {
                try db?.executeUpdate(sql, values: nil)
                ret = true
            } catch {
                FSLog("db update error: " + error.localizedDescription)
            }
            lock?.unlock()
        }
        else
        {
            FSLog("db is closed")
        }
        return ret
    }
    
    ///执行一条query的sql语句
    func query(sql: String) -> FMResultSet?
    {
        var ret: FMResultSet? = nil
        if dbQueue != nil, db != nil
        {
            lock?.lock()
            do {
                ret = try db?.executeQuery(sql, values: nil)
            } catch {
                FSLog("db query error: " + error.localizedDescription)
            }
            lock?.unlock()
        }
        else
        {
            FSLog("db is closed")
        }
        return ret
    }
    
    ///执行一条Update的sql语句
    func updateInQueue(sql: String, callback: ((_ ret: Bool) -> Void)?)
    {
        guard currentState == .ready else {
            FSLog("db is not ready")
            return
        }
        
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
        else
        {
            FSLog("db is closed")
        }
    }
    
    ///执行一条query的sql语句
    ///如果发生了错误，那么回传false和nil
    func queryInQueue(sql: String, callback: ((_ ret: Bool, _ result: FMResultSet) -> Void))
    {
        guard currentState == .ready else {
            FSLog("db is not ready")
            return
        }
        
        if let queue = self.dbQueue
        {
            queue.inDatabase { db in
                do {
                    let ret = try db.executeQuery(sql, values: nil)
                    callback(true, ret)
                } catch {
                    FSLog("db query error: " + error.localizedDescription)
                    //如果发生异常，那么回传false
                    callback(false, FMResultSet())
                }
            }
        }
        else
        {
            FSLog("db is closed")
        }
    }
    
    ///在事务中执行多条update语句
    ///参数：sqls：要执行的sql语句数组；callback：回调，返回执行是否成功,如果不成功则回滚
    ///完整的sql语句在传入时就拼接好
    func transactionUpdateInQueue(sqls: Array<String>, callback: ((_ ret: Bool) -> Void)?)
    {
        guard currentState == .ready else {
            FSLog("db is not ready")
            return
        }
        
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
        else
        {
            FSLog("db is closed")
        }
    }
    
    ///在事务中执行多条query语句
    ///参数：sqls：要执行的sql语句数组；callback：回调，返回查询是否成功和结果的数组
    ///完整的sql语句在传入时就拼接好
    ///一般不要这么用，最好还是单独执行一条语句，除非确实需要同时查询多个结果
    func transactionQueryInQueue(sqls: Array<String>, callback: ((_ ret: Bool, _ results: Array<FMResultSet>) -> Void))
    {
        guard currentState == .ready else {
            FSLog("db is not ready")
            return
        }
        
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
        else
        {
            FSLog("db is closed")
        }
    }
    /**************************************** 通用基础方法 Section End **************************************/
    
    /**************************************** 查询和更新方法 Section Begin ***************************************/
    //查询数据库中所有表名
    fileprivate func queryAllTableName() -> Array<String>
    {
        let sql = "SELECT name FROM sqlite_master WHERE type = 'table'"
        var tableArray = [String]()
        if let ret = query(sql: sql)
        {
            while ret.next()
            {
                if let tblName = ret.string(forColumn: "name")
                {
                    tableArray.append(tblName)
                }
            }
        }
        return tableArray
    }
    
    //插入数据库版本号
    fileprivate func insertDbVersion(_ version: String)
    {
        //构建sql语句
        let sql = String(format: "INSERT INTO app_config (id, config_key, config_value, update_date, create_date) VALUES ('%@', '%@', '%@', '%@', '%@')", encryptMgr.uuidString(), DatabaseKey.dbVersion.rawValue, version, getCurrentTimeString(), getCurrentTimeString())
        FSLog("insert db version \(update(sql: sql) ? "success" : "failure")")
    }
    
    //查询数据库版本号
    func queryDbVersion() -> String?
    {
        //构建sql语句
        let sql = String(format: "SELECT config_value FROM app_config WHERE config_key = '%@'", DatabaseKey.dbVersion.rawValue)
        if let ret = query(sql: sql), ret.next()
        {
            if let version = ret.string(forColumn: "config_value")
            {
                return version
            }
        }
        return nil
    }
    
    //更新数据库版本号
    fileprivate func updateDbVersion(_ version: String)
    {
        //构建sql语句
        let sql = String(format: "UPDATE app_config SET config_value = '%@' WHERE config_key = '%@'", version, DatabaseKey.dbVersion.rawValue)
        FSLog("update db version \(update(sql: sql) ? "success" : "failure")")
    }
    
    //插入或更新数据库版本号
    //因为数据库版本号只应该有一条记录，如果已经有了，那么更新
    fileprivate func insertOrUpdateDbVersion(_ newVersion: String)
    {
        if self.queryDbVersion() != nil
        {
            self.updateDbVersion(newVersion)
        }
        else
        {
            self.insertDbVersion(newVersion)
        }
    }
    
    //MARK: 用户信息
    //查询用户信息
    func queryAllUserInfo(callback: ((Array<UserInfoModel>) -> Void))
    {
        let sql = "SELECT * FROM app_user"
        queryInQueue(sql: sql) { ret, result in
            if ret
            {
                var array: Array<UserInfoModel> = []
                while result.next()
                {
                    let user = UserInfoModel()
                    user.id = result.string(forColumn: "id")!
                    user.userPhone = result.string(forColumn: "user_phone")!
                    user.userPassword = result.string(forColumn: "user_password")!
                    user.updateDate = result.string(forColumn: "update_date")!
                    user.createDate = result.string(forColumn: "create_date")!
                    array.append(user)
                }
                //执行回调
                callback(array)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /**************************************** 查询和更新方法 Section End ***************************************/
    
}
