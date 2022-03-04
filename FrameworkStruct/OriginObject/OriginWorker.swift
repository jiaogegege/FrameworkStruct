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
    ///工作者当前工作状态
    func currentWorkState() -> OriginWorker.WorkState
    
    ///是否可以工作，当处于ready和working状态时返回true
    var canWork: Bool { get }
    
    ///开始工作，调用worker的任何方法都要先调用这个方法，表示工作者开始工作
    func startWork()
    
    ///结束工作，每一个工作者在完成工作之后，都需要被调用这个方法，用来清理资源，释放内存，当调用完这个方法后，该工作者处于不可工作状态，不应该再调用其任何方法
    ///具体在哪里调用这个方法根据业务需求确定应该由外部程序调用
    func finishWork()
}


/**
 * 所有工作者的父类，如果有通用的功能，可以在此处实现
 * 所有子类命名都应该以`Worker`结尾
 */
class OriginWorker: NSObject
{
    //状态管理器，建议有复杂变化的状态都通过状态管理器管理
    let stMgr: StatusManager = StatusManager(capacity: originStatusStep)
    
    //监控器，每一个管理器在创建的时候都要加入到监控器中
    weak var monitor: WorkerMonitor!
    
    
    //如果子类有自己的初始化方法，那么在最后要调用父类的初始化方法
    //子类的初始化方法在最开始要设置状态为`notReady`
    override init()
    {
        stMgr.setStatus(WorkState.notReady, forKey: WorkerStatusKey.workState)  //未就绪状态
        self.monitor = WorkerMonitor.shared
        super.init()
        monitor.addItem(self)
        stMgr.setStatus(WorkState.ready, forKey: WorkerStatusKey.workState)     //就绪状态
    }
    
    
    deinit {
        FSLog(self.typeDesc() + " dealloc")
    }
}


//内部类型
extension OriginWorker
{
    //工作者的一些状态枚举
    enum WorkerStatusKey: SMKeyType {
        case workState                      //当前工作状态
    }
    
    //工作者当前工作状态
    enum WorkState: Int {
        case notReady = 0                   //未就绪状态，初始化还未完成，一般不会用到
        case ready = 1                      //就绪状态，初始化完成
        case working = 2                    //工作中状态，正在处理业务
        case done = 3                       //完毕状态，完成工作后不再可用
    }
}


//MARK: 实现协议
/**
 * 实现`WorkerProtocol`协议
 */
extension OriginWorker: WorkerProtocol
{
    func currentWorkState() -> WorkState {
        return stMgr.status(forKey: WorkerStatusKey.workState) as! WorkState
    }
    
    var canWork: Bool {
        if currentWorkState() == .ready || currentWorkState() == .working
        {
            return true
        }
        return false
    }
    
    func startWork() {
        stMgr.setStatus(WorkState.working, forKey: WorkerStatusKey.workState)
    }
    
    //完成工作，子类如果覆写这个方法，需要在做完清理工作的最后调用父类方法
    func finishWork()
    {
        stMgr.setStatus(WorkState.done, forKey: WorkerStatusKey.workState)
        monitor.deleteItem(self)
    }
    
    
}


/**
 * 实现`OriginProtocol`协议
 */
extension OriginWorker: OriginProtocol
{
    func typeDesc() -> String
    {
        let typeStr = type(of: self)
        return typeStr.description()
    }
    
}
