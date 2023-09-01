//
//  RegisterLoginWorker.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/2/12.
//

/**
 注册登录工作者
 主要执行注册和登录的流程
 这里所有的业务功能都在UserManager中有定义，这里只是将这些业务功能整理成一个符合逻辑的规范流程，并管理其状态变化
 */
import UIKit

final class RegisterLoginWorker: OriginWorker
{
    //MARK: 属性
    //用户管理器
    fileprivate lazy var userMgr: UserManager = UserManager.shared
    
    //注册或登录时的手机号，可能从外部输入，也可能从上次登录的信息中读取
    fileprivate(set) var phone: String?
    
    //MARK: 方法
    override init() {
        //初始化一些数据
        if let last = UserManager.shared.lastUserPhone
        {
            phone = last
        }
        super.init()
    }
    
    //完成工作
    override func finishWork() {
        phone = nil
        
        super.finishWork()
    }
    
}


//接口方法
extension RegisterLoginWorker: ExternalInterface
{
    ///外部输入手机号，比如在输入手机号界面输入手机号
    func inputPhone(_ phoneStr: String) throws
    {
        try startWork()
        
        phone = phoneStr.trim()
    }
    
    ///验证码登录
    func login(verificationCode: String, success: @escaping GnClo<UserInfoModel>, failure: @escaping NSErrClo) throws
    {
        try startWork()
        
        if let ph = phone
        {
            userMgr.login(phone: ph, verificationCode: verificationCode.trim(), privateCode: nil) { userInfo in
                //TODO: 登录成功后可能有一些操作
                success(userInfo)
            } failure: { error in
                //TODO: 登录失败后可能有一些操作
                failure(error)
            }
        }
    }
    
}
