//
//  EmbellisherMonitor.swift
//  FrameworkStruct
//
//  Created by  jggg on 2021/12/16.
//

/**
 * 修饰器监控器
 */
import UIKit

class EmbellisherMonitor: OriginMonitor, SingletonProtocol
{
    typealias Singleton = EmbellisherMonitor
    
    //单例
    static let shared = EmbellisherMonitor()
    
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
extension EmbellisherMonitor: ExternalInterface
{
    override func originConfig() {
        super.originConfig()
    }
    
}
