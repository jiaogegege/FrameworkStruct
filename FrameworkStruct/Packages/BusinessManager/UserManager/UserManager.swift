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
    
    //当前登录的用户信息，当用户登录或注册成功后有值
    fileprivate(set) var currentUser: UserInfoModel?
    
    //网络适配器
    fileprivate lazy var na: NetworkAdapter = NetworkAdapter.shared
    
    
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
extension UserManager: ExternalInterface
{
    //上一次登录用户的手机号，如果没有登录信息则为nil
    var lastUserPhone: String? {
        return nil
    }
    
    //当前登录的用户id
    var currentUserId: String {
        return ""
    }

    //当前登录的用户token
    var currentUserToken: String {
        return ""
    }
    
    /**************************************** 登录注册相关功能 Section Begin ***************************************/
    ///验证码登录
    ///参数：phone：手机号；verificationCode：验证码；privateCode：内测码
    func login(phone: String,
               verificationCode: String,
               privateCode: String? = nil,
               success: @escaping ((UserInfoModel) -> Void),
               failure: @escaping ErrorClosure)
    {
        na.loginWithPhoneAndSms(phone: phone, token: ApplicationManager.shared.getDeviceId(), verifyCode: verificationCode, verificationCode: privateCode) { userInfo in
            //TODO: 登录成功后做一些数据保存的操作和注册推送等操作
            success(userInfo)
        } failure: { error in
            //TODO: 登录失败后可能有一些操作
            failure(error)
        }
    }
    
    /**************************************** 登录注册相关功能 Section End ***************************************/
    
}
