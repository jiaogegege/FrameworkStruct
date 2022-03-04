//
//  CheckerMonitor.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/12/16.
//

/**
 * 数据校验器监控器
 */
import UIKit

class CheckerMonitor: OriginMonitor
{
    //单例
    static let shared = CheckerMonitor()
    
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
