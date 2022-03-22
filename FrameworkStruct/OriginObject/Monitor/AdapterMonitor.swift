//
//  AdapterMonitor.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/12/16.
//

/**
 * 适配器监控器
 */
import UIKit

class AdapterMonitor: OriginMonitor
{
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
    }
    
}
