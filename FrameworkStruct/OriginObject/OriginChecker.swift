//
//  OriginChecker.swift
//  FrameworkStruct
//
//  Created by  jggg on 2021/11/5.
//

/**
 * 最初的校验器
 * 具体的校验器需要根据业务逻辑定义校验规则
 */
import Foundation


/**
 * 校验器定义的通用接口，如果有通用的功能需要子类实现，那么定义在此处
 * 可以作为类型使用
 */
protocol CheckerProtocol
{
    
}


/**
 * 所有校验器的父类，如果有通用的功能，可以在此处实现
 * 所有子类命名都应该以`Checker`结尾
 */
class OriginChecker: NSObject
{
    //监控器，每一个校验器在创建的时候都要加入到监控器中
    fileprivate(set) weak var monitor: CheckerMonitor!
    
    //状态管理器，建议有复杂变化的状态都通过状态管理器管理
    fileprivate(set) lazy var stMgr: StatusManager = StatusManager(capacity: originStatusStep)
    
    
    override init()
    {
        self.monitor = CheckerMonitor.shared
        super.init()
        monitor.addItem(self)
    }
}


//MARK: 实现协议
/**
 * 实现`CheckerProtocol`协议
 */
extension OriginChecker: CheckerProtocol
{
    
}


/**
 * 实现`OriginProtocol`协议
 */
extension OriginChecker: OriginProtocol
{
    func typeDesc() -> String
    {
        let typeStr = type(of: self)
        return typeStr.description()
    }
    
}
