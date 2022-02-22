//
//  NotificationManager.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/2/20.
//

/**
 * 通知管理器
 * 1. App内自定义通知
 * 类似于淘宝那种打开app后在顶部弹出的通知类型，具体功能根据需求定义，这里只是做一个入口
 * 
 */
import UIKit

class NotificationManager: OriginManager
{
    //单例
    static let shared = NotificationManager()
    
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
extension NotificationManager: ExternalInterface
{
    
}
