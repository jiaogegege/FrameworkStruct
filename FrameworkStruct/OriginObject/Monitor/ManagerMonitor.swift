//
//  ManagerMonitor.swift
//  FrameworkStruct
//
//  Created by  jggg on 2021/12/16.
//

/**
 * 管理器监控器
 */
import UIKit

class ManagerMonitor: OriginMonitor, SingletonProtocol
{
    typealias Singleton = ManagerMonitor
    
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

}


//接口方法
extension ManagerMonitor: ExternalInterface
{
    override func originConfig() {
        super.originConfig()
        //初始化应用程序管理器
        _ = ApplicationManager.shared
    }
    
}
