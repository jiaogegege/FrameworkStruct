//
//  ManagerMonitor.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/12/16.
//

/**
 * 管理器监控器
 */
import UIKit

class ManagerMonitor: OriginMonitor
{
    //单例
    static let shared = ManagerMonitor()
    
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
    
    override func originConfig() {
        super.originConfig()
        //初始化应用程序管理器
        _ = ApplicationManager.shared
    }
}
