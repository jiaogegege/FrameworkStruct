//
//  OriginMonitor.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/11/26.
//

/**
 * 最初的监控器
 */
import Foundation


/**
 * 监控器定义的通用接口，如果有通用的功能需要子类实现，那么定义在此处
 * 可以作为类型使用
 */
protocol MonitorProtocol
{
    
}


/**
 * 所有监控器的父类，如果有通用的功能，可以在此处实现
 * 所有子类命名都应该以`Monitor`结尾
 */
class OriginMonitor: NSObject
{

}


//MARK: 实现协议
/**
 * 实现`MonitorProtocol`协议
 */
extension OriginMonitor: MonitorProtocol
{
    
}


/**
 * 实现`OriginProtocol`协议
 */
extension OriginMonitor: OriginProtocol
{
    func desString() -> String
    {
        let typeStr = type(of: self)
        return typeStr.description()
    }
    
}
