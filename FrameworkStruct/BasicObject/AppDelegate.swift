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
    
    //根监控器，可以从这个对象获取到所有的监控器对象
    var rootMonitor = MonitorMonitor.shared
    
    
    //MARK: 方法
    
    //获取单例对象
    static func shared() -> AppDelegate
    {
        return UIApplication.shared.delegate! as! AppDelegate
    }
    
    //初始化应用程序数据
    func initData()
    {
        
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


}

