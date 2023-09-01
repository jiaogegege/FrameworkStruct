//
//  UserManager.swift
//  FrameworkStruct
//
//  Created by  jggg on 2021/11/5.
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
    
    //数据容器
    fileprivate lazy var dc: DatasContainer = DatasContainer.shared
    
    
    //MARK: 方法
    //私有化init方法
    private override init()
    {
        super.init()
        //订阅数据容器服务
        self.dc.subscribe(key: DCDataKey.currentUserInfo, delegate: self)
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


//代理方法
extension UserManager: DelegateProtocol, ContainerServices
{
    func containerDidUpdateData(key: AnyHashable, value: Any)
    {
        if let k = key as? DCDataKey
        {
            if k == DCDataKey.currentUserInfo
            {
                self.currentUser = value as? UserInfoModel
            }
        }
    }
    
    func containerDidClearData(key: AnyHashable) {
        if let k = key as? DCDataKey
        {
            if k == DCDataKey.currentUserInfo
            {
                self.currentUser = nil
            }
        }
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
    var currentUserId: String? {
        return currentUser?.userId
    }

    //当前登录的用户token
    var currentUserToken: String? {
        return currentUser?.token
    }
    
    /**************************************** 登录注册相关功能 Section Begin ***************************************/
    ///验证码登录
    ///参数：phone：手机号；verificationCode：验证码；privateCode：内测码
    func login(phone: String,
               verificationCode: String,
               privateCode: String? = nil,
               success: @escaping GnClo<UserInfoModel>,
               failure: @escaping NSErrClo)
    {
        na.loginWithPhoneAndSms(phone: phone, token: ApplicationManager.shared.getDeviceId(), verifyCode: verificationCode, verificationCode: privateCode) {[weak self] userInfo in
            //TODO: 登录成功后做一些数据保存的操作和注册推送等操作
            //保存到数据容器
            self?.dc.mutate(key: DCDataKey.currentUserInfo, value: userInfo)
            success(userInfo)
        } failure: { error in
            //TODO: 登录失败后可能有一些操作
            failure(error)
        }
    }
    
    ///退出登录
    func logout()
    {
        
    }
    
    /**************************************** 登录注册相关功能 Section End ***************************************/
    
}
