//
//  OriginGroup.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/11/5.
//

/**
 * 最初的工作者
 */
import Foundation


/**
 * 工作者定义的通用接口，如果有通用的功能需要子类实现，那么定义在此处
 * 可以作为类型使用
 */
protocol WorkerProtocol
{
    
}


/**
 * 所有工作者的父类，如果有通用的功能，可以在此处实现
 * 所有子类命名都应该以`Worker`结尾
 */
class OriginWorker: NSObject
{
    //状态管理器，建议有复杂变化的状态都通过状态管理器管理
    let stMgr: StatusManager = StatusManager(capacity: 5)
    
    //监控器，每一个管理器在创建的时候都要加入到监控器中
    weak var monitor: WorkerMonitor!
    
    
    override init()
    {
        self.monitor = WorkerMonitor.shared
        super.init()
        monitor.addItem(item: self)
    }
}


//MARK: 实现协议
/**
 * 实现`WorkerProtocol`协议
 */
extension OriginWorker: WorkerProtocol
{
    
}


/**
 * 实现`OriginProtocol`协议
 */
extension OriginWorker: OriginProtocol
{
    func desString() -> String
    {
        let typeStr = type(of: self)
        return typeStr.description()
    }
    
}
