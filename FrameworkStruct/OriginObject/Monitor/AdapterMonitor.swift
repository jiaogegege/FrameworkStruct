//
//  AdapterMonitor.swift
//  FrameworkStruct
//
//  Created by  jggg on 2021/12/16.
//

/**
 * 适配器监控器
 */
import UIKit

class AdapterMonitor: OriginMonitor, SingletonProtocol
{
    typealias Singleton = AdapterMonitor
    
    //单例
    static let shared = AdapterMonitor()
    
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
extension AdapterMonitor: ExternalInterface
{
    override func originConfig() {
        super.originConfig()
        //初始化网络适配器
        _ = NetworkAdapter.shared
        //初始化推送通知适配器
        _ = NotificationAdapter.shared
        //初始化iCloud适配器，如果支持iCloud的话
        _ = iCloudAccessor.shared
    }
    
}
