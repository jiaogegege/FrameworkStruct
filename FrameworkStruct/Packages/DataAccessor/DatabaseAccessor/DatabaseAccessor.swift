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
 */

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

import UIKit

/**
 数据库存取器代理协议，主要通知外部程序存取器的一些状态变化
 */
protocol DatabaseAccessorDelegate {
    ///数据库状态变化
    func databaseAccessorStatusChanged(status: DatabaseAccessor.WorkState)
    
}

class DatabaseAccessor: OriginAccessor
{
    //MARK: 属性
    //单例
    static let shared = DatabaseAccessor()
    
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
        
        /*********** 开始创建数据库 *************/
        stMgr.setStatus(WorkState.creating, forKey: DBAStatusKey.workState)
        
        //数据库文件路径
        let dbPath = SandBoxAccessor.shared.getDatabasePath()
        FSLog(dbPath)
        
        //判断数据库文件是否存在
        let isDbExist = SandBoxAccessor.shared.isExist(path: dbPath)
        
        //创建数据库操作队列对象，如果返回nil，说明创建不成功，一般都会成功
        self.dbQueue = FMDatabaseQueue(path: dbPath)
        self.db = self.dbQueue?.value(forKey: "_db") as? FMDatabase
        
        /************* 如果数据库打开不成功，那么打印错误信息 **************/
        guard self.dbQueue != nil else {
            //创建失败
            stMgr.setStatus(WorkState.failure, forKey: DBAStatusKey.workState)
            FSLog("create db failure")
            return
        }
        
        //初始化锁
        lock = NSRecursiveLock()
        
        /************** 如果数据库打开成功，那么继续接下来的操作 **************/
        
        //如果不存在数据库文件，那么说明数据库还没创建过或者被删除了，那么创建数据库表
        if !isDbExist
        {
            self.createDbTable()
        }
        
        /************** 数据库创建并打开成功 ******************/
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
                if g_isValidString(sql)   //如果是有效字符串，那么执行sql语句
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
        let infoDict = ["type": "database: sqlite3", "tables": self.queryAllTableName().joined(separator: ", ")]
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
    
    //MARK: 增删改查适配方法
    ///执行更新方法
    ///参数：
    ///inQueue：是否在多线程环境下执行，不可在回调中嵌套执行sql语句；
    ///sqls：要执行的sql语句，如果只有一条，也打包成数组传过来；
    ///callback：回调方法，返回执行结果
    func performUpdate(inQueue: Bool, sqls: [String], callback: @escaping ((_ ret: Bool) -> Void))
    {
        if inQueue  //在队列中执行
        {
            if sqls.count == 1  //只有1条sql语句
            {
                self.updateInQueue(sql: sqls.first!) { (ret) in
                    callback(ret)
                }
            }
            else    //事务执行
            {
                self.transactionUpdateInQueue(sqls: sqls) { (ret) in
                    callback(ret)
                }
            }
        }
        else    //在单线程中执行
        {
            if sqls.count == 1  //只有一条sql语句
            {
                let ret = self.update(sql: sqls.first!)
                callback(ret)
            }
            else    //事务执行
            {
                let ret = self.transactionUpdate(sqls: sqls)
                callback(ret)
            }
        }
    }
    
    ///执行更新方法
    ///参数：
    ///inQueue：是否在多线程环境下执行，不可在回调中嵌套执行sql语句；
    ///sqls：要执行的sql语句，如果只有一条，也打包成数组传过来；
    ///callback：回调方法，返回执行结果
    func performQuery(inQueue: Bool, sqls: [String], callback: @escaping ((_ ret: Bool, _ results: Array<FMResultSet>) -> Void))
    {
        if inQueue  //在队列中执行
        {
            if sqls.count == 1  //只有1条sql语句
            {
                self.queryInQueue(sql: sqls.first!) { (ret, result) in
                    callback(ret, result != nil ? [result!] : [])
                }
            }
            else    //事务执行
            {
                self.transactionQueryInQueue(sqls: sqls) { (ret, results) in
                    callback(ret, results)
                }
            }
        }
        else    //在单线程中执行
        {
            if sqls.count == 1  //只有一条sql语句
            {
                let ret = self.query(sql: sqls.first!)
                callback(ret.0, ret.1 != nil ? [ret.1!] : [])
            }
            else    //事务执行
            {
                let ret = self.transactionQuery(sqls: sqls)
                callback(ret.0, ret.1)
            }
        }
    }
    
