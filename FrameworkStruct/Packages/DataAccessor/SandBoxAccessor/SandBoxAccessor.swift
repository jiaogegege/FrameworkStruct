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
    /******************** 文件和目录操作 Section Begin *******************/
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
    
    /******************** 文件和目录操作 Section End *******************/
    
    
    /******************** 文件夹路径访问 Section Begin *******************/
    ///获得沙盒文件夹路径
    func getHomeDirectory() -> String
    {
        let homePath = NSHomeDirectory()
        return homePath
    }
    
    ///获得Documents文件夹路径
    func getDocumentDirectory() -> String
    {
        // 检索指定路径
        // 第一个参数：指定的搜索路径
        // 第二个参数：检索的范围（沙盒内）
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let docPath = paths.first
        return docPath!
    }
    
    ///获得Library路径
    func getLibraryDirectory() -> String
    {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let libPath = paths.last
        return libPath!
    }
    
    ///获取cache路径
    func getCacheDirectory() -> String
    {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let cachePath = paths.last
        return cachePath!
    }
    
    ///获取 Temp 的路径
    func getTempDirectory() -> String
    {
        return NSTemporaryDirectory()
    }
    
    ///获取一个Temp下的目录，不存在则创建
    func getTempDirWith(pathComponent: String) -> String
    {
        let dirPath = (self.getTempDirectory() as NSString).appendingPathComponent(pathComponent)
        if !self.isExist(path: dirPath) //不存在则创建
        {
            let _ = self.createDir(path: dirPath)
        }
        return dirPath
    }
    
    ///获取一个Documents下的目录如果不存在则创建
    func getDocumentDirWith(pathComponent: String) -> String
    {
        let dirPath = (self.getDocumentDirectory() as NSString).appendingPathComponent(pathComponent)
        if !self.isExist(path: dirPath) //不存在则创建
        {
            let _ = self.createDir(path: dirPath)
        }
        return dirPath
    }
    
    ///获取数据库文件路径
    func getDatabasePath() -> String
    {
        let dbDirPath = self.getDocumentDirWith(pathComponent: sdDatabaseDir)
        let dbPath = (dbDirPath as NSString).appendingPathComponent(sdDatabaseFile)
        return dbPath
    }
    
    ///获取数据库表结构sql文件路径，参数包含扩展名，如果不包含扩展名，默认用`sql`
    ///文件名中不要包含`.`，因为用来区分扩展名
    func getSQLFilePath(fileName: String) -> String?
    {
        let fileComponent = fileName.components(separatedBy: ".")
        let sqlPath = Bundle.main.path(forResource: fileComponent.first, ofType: (fileComponent.count >= 2 ? fileComponent.last : "sql"))
        return sqlPath
    }
    
    ///获取临时下载文件保存目录
    ///放在Temp文件夹下
    func getTempDownloadDir() -> String
    {
        return self.getTempDirWith(pathComponent: sdDownloadTempDir)
    }
    
    /******************** 文件夹路径访问 Section End *******************/
    
}
