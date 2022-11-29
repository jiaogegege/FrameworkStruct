//
//  SandBoxAccessor.swift
//  FrameworkStruct
//
//  Created by jggg on 2021/12/26.
//

/**
 * 沙盒文件存取器
 * 存取`Bundle`和沙盒中的文件
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
    override func accessorInfo() -> Dictionary<String, String> {
        let infoDict = ["type": "sandbox"]
        return infoDict
    }
    
}


//接口方法
extension SandBoxAccessor: ExternalInterface
{
    //MARK: 文件和目录操作
    /**************************************** 文件和目录操作 Section Begin ****************************************/
    //创建一个目录
    func createDir(_ path: String) -> Bool
    {
        //先判断是否存在
        if isExist(path)
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
    func createFile(_ path: String) -> Bool
    {
        //先判断是否存在
        if isExist(path)
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
    func isExist(_ path: String) -> Bool
    {
        var ret = false
        ret = self.fileMgr.fileExists(atPath: path)
        return ret
    }
    
    //判断某个路径是否是目录
    func isDir(_ path: String) -> Bool
    {
        var ret = ObjCBool.init(false)
        self.fileMgr.fileExists(atPath: path, isDirectory: &ret)
        return ret.boolValue
    }
    
    //判断某个路径是否是文件
    func isFile(_ path: String) -> Bool
    {
        var ret = ObjCBool.init(false)
        self.fileMgr.fileExists(atPath: path, isDirectory: &ret)
        return !ret.boolValue   //结果取反，ret为true是目录
    }
    
    //判断是否本地沙盒或者文件App中的文件
    func isLocalFile(_ fileUrl: String) -> Bool
    {
        fileUrl.hasPrefix(sdFilePrefix)
    }
    
    ///获取一个目录中的所有文件，返回文件绝对路径数组
    ///参数：excludeDir：是否排除目录，默认不排除；excludeFile：是否排除文件，默认不排除；
    ///fileExts：搜索特定扩展名的文件，该参数和前面两个参数是互斥的；excludefileExts：是否排除特定扩展名的文件，该参数和`fileExts`配合使用
    func getPathList(in dir: String,
                     excludeDir: Bool = false,
                     excludeFile: Bool = false,
                     fileExts: [FileTypeName]? = nil,
                     excludefileExts: Bool = false, completion: @escaping (([String]) -> Void))
    {
        ThreadManager.shared.async { queue in
            var files = [String]()
            if let en = FileManager.default.enumerator(atPath: dir)
            {
                for path in en
                {
                    let absPath = (dir as NSString).appendingPathComponent((path as! String))
                    if let fileExts = fileExts
                    {
                        if excludefileExts  //排除特定扩展名
                        {
                            var shouldAdd = true
                            for ext in fileExts {
                                if (absPath as NSString).pathExtension == ext.rawValue
                                {
                                    shouldAdd = false
                                    break
                                }
                            }
                            if shouldAdd == true && self.isFile(absPath)
                            {
                                files.append(absPath)
                            }
                        }
                        else    //指定特定扩展名
                        {
                            for ext in fileExts {
                                if (absPath as NSString).pathExtension == ext.rawValue
                                {
                                    files.append(absPath)
                                    break
                                }
                            }
                        }
                    }
                    else
                    {
                        if excludeDir   //排除目录
                        {
                            if self.isFile(absPath)
                            {
                                files.append(absPath)
                            }
                        }
                        else if excludeFile //排除文件
                        {
                            if self.isDir(absPath)
                            {
                                files.append(absPath)
                            }
                        }
                        else
                        {
                            files.append(absPath)
                        }
                    }
                }
            }
            queue.async {
                completion(files)
            }
        }
    }
    
    ///获取文件属性
    func getFileAttrs(at path: String) -> SBFileAttributes?
    {
        do {
            let attrs = try fileMgr.attributesOfItem(atPath: path)
            return SBFileAttributes(fileAttrs: attrs)
        } catch {
            FSLog(error.localizedDescription)
            return nil
        }
    }
    
    /**************************************** 文件和目录操作 Section End ****************************************/
    
    //MARK: 文件夹路径访问
    /**************************************** 文件夹路径访问 Section Begin ****************************************/
    ///获得沙盒文件夹路径
    func getHomeDir() -> NSString
    {
        NSHomeDirectory() as NSString
    }
    
    ///获得Documents文件夹路径
    func getDocumentDir() -> NSString
    {
        // 检索指定路径
        // 第一个参数：指定的搜索路径
        // 第二个参数：检索的范围（沙盒内）
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let docPath = paths.first
        return docPath! as NSString
    }
    
    ///获取一个Documents下的目录如果不存在则创建
    func getDocumentDirWith(_ pathComponent: String) -> NSString
    {
        let dirPath = self.getDocumentDir().appendingPathComponent(pathComponent)
        if !self.isExist(dirPath) //不存在则创建
        {
            let _ = self.createDir(dirPath)
        }
        return dirPath as NSString
    }
    
    ///获得Library路径
    func getLibraryDir() -> NSString
    {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let libPath = paths.last
        return libPath! as NSString
    }
    
    ///获取一个Library下的目录如果不存在则创建
    func getLibraryDirWith(_ pathComponent: String) -> NSString
    {
        let dirPath = self.getLibraryDir().appendingPathComponent(pathComponent)
        if !self.isExist(dirPath) //不存在则创建
        {
            let _ = self.createDir(dirPath)
        }
        return dirPath as NSString
    }
    
    ///获取cache路径
    func getCacheDir() -> NSString
    {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let cachePath = paths.last
        return cachePath! as NSString
    }
    
    ///获取一个cache下的目录如果不存在则创建
    func getCacheDirWith(_ pathComponent: String) -> NSString
    {
        let dirPath = self.getCacheDir().appendingPathComponent(pathComponent)
        if !self.isExist(dirPath) //不存在则创建
        {
            let _ = self.createDir(dirPath)
        }
        return dirPath as NSString
    }
    
    ///获取 Temp 的路径
    func getTempDir() -> NSString
    {
        NSTemporaryDirectory() as NSString
    }
    
    ///获取一个Temp下的目录，不存在则创建
    func getTempDirWith(_ pathComponent: String) -> NSString
    {
        let dirPath = self.getTempDir().appendingPathComponent(pathComponent)
        if !self.isExist(dirPath) //不存在则创建
        {
            let _ = self.createDir(dirPath)
        }
        return dirPath as NSString
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
        let dbDirPath = self.getDocumentDirWith(sdDatabaseDir)      //由于Documents可共享到`文件`App，考虑将数据库放在Library中
        let dbPath = (dbDirPath as NSString).appendingPathComponent(sdDatabaseFile)
        return dbPath
    }
    
    ///获取数据库表结构sql文件路径，参数包含扩展名，如果不包含扩展名，默认用`sql`
    ///文件名中不要包含`.`，因为用来区分扩展名
    func getSQLFilePath(_ fileName: String) -> String?
    {
        getBundleFilePath(fileName, ext: FileTypeName.sql.rawValue)
    }
    
    ///获取临时下载文件保存目录
    ///放在Temp文件夹下
    func getTempDownloadDir() -> NSString
    {
        getTempDirWith(sdDownloadTempDir)
    }
    
    ///获取沙盒音频文件目录
    func getSoundsDir() -> NSString
    {
        getDocumentDirWith(sdSoundsDir)
    }

    /**************************************** 文件夹路径访问 Section End ****************************************/
    
    //MARK: 具体读写文件方法
    /**************************************** 具体读写文件方法 Section Begin ****************************************/
    
    ///保存图片到沙盒
    ///参数：compress：如果是jpg图片，可以设置压缩率(0-1)，数值越小，压缩率越高；filePath：要保存的沙盒文件路径
    ///- Returns: 返回是否保存成功
    func saveImage(_ image: UIImage, compress: CGFloat = 1, filePath: String) -> Bool
    {
        //尝试获取图片扩展名，没有则默认jpg
        var extName = (filePath as NSString).pathExtension
        var imageData: Data?
        if g_validString(extName) //获取到扩展名
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
