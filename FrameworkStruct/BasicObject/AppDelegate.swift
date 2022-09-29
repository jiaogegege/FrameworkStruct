//
//  AppDelegate.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2021/12/9.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate
{
    //MARK: 属性
    
    //如果有SceneDelegate，那么这个属性为nil
    var window: UIWindow?
    
    //根监控器，可以从这个对象获取到所有的监控器对象，从各个监控器对象可以获取到它们管理的组件对象，理论上可以获取到程序运行过程中所有的组件对象
    lazy var rootMonitor = MonitorMonitor.shared
    
    
    //MARK: 方法
    
    //获取单例对象
    static func shared() -> AppDelegate
    {
        return UIApplication.shared.delegate! as! AppDelegate
    }
    
    //初始化应用程序数据
    func initData()
    {
        //初始化程序组件
        rootMonitor.originConfig()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.initData()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    //注册远程推送成功
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        FSLog("remote notification token: \(deviceToken)")
        //获取到token后可以注册到自建服务器或者第三方服务
        NotificationAdapter.shared.registerForRemoteNotificationWithToken(deviceToken)
    }
    
    //注册远程推送失败
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //注册远程推送失败，做一些处理
//        FSLog("register remote notification error: \(error.localizedDescription)")
        NotificationAdapter.shared.registerForRemoteNotificationFail(error)
    }
    
    //通过URL Schemes或其它App打开此App
    //如果未使用SceneDelegate，则系统调用这个方法
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if SandBoxAccessor.shared.isLocalFile(url.absoluteString)
        {
            //打开沙盒或者文件App或者其他App中的文件
            FileManageAdapter.shared.dispatchFileUrl(url, appOptions: options)
        }
        else if UrlSchemeAdapter.shared.isUrlScheme(url)
        {
            //从Url Scheme打开
            UrlSchemeAdapter.shared.dispatchUrl(url, appOptions: options)
        }
        else
        {
            
        }
        
        return true
    }
    
    //如果需要自定义设置屏幕方向，那么释放这段代码，支持`全部/左右横屏/上下竖屏`
//    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
//        ApplicationManager.shared.forceOrientation.getOrientation()
//    }
    
}

