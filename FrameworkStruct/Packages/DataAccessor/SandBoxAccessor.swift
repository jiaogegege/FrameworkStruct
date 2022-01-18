//
//  SandBoxAccessor.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2021/12/26.
//

/**
 * 沙盒文件存取器
 */
import UIKit

class SandBoxAccessor: OriginAccessor
{
    //单例
    static let shared = SandBoxAccessor()
    
    //文件管理器
    lazy var fileMgr: FileManager = FileManager.default
    
    //私有化初始化方法
    private override init()
    {
        super.init()
    }
    
    override func copy() -> Any
    {
        return self // SandBoxAccessor.shared
    }
        
    override func mutableCopy() -> Any
    {
        return self // SandBoxAccessor.shared
    }
    
    
    //返回数据源相关信息
    override func accessorDataSourceInfo() -> Dictionary<String, String> {
        let infoDict = ["type": "sandbox"]
        return infoDict
    }
    
}


//接口方法
extension SandBoxAccessor: ExternalInterface
{
    //创建一个目录
    func createDir(path: String) -> Bool
    {
        //先判断是否存在
        if isExist(path: path)
        {
            return true //存在直接返回true
        }
        else
        {
            do {
                try fileMgr.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                return true
            } catch {
                print("create dir error: \(error.localizedDescription)")
                return false
            }
        }
    }
    
    //创建一个文件
    func createFile(path: String) -> Bool
    {
        //先判断是否存在
        if isExist(path: path)
        {
            return true //存在直接返回true
        }
        else
        {
            return fileMgr.createFile(atPath: path, contents: nil, attributes: nil)
        }
    }
    
    //删除某个目录或文件
    func deletePath(_ path: String)
    {
        do {
            try self.fileMgr.removeItem(atPath: path)
        } catch {
            print("delete path error: \(error.localizedDescription)")
        }
    }
    
    //判断某个文件或目录是否存在
    func isExist(path: String) -> Bool
    {
        var ret = false
        ret = self.fileMgr.fileExists(atPath: path)
        return ret
    }
    
    //判断某个路径是否是目录
    func isDir(path: String) -> Bool
    {
        var ret = ObjCBool.init(false)
        self.fileMgr.fileExists(atPath: path, isDirectory: &ret)
        return ret.boolValue
    }
    
    //判断某个路径是否是文件
    func isFile(path: String) -> Bool
    {
        var ret = ObjCBool.init(false)
        self.fileMgr.fileExists(atPath: path, isDirectory: &ret)
        return !ret.boolValue   //结果取反，ret为true是目录
    }
    
    //获得沙盒文件夹路径
    static func getHomeDirectory() -> String
    {
        let homePath = NSHomeDirectory()
        return homePath
    }
    
    //获得Documents文件夹路径
    static func getDocumentDirectory() -> String
    {
        // 检索指定路径
        // 第一个参数：指定的搜索路径
        // 第二个参数：检索的范围（沙盒内）
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let docPath = paths.first
        return docPath!
    }
    
    //获得Library路径
    static func getLibraryDirectory() -> String
    {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let libPath = paths.last
        return libPath!
    }
    
    //获取 Temp 的路径
    static func getTempDirectory() -> String
    {
        return NSTemporaryDirectory()
    }
    
    //获取数据库文件路径
    static func getDatabasePath() -> String
    {
        let dbPath = ((SandBoxAccessor.getDocumentDirectory() as NSString).appendingPathComponent(gDatabaseDir) as NSString).appendingPathComponent(gDatabaseFile)
        return dbPath
    }
    
}
