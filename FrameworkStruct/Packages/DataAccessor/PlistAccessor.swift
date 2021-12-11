//
//  PlistAccessor.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/12/9.
//

/**
 * plist文件存取器
 * 专门用于读写plist文件
 */
import UIKit

class PlistAccessor: OriginAccessor
{
    //单例
    static let shared = PlistAccessor()
    
    //私有化初始化方法
    private override init()
    {
        
    }
    
    override func copy() -> Any
    {
        return self // PlistAccessor.shared
    }
        
    override func mutableCopy() -> Any
    {
        return self // PlistAccessor.shared
    }
    
    /**
     * 读取一个本地资源包的plist文件
     * - parameters:
     * - fileName:文件名，包括后缀，也可以没有后缀
     */
    func read(fileName: String) -> Dictionary<String, AnyHashable>
    {
        let fileNameArr = fileName.components(separatedBy: ".")
        let bundle = Bundle.main
        let filePath = bundle.path(forResource: fileNameArr.first, ofType: "plist") ?? ""
        let fileDict = NSDictionary(contentsOfFile: filePath)
        return fileDict as! Dictionary<String, String>
    }
    
    /**
     * 读取一个plist文件
     * - parameters:
     *  - fileName:文件名，包括后缀，也可以没有后缀
     *  - identifier:资源包id，如果是cocospods中的资源包，需要传入名字，比如："org.cocoapods.AFNetworking"
     */
    func read(fileName: String, identifier: String) -> Dictionary<String, AnyHashable>
    {
        let fileNameArr = fileName.components(separatedBy: ".")
        let bundle = Bundle.init(identifier: identifier)
        let filePath = bundle?.path(forResource: fileNameArr.first, ofType: "plist") ?? ""
        let fileDict = NSDictionary(contentsOfFile: filePath)
        return fileDict as! Dictionary<String, String>
    }
    
    /**
     * 从URL读取一个plist文件
     * - parameters:
     *  - fileName:文件名，包括后缀，也可以没有后缀
     *  - urlStr:资源包id，如果是cocospods中的资源包，需要传入名字，比如："org.cocoapods.AFNetworking"
     */
    func read(fileName: String, urlStr: String) -> Dictionary<String, AnyHashable>
    {
        let fileNameArr = fileName.components(separatedBy: ".")
        if let url = URL(string: urlStr)
        {
            let bundle = Bundle.init(url: url)
            if let fileUrl = bundle?.url(forResource: fileNameArr.first, withExtension: "plist")
            {
                let fileDict = NSDictionary(contentsOf: fileUrl)
                return fileDict as! Dictionary<String, String>
            }
        }
        return Dictionary()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //返回数据源相关信息
    override func accessorDataSourceInfo() -> Dictionary<String, String> {
        let infoDict = ["type": "plist"]
        return infoDict
    }
    
}

