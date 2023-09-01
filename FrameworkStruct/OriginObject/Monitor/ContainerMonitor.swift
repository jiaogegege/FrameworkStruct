//
//  ContainerMonitor.swift
//  FrameworkStruct
//
//  Created by  jggg on 2021/12/16.
//

/**
 * 数据容器监控器
 */
import UIKit

class ContainerMonitor: OriginMonitor, SingletonProtocol
{
    typealias Singleton = ContainerMonitor
    
    //单例
    static let shared = ContainerMonitor()
    
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
extension ContainerMonitor: ExternalInterface
{
    override func originConfig() {
        super.originConfig()
    }
    
}
