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
    
    //返回数据源相关信息
    override func accessorDataSourceInfo() -> Dictionary<String, String> {
        let infoDict = ["type": "sandbox"]
        return infoDict
    }
    
}
