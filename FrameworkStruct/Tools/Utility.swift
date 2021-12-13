//
//  CommonTools.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/11/5.
//

/**
 * 通用工具集
 */
import UIKit

class Utility: NSObject
{
    
    //跳转到app store评分
    static func gotoAppStoreComment()
    {
        let urlStr = "itms-apps://itunes.apple.com/app/id\(sAppId)?action=write-review"
        UIApplication.shared.open(URL.init(string: urlStr)!, options: [:], completionHandler: nil)
    }
    
    //获得沙盒文件夹路径
    static func getHomePath() -> String
    {
        let homePath = NSHomeDirectory()
        return homePath
    }
    
    //获得Documents文件夹路径
    static func getDocumentPath() -> String
    {
        // 检索指定路径
        // 第一个参数：指定的搜索路径
        // 第二个参数：检索的范围（沙盒内）
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let docPath = paths.first
        return docPath!
    }
    
    //获得Library路径
    static func getLibraryPath() -> String
    {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let libPath = paths.last
        return libPath!
    }
    
    //获取 Temp 的路径
    static func getTempPath() -> String
    {
        return NSTemporaryDirectory()
    }
    
    //返回一个拷贝的数据对象，如果是NSObject，那么返回copy对象，其他返回原始值（结构体、枚举等）
    static func getCopy(origin: Any?) -> Any
    {
        if let nsData = origin as? NSObject
        {
            return nsData.copy()
        }
        else if let array = origin as? Array<Any>
        {
            return array.copy()
        }
        else if let dic = origin as? Dictionary<AnyHashable, Any>
        {
            return dic.copy()
        }
        else
        {
            return origin as Any
        }
    }
    
    //获得一个对象的类名
    static func getObjClassName(obj: AnyObject) -> String
    {
        let typeName = type(of: obj).description()
        return typeName.components(separatedBy: ".").last!
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
