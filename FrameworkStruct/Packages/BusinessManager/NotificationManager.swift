//
//  NotificationManager.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/2/20.
//

/**
 * 推送通知管理器
 * 1. 远程推送
 * 2. 本地推送
 * 3. App内自定义通知
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
