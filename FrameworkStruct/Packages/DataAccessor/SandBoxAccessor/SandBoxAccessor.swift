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
    /**************************************** 文件和目录操作 Section Begin ****************************************/
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
                FSLog("create dir error: \(error.localizedDescription)")
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
            FSLog("delete path error: \(error.localizedDescription)")
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
    
    /**************************************** 文件和目录操作 Section End ****************************************/
    
    
    /**************************************** 文件夹路径访问 Section Begin ****************************************/
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
    
    ///获得Library路径
    func getLibraryDirectory() -> String
    {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let libPath = paths.last
        return libPath!
    }
    
    ///获取一个Library下的目录如果不存在则创建
    func getLibraryDirWith(pathComponent: String) -> String
    {
        let dirPath = (self.getLibraryDirectory() as NSString).appendingPathComponent(pathComponent)
        if !self.isExist(path: dirPath) //不存在则创建
        {
            let _ = self.createDir(path: dirPath)
        }
        return dirPath
    }
    
    ///获取cache路径
    func getCacheDirectory() -> String
    {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let cachePath = paths.last
        return cachePath!
    }
    
    ///获取一个cache下的目录如果不存在则创建
    func getCacheDirWith(pathComponent: String) -> String
    {
        let dirPath = (self.getCacheDirectory() as NSString).appendingPathComponent(pathComponent)
        if !self.isExist(path: dirPath) //不存在则创建
        {
            let _ = self.createDir(path: dirPath)
        }
        return dirPath
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
    
    ///获取一个bundle中指定文件名的文件路径
    ///fileName:文件名，建议带扩展名
    ///ext：扩展名，优先使用这个参数；如果为nil，那么尝试从fileName中获取；如果获取不到，那么为nil
    func getBundleFilePath(_ fileName: String, ext: String? = nil) -> String?
    {
        let fileComponent = fileName.components(separatedBy: ".")
        let name = fileComponent.first
        var extName: String? = nil
        if let ext = ext {  //优先从参数获取
            extName = ext
        }
        if extName == nil   //如果没有传入ext，那么尝试从fileName获取
        {
            extName = fileComponent.count >= 2 ? fileComponent.last : nil
        }
        let path = Bundle.main.path(forResource: name, ofType: extName)
        return path
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
        return self.getBundleFilePath(fileName, ext: FileTypeName.sql.rawValue)
    }
    
    ///获取临时下载文件保存目录
    ///放在Temp文件夹下
    func getTempDownloadDir() -> String
    {
        return self.getTempDirWith(pathComponent: sdDownloadTempDir)
    }
    
    ///获取沙盒音频文件目录
    func getSoundsDir() -> String
    {
        return self.getLibraryDirWith(pathComponent: sdSoundsDir)
    }

    /**************************************** 文件夹路径访问 Section End ****************************************/
    
    /**************************************** 具体读写文件方法 Section Begin ****************************************/
    ///保存图片到沙盒
    ///参数：compress：如果是jpg图片，可以设置压缩率(0-1)，数值越小，压缩率越高；filePath：要保存的沙盒文件路径
    ///- Returns: 返回是否保存成功
    func saveImage(image: UIImage, compress: CGFloat = 1, filePath: String) -> Bool
    {
        //尝试获取图片扩展名，没有则默认jpg
        var extName = (filePath as NSString).pathExtension
        var imageData: Data?
        if g_isValidString(extName) //获取到扩展名
        {
            if extName == FileTypeName.png.rawValue
            {
                imageData = image.pngData()
            }
            else
            {
                imageData = image.jpegData(compressionQuality: compress)
            }
        }
        else    //没有获取到扩展名，默认jpg
        {
            extName = FileTypeName.jpg.rawValue
            imageData = image.jpegData(compressionQuality: compress)
        }
        //将UIImage转为Data
        if let id = imageData
        {
            if (try? id.write(to: URL(fileURLWithPath: filePath), options: .atomic)) == nil
            {
                //如果写入时发生异常，返回false
                return false
            }
        }
        else    //如果未获取到图片Data
        {
            return false
        }
        return true
    }
    
    /**************************************** 具体读写文件方法 Section End ****************************************/
    
}
