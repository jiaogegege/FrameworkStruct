//
//  UDAccessor.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2021/12/9.
//

import UIKit

class UDAccessor: OriginAccessor
{
    //单例
    static let shared = UDAccessor()
    
    //NSUserDefaults
    var ud = UserDefaults.standard
    
    //私有化初始化方法
    private override init()
    {
        
    }
    
    override func copy() -> Any
    {
        return self // UDAccessor.shared
    }
        
    override func mutableCopy() -> Any
    {
        return self // UDAccessor.shared
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
    }
    
    /**
     * 删除一个字段
     */
    func delete(key: String)
    {
        ud.removeObject(forKey: key)
    }
    
}
