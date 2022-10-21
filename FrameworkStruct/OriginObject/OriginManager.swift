//
//  OriginManager.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/11/5.
//

/**
 * 最初的管理器
 */
import Foundation


/**
 * 管理器定义的通用接口，如果有通用的功能需要子类实现，那么定义在此处
 * 可以作为类型使用
 */
protocol ManagerProtocol
{
    
}


/**
 * 所有管理器的父类，如果有通用的功能，可以在此处实现
 * 所有子类命名都应该以`Manager`结尾
 */
class OriginManager: NSObject
{
    //状态管理器，建议有复杂变化的状态都通过状态管理器管理
    fileprivate(set) lazy var stMgr: StatusManager = StatusManager(capacity: originStatusStep)
    
    //监控器，每一个管理器在创建的时候都要加入到监控器中
    fileprivate(set) weak var monitor: ManagerMonitor!
    
    
    override init()
    {
        self.monitor = ManagerMonitor.shared
        super.init()
        monitor.addItem(self)
    }
    
}


//MARK: 实现协议
/**
 * 实现`ManagerProtocol`协议
 */
extension OriginManager: ManagerProtocol
{
    
}


/**
 * 实现`OriginProtocol`协议
 */
extension OriginManager: OriginProtocol
{
    func typeDesc() -> String
    {
        let typeStr = type(of: self)
        return typeStr.description()
    }
    
}
