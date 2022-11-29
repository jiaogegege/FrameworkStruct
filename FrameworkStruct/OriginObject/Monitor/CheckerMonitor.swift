//
//  CheckerMonitor.swift
//  FrameworkStruct
//
//  Created by  jggg on 2021/12/16.
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
    
}


//接口方法
extension CheckerMonitor: ExternalInterface
{
    override func originConfig() {
        super.originConfig()
    }
    
}
