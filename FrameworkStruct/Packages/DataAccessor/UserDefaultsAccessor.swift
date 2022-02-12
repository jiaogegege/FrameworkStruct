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
    private override init()
    {
        super.init()
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
    func read(key: UDAKeyType) -> Any?
    {
        return ud.object(forKey: key.rawValue)
    }
    
    /**
     * 读取字符串
     */
    func readString(key: UDAKeyType) -> String?
    {
        return ud.string(forKey: key.rawValue)
    }
    
    /**
     * 读取整数
     */
    func readInt(key: UDAKeyType) -> Int
    {
        return ud.integer(forKey: key.rawValue)
    }
    
    /**
     * 读取浮点数
     */
    func readDouble(key: UDAKeyType) -> Double
    {
        return ud.double(forKey: key.rawValue)
    }
    
    /**
     * 读取布尔值
     */
    func readBool(key: UDAKeyType) -> Bool
    {
        return ud.bool(forKey: key.rawValue)
    }
    
    /**
     * 写入一个字段
     */
    func write(key: UDAKeyType, value: Any)
    {
        ud.set(value, forKey: key.rawValue)
        ud.synchronize()
    }
    
    /**
     * 删除一个字段
     */
    func delete(key: UDAKeyType)
    {
        ud.removeObject(forKey: key.rawValue)
    }
    
    
    
    //返回数据源相关信息
    override func accessorDataSourceInfo() -> Dictionary<String, String> {
        let infoDict = ["type": "UserDefaults"]
        return infoDict
    }
}


//内部类型
extension UserDefaultsAccessor: InternalType
{
    ///保存的数据的key列表
    enum UDAKeyType: String
    {
        case deviceId   //设备唯一id，随机生成
        case currentTheme   //当前主题key
    }
}
