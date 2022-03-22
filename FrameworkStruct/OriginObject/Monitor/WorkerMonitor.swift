//
//  WorkerMonitor.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/12/16.
//

/**
 * 工作者监控器
 */
import UIKit

class WorkerMonitor: OriginMonitor
{
    //单例
    static let shared = WorkerMonitor()
    
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
extension WorkerMonitor: ExternalInterface
{
    override func originConfig() {
        super.originConfig()
    }
    
}
