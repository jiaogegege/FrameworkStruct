//
//  OriginHandler.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2021/12/28.
//

/**
 * 最初的文档处理器
 */
import UIKit


/**
 * 文档处理器对象定义的通用接口，如果有通用的功能需要子类实现，那么定义在此处
 * 可以作为类型使用
 */
protocol HandlerProtocol
{
    
}


/**
 * 所有文档处理器的父类，如果有通用的功能，可以在此处实现
 * 所以子类命名都应该以`Handler`结尾
 */
class OriginHandler: NSObject
{
    //状态管理器，建议有复杂变化的状态都通过状态管理器管理
    fileprivate(set) lazy var stMgr: StatusManager = StatusManager(capacity: originStatusStep)
    
    //监控器，每一个文档处理器在创建的时候都要加入到监控器中
    fileprivate(set) weak var monitor: HandlerMonitor!
    
    
    override init()
    {
        self.monitor = HandlerMonitor.shared
        super.init()
        monitor.addItem(self)
    }
}


//MARK: 实现协议
/**
 * 实现`HandlerProtocol`协议
 */
extension OriginHandler: HandlerProtocol
{
    
}


/**
 * 实现`OriginProtocol`协议
 */
extension OriginHandler: OriginProtocol
{
    func typeDesc() -> String
    {
        let typeStr = type(of: self)
        return typeStr.description()
    }
    
}
