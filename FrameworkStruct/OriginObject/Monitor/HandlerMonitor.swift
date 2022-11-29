//
//  HandlerMonitor.swift
//  FrameworkStruct
//
//  Created by jggg on 2021/12/28.
//

/**
 * 文档处理器监控器
 */
import UIKit

class HandlerMonitor: OriginMonitor
{
    //单例
    static let shared = HandlerMonitor()
    
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
extension HandlerMonitor: ExternalInterface
{
    override func originConfig() {
        super.originConfig()
    }
    
}
