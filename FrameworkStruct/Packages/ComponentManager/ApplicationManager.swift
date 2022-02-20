//
//  ApplicationManager.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/2/20.
//

/**
 * 应用程序管理器
 * 主要管理应用程序生命周期内的各种状态和事件
 * 包括但不限于`UIApplication`、`AppDelegate`、全局属性、全局状态等
 */
import UIKit

class ApplicationManager: OriginManager
{
    //MARK: 属性
    //单例
    static let shared = ApplicationManager()
    
    //应用程序对象
    let app: UIApplication = UIApplication.shared
    
    //应用程序代理对象
    let appDelegate: AppDelegate = AppDelegate.shared()
    
    
    //MARK: 方法
    //私有化初始化方法
    private override init()
    {
        
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
