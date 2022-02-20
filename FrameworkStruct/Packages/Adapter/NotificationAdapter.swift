//
//  NotificationAdapter.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/2/20.
//

/**
 * 系统推送通知适配器
 * 1. 本地推送
 * 2. 远程推送
 */
import UIKit
import UserNotifications
import UserNotificationsUI

///推送通知适配器代理方法
protocol NotificationAdapterDelegate
{
    ///申请权限结果
    func notificationAdapterDidFinishAuthorization(isGranted: Bool)
    
    ///申请权限错误
    func notificationAdapterDidAuthorizationError(error: Error)
    
}

class NotificationAdapter: OriginAdapter
{
    //MARK: 属性
    //单例
    static let shared = NotificationAdapter()
    
    ///代理对象
    var delegate: NotificationAdapterDelegate?
    
    //通知中心
    fileprivate var notificationCenter: UNUserNotificationCenter {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        return center
    }
    
    //权限申请结果
    fileprivate var isGranted: Bool = false
    
    
    //MARK: 方法
    //私有化初始化方法
    private override init()
    {
        super.init()
        self.authorize()
    }
    
    override func copy() -> Any
    {
        return self
    }
    
    override func mutableCopy() -> Any
    {
        return self
    }
    
    //申请通知权限
    fileprivate func authorize()
    {
        //请求通知权限，申请的类型options可修改，根据实际需求使用
        self.notificationCenter.requestAuthorization(options: [.alert, .badge, .sound, .carPlay, .providesAppNotificationSettings]) {[weak self] (isGranted, error) in
            //根据权限申请结果采取不同的操作
            //不管有没有错误都将申请结果传出去
//            FSLog("Notification Permission Granted:\(isGranted)")
            self?.isGranted = isGranted
            if let delegate = self?.delegate {
                delegate.notificationAdapterDidFinishAuthorization(isGranted: isGranted)
            }
            if isGranted
            {
                self?.registerForRemoteNotification()
            }
            
            if let error = error {
                //如果申请通知权限错误
                FSLog("request notification auth error: \(error.localizedDescription)")
                //将错误传出去
                if let delegate = self?.delegate {
                    delegate.notificationAdapterDidAuthorizationError(error: error)
                }
            }
        }
    }
    
    //注册远程推送
    fileprivate func registerForRemoteNotification()
    {
        #if targetEnvironment(simulator)
//        FSLog("Simulator don't support remote notification")
        #else
        g_async {
            ApplicationManager.shared.app.registerForRemoteNotifications()
        }
        #endif
    }
    
}


//代理方法
extension NotificationAdapter: DelegateProtocol, UNUserNotificationCenterDelegate
{
    //在展示通知前进行处理，即有机会在展示通知前再修改通知内容
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //1. 处理通知
    
        //2. 处理完成后调用 completionHandler ，用于指示在前台显示通知的形式
        
    }
    
    //当用户点击了通知中心，打开app，清除通知等操作之后的回调方法
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
    }
    
    //当用户在通知中心左滑某个通知选择设置时，会调用这个方法，从“设置”打开时，`notification`将为nil
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        
    }
    
}


//接口方法
extension NotificationAdapter: ExternalInterface
{
    ///是否可以推送通知
    var canPush: Bool {
        return self.isGranted
    }
    
    ///获取到远程推送token，在AppDelegate中调用这个方法，在这里可以对接第三方推送服务
    func registerForRemoteNotificationWithToken(_ token: Data)
    {
        
    }
    
    ///注册远程推送失败
    func registerForRemoteNotificationFail(_ error: Error)
    {
        //如果失败做一些处理
        
    }
    
    
}
