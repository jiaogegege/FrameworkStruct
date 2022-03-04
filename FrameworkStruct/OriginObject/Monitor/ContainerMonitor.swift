//
//  ContainerMonitor.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/12/16.
//

/**
 * 数据容器监控器
 */
import UIKit

class ContainerMonitor: OriginMonitor
{
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
    
    override func originConfig() {
        super.originConfig()
    }
    
}
