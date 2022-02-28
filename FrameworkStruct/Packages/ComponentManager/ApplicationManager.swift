//
//  ApplicationManager.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/2/20.
//

/**
 * 应用程序管理器
 * 主要管理应用程序生命周期内的各种状态和事件
 * 包括但不限于`UIApplication`、`AppDelegate`、`UIWindow`、全局属性、全局状态等
 */
import UIKit

class ApplicationManager: OriginManager
{
    //MARK: 属性
    //单例
    static let shared = ApplicationManager()
    
    //应用程序对象
    weak var app: UIApplication! = UIApplication.shared
    
    //应用程序代理对象
    weak var appDelegate: AppDelegate! = AppDelegate.shared()
    
    //窗口对象
    var window: UIWindow {
        g_getWindow()
    }
    
    
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
extension ApplicationManager: ExternalInterface
{
    
}
