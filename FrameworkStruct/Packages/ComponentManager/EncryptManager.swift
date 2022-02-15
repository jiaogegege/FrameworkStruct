//
//  EncryptManager.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/1/27.
//

/**
 * 加密管理器
 *
 * 功能详述：主要负责管理工程中的加密算法和实用加密方法
 *
 * 注意事项：
 *
 */
import UIKit
import CommonCrypto

class EncryptManager: OriginManager
{
    //MARK: 属性
    //单例
    static let shared = EncryptManager()
    
    
    //MARK: 方法
    //私有化初始化方法
    private override init()
    {
        super.init()
    }
    
    override func copy() -> Any
    {
        return self
    }
    
    override func mutableCopy() -> Any
    {
        return self
    }

}

//接口方法
extension EncryptManager: ExternalInterface
{
    ///生成一个32~36位随机字符串，用于生成各种随机id
    ///形如：F4709DFF-24CD-458F-AECB-C0082B87052A
    ///参数：lower：是否将字母转为小写格式；short：是否转为紧凑模式（去除字符串中间的`-`分隔符），使用紧凑模式将返回32位字符串，非紧凑模式返回36位
    func uuidString(lower: Bool = true, short: Bool = true) -> String
    {
        let uuid_ref: CFUUID = CFUUIDCreate(nil)
        let uuid_string_ref: CFString = CFUUIDCreateString(nil, uuid_ref)
        var uuid = uuid_string_ref as String
        if lower
        {
            uuid = uuid.lowercased()
        }
        if short
        {
            uuid = uuid.replacingOccurrences(of: "-", with: "")
        }
        return uuid
    }
    
    ///DES加密一个字符串
    func desString(originStr: String, desKey: String) -> String
    {
        return NSString.des(originStr, key: desKey)
    }
    
    
    
    
}