    ///执行一条Update的sql语句
    func update(sql: String) -> Bool
    {
        guard currentState != .failure else {
            FSLog("db is failure")
            return false
        }
        
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
            FSLog("update failed: db is closed")
        }
        return ret
    }
    
    ///执行一条query的sql语句
    func query(sql: String) -> (Bool, FMResultSet?)
    {
        guard currentState != .failure else {
            FSLog("db is failure")
            return (false, nil)
        }
        
        var ret: Bool = true
        var result: FMResultSet? = nil
        if dbQueue != nil, db != nil
        {
            lock?.lock()
            do {
                result = try db?.executeQuery(sql, values: nil)
            } catch {
                FSLog("db query error: " + error.localizedDescription)
                //发生错误则设置为false
                ret = false
            }
            lock?.unlock()
        }
        else
        {
            FSLog("query failed: db is closed")
        }
        return (ret, result)
    }
    
    ///在事务中执行多条sql语句
    ///参数：sqls：要执行多sql语句数组
    ///返回值：是否执行成功，如果不成功则会滚
    func transactionUpdate(sqls: Array<String>) -> Bool
    {
        guard currentState != .ready else {
            FSLog("db is failure")
            return false
        }
        
        var ret = true
        if dbQueue != nil, db != nil
        {
            lock?.lock()
            db?.beginTransaction()
            do {
                for sql in sqls
                {
                    try db?.executeUpdate(sql, values: nil)
                }
            } catch {
                FSLog("db update error: " + error.localizedDescription)
                //如果发生错误，设置为false
                ret = false
                db?.rollback()
            }
            db?.commit()
            lock?.unlock()
        }
        else
        {
            FSLog("transaction update failed: db is closed")
        }
        return ret
    }
    
    ///在事务中执行多条sql语句
    ///参数：sqls：要执行多sql语句数组
    ///返回值：查询结果数组，如果不成功则会滚
    func transactionQuery(sqls: Array<String>) -> (Bool, Array<FMResultSet>)
    {
        guard currentState != .ready else {
            FSLog("db is failure")
            return (false, [])
        }
        
        var ret: Bool = true
        var results: [FMResultSet] = []
        if dbQueue != nil, db != nil
        {
            lock?.lock()
            db?.beginTransaction()
            do {
                for sql in sqls
                {
                    let ret = try db?.executeQuery(sql, values: nil)
                    if let ret = ret
                    {
                        results.append(ret)
                    }
                }
            } catch {
                FSLog("db query error: " + error.localizedDescription)
                ret = false
                db?.rollback()
            }
            db?.commit()
            lock?.unlock()
        }
        else
        {
            FSLog("transaction query failed: db is closed")
        }
        return (ret, results)
    }
    
    ///在队列中执行一条Update的sql语句
    func updateInQueue(sql: String, callback: ((_ ret: Bool) -> Void)?)
    {
        guard currentState == .ready else {
            FSLog("db is not ready")
            if let cb = callback
            {
                cb(false)
            }
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
            FSLog("update in queue failed: db is closed")
            if let cb = callback
            {
                cb(false)
            }
        }
    }
    
    ///在队列中执行一条query的sql语句
    ///如果发生了错误，那么回传false和nil
    func queryInQueue(sql: String, callback: ((_ ret: Bool, _ result: FMResultSet?) -> Void))
    {
        guard currentState == .ready else {
            FSLog("db is not ready")
            callback(false, nil)
            return
        }
        
        if let queue = self.dbQueue
        {
            queue.inDatabase { db in
                do {
                    let ret = try db.executeQuery(sql, values: nil)
                    //查询完毕后回传结果
                    callback(true, ret)
                } catch {
                    FSLog("db query error: " + error.localizedDescription)
                    //如果发生异常，那么回传false
                    callback(false, nil)
                }
            }
        }
        else
        {
            FSLog("query in queue failed: db is closed")
            callback(false, nil)
        }
    }
    
    ///在事务中执行多条update语句
    ///参数：sqls：要执行的sql语句数组；callback：回调，返回执行是否成功,如果不成功则回滚
    ///完整的sql语句在传入时就拼接好
    func transactionUpdateInQueue(sqls: Array<String>, callback: ((_ ret: Bool) -> Void)?)
    {
        guard currentState == .ready else {
            FSLog("db is not ready")
            if let cb = callback
            {
                cb(false)
            }
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
            FSLog("transaction update in queue failed: db is closed")
            if let cb = callback
            {
                cb(false)
            }
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
            callback(false, [])
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
            FSLog("transaction query in queue failed: db is closed")
            callback(false, [])
        }
    }
    /**************************************** 通用基础方法 Section End **************************************/
    
    //MARK: 具体的数据增删改查方法
    /**************************************** 存取器内部查询更新方法 Section Begin ***************************************/
    //查询数据库中所有表名
    fileprivate func queryAllTableName() -> Array<String>
    {
        let sql = "SELECT name FROM sqlite_master WHERE type = 'table'"
        var tableArray = [String]()
        let ret = query(sql: sql)
        if ret.0 == true, let result = ret.1
        {
            while result.next()
            {
                if let tblName = result.string(forColumn: "name")
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
        FSLog("insert db version: \(version) \(update(sql: sql) ? "success" : "failure")")
    }
    
    //查询数据库版本号
    func queryDbVersion() -> String?
    {
        //构建sql语句
        let sql = String(format: "SELECT config_value FROM app_config WHERE config_key = '%@'", DatabaseKey.dbVersion.rawValue)
        let ret = query(sql: sql)
        if ret.0 == true, let result = ret.1
        {
            if result.next()
            {
                if let version = result.string(forColumn: "config_value")
                {
                    return version
                }
            }
        }
        return nil
    }
    
    //更新数据库版本号
    fileprivate func updateDbVersion(_ version: String)
    {
        //构建sql语句
        let sql = String(format: "UPDATE app_config SET config_value = '%@' WHERE config_key = '%@'", version, DatabaseKey.dbVersion.rawValue)
        FSLog("update db version: \(version) \(update(sql: sql) ? "success" : "failure")")
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
    /**************************************** 存取器内部查询更新方法 Section End ****************************************/
    
    /**************************************** 业务数据增删改查方法 Section Begin ****************************************/
    //MARK: 用户信息
    ///查询用户信息
    ///multithread:如果在多线程环境下执行，那么传true
    func queryAllUsersInfo(multithread: Bool = false, callback: @escaping ((Array<UserInfoModel>?) -> Void))
    {
        let sql = "SELECT * FROM app_user"
        
        performQuery(inQueue: multithread, sqls: [sql]) { (ret, results) in
            if ret, let result = results.first
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
            else
            {
                callback(nil)
            }
        }
    }
    
    ///更新一个用户信息
    ///参数：multithread：是否在多线程环境下执行；user：用户信息；callback：回调，更新是否成功
    func updateUserInfo(multithread: Bool = false , user: UserInfoModel, callback: ((Bool) -> Void)?)
    {
        let sql = String(format: "UPDATE app_user SET user_phone='%@', user_password='%@', update_date='%@' WHERE id='%@'", user.userPhone, user.userPassword, getCurrentTimeString(), user.id)
        
        performUpdate(inQueue: multithread, sqls: [sql]) { (ret) in
            if let callback = callback {
                callback(ret)
            }
        }
    }
    
    

    
    
    
    
    /**************************************** 业务数据增删改查方法 Section End ***************************************/
    
}
