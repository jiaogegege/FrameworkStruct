//
//  KeychainAccessor.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/4/8.
//

/**
 * 钥匙串存取器，对接系统钥匙串功能
 * 一般用于短小的私密数据存储，即使app卸载，重新安装后也可以获取之前保存的数据
 */
import UIKit

class KeychainAccessor: OriginAccessor
{
    //MARK: 属性
    //单例
    static let shared = KeychainAccessor()
    
    
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

    
    override func accessorDataSourceInfo() -> Dictionary<String, String> {
        let infoDict = ["type": "keychain"]
        return infoDict
    }
    
}


//内部类型
extension KeychainAccessor: InternalType
{
    //保存的私密数据的类型，根据实际需求添加类型
    enum KADataType: String
    {
        case password = "FS_KA_password"           //密码
        case idCard = "FS_KA_idCard"               //身份证号
    }
    
}


//接口方法
extension KeychainAccessor: ExternalInterface
{
    ///保存某个用户名的密码，如果存在则更新；用户名一般是手机号或用户设置或后台系统分配
    func savePsd(username: String, psd: String, completion: ((Error?) -> Void))
    {
        do {
            try BCCKeychain.storeUsername(username.trim(), andPasswordString: psd.trim(), forServiceName: KADataType.password.rawValue, updateExisting: true)
            //保存成功后执行回调
            completion(nil)
        } catch {
            //捕获错误后将错误传出去
            completion(error)
        }
    }
    
    ///读取某个用户名的密码，如果出错返回nil，获取不到也返回nil
    func readPsd(username: String) -> String?
    {
        let psd = try? BCCKeychain.getPasswordString(forUsername: username.trim(), andServiceName: KADataType.password.rawValue)
        return psd
    }
    
    ///删除某个用户名的密码
    func deletePsd(username: String, completion: ((Error?) -> Void))
    {
        do {
            try BCCKeychain.deleteItem(forUsername: username.trim(), andServiceName: KADataType.password.rawValue)
            //删除成功后执行回调
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    ///保存某个用户名的身份证号，如果存在则更新；用户名一般是手机号或用户设置或后台系统分配
    func saveIdCard(username: String, id: String, completion: ((Error?) -> Void))
    {
        do {
            try BCCKeychain.storeUsername(username.trim(), andPasswordString: id.trim(), forServiceName: KADataType.idCard.rawValue, updateExisting: true)
            //保存成功后执行回调
            completion(nil)
        } catch {
            //捕获错误后将错误传出去
            completion(error)
        }
    }
    
    ///读取某个用户名的身份证号，如果出错返回nil，获取不到也返回nil
    func readIdCard(username: String) -> String?
    {
        let id = try? BCCKeychain.getPasswordString(forUsername: username.trim(), andServiceName: KADataType.idCard.rawValue)
        return id
    }
    
    ///删除某个用户名的身份证号
    func deleteIdCard(username: String, completion: ((Error?) -> Void))
    {
        do {
            try BCCKeychain.deleteItem(forUsername: username.trim(), andServiceName: KADataType.idCard.rawValue)
            //删除成功后执行回调
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
}
