//
//  OriginAdapter.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/11/5.
//

/**
 * 最初的适配器
 */
import Foundation


/**
 * 适配器定义的通用接口，如果有通用的功能需要子类实现，那么定义在此处
 * 可以作为类型使用
 */
protocol AdapterProtocol
{
    
}


/**
 * 所有适配器的父类，如果有通用的功能，可以在此处实现
 * 所有子类命名都应该以`Adpater`结尾
 */
class OriginAdapter: NSObject
{
    //状态管理器，建议有复杂变化的状态都通过状态管理器管理
    let stMgr: StatusManager = StatusManager(capacity: 5)
    
    //监控器，每一个适配器在创建的时候都要加入到监控器中
    weak var monitor: AdapterMonitor!
    
    
    override init()
    {
        self.monitor = AdapterMonitor.shared
        super.init()
        monitor.addItem(item: self)
    }
}


//MARK: 实现协议
/**
 * 实现`AdapterProtocol`协议
 */
extension OriginAdapter: AdapterProtocol
{
    
}


/**
 * 实现`OriginProtocol`协议
 */
extension OriginAdapter: OriginProtocol
{
    func typeDesc() -> String
    {
        let typeStr = type(of: self)
        return typeStr.description()
    }
    
}
