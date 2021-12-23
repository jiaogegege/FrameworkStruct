//
//  UserManager.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/11/5.
//

/**
 * 用户管理器
 */
import UIKit

class UserManager: OriginManager
{
    //MARK: 属性
    //单例对象
    static let shared = UserManager()
    
    
    //MARK: 方法
    //私有化init方法
    private override init()
    {
        super.init()
    }
    
    //重写复制方法
    override func copy() -> Any
    {
        return self // UserManager.shared
    }
        
    //重写复制方法
    override func mutableCopy() -> Any
    {
        return self // UserManager.shared
    }
    
}

/**
 * 外部接口方法
 */
extension UserManager
{
    //获得用户id
    func getUserId() -> String
    {
        return ""
    }
    
    //获得用户token
    func getUserToken() -> String
    {
        return ""
    }
    
}
