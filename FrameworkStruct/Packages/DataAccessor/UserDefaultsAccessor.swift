//
//  UserDefaultsAccessor.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2021/12/9.
//

/**
 * UserDefaults存取器
 * 专门用于读写配置信息
 */
import UIKit

class UserDefaultsAccessor: OriginAccessor
{
    //单例
    static let shared = UserDefaultsAccessor()
    
    //NSUserDefaults
    var ud = UserDefaults.standard
    
    //私有化初始化方法
    private init()
    {
        super.init(monitor: AccessorMonitor.shared)
    }
    
    override func copy() -> Any
    {
        return self // UserDefaultsAccessor.shared
    }
        
    override func mutableCopy() -> Any
    {
        return self // UserDefaultsAccessor.shared
    }
    
    /**
     * 读取一个字段
     */
    func read(key: String) -> Any?
    {
        return ud.object(forKey: key)
    }
    
    /**
     * 读取字符串
     */
    func readString(key: String) -> String?
    {
        return ud.string(forKey: key)
    }
    
    /**
     * 读取整数
     */
    func readInt(key: String) -> Int
    {
        return ud.integer(forKey: key)
    }
    
    /**
     * 读取浮点数
     */
    func readDouble(key: String) -> Double
    {
        return ud.double(forKey: key)
    }
    
    /**
     * 读取布尔值
     */
    func readBool(key: String) -> Bool
    {
        return ud.bool(forKey: key)
    }
    
    /**
     * 写入一个字段
     */
    func write(key: String, value: Any)
    {
        ud.set(value, forKey: key)
        ud.synchronize()
    }
    
    /**
     * 删除一个字段
     */
    func delete(key: String)
    {
        ud.removeObject(forKey: key)
    }
    
    
    
    //返回数据源相关信息
    override func accessorDataSourceInfo() -> Dictionary<String, String> {
        let infoDict = ["type": "UserDefaults"]
        return infoDict
    }
}
