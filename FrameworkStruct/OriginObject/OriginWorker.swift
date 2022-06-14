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
 * 工作者子类中的所有接口方法在调用的时候都要判断是否可以工作，避免出现意外情况
 */
protocol WorkerProtocol
{
    ///工作者当前工作状态
    var currentWorkState: OriginWorker.WorkState { get }
    
    ///是否可以工作，当处于ready和working状态时返回true，调用任何业务类方法时，都要先判断是否可以工作，不然可能出现异常和闪退
    var canWork: Bool { get }
    
    ///开始工作，调用Worker的任何工作方法之前都要先调用这个方法，或者在所有初始化方法完成和外部数据赋值完毕之后调用该方法；表示工作者开始工作，如果状态不对，可能抛出一个错误
    func startWork() throws
    
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
    
    //监控器，每一个工作者在创建的时候都要加入到监控器中
    fileprivate(set) weak var monitor: WorkerMonitor!
    
    
    //如果子类有自己的初始化方法，那么在最后要调用父类的初始化方法
    //子类如果有自定义初始化方法，那么在最开始要设置状态为`notReady`，在最后调用父类的这个初始化方法
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
    
    //一些内部错误类型
    enum WorkerError: Error {
        case notReadyError                  //工作者还未准备好的错误，一般是一些初始数据还未获取到
        case unavailableError               //不可用错误，工作者已经完成了工作，清理了所有状态和数据，不可再次使用
    }
    
}


//MARK: 实现协议
/**
 * 实现`WorkerProtocol`协议
 */
extension OriginWorker: WorkerProtocol
{
    var currentWorkState: WorkState {
        return stMgr.status(forKey: WorkerStatusKey.workState) as! WorkState
    }
    
    var canWork: Bool {
        if currentWorkState == .ready || currentWorkState == .working
        {
            return true
        }
        FSLog("\(self.className) can't work, current state is \(currentWorkState)")
        return false
    }
    
    //子类在执行任何工作方法之前要调用这个方法
    func startWork() throws {
        //判断当前状态
        switch currentWorkState {
        case .notReady: //如果当前未准备好，那么返回错误信息
            throw WorkerError.notReadyError
        case .ready:    //就绪状态，正常流程，将状态切换为工作状态
            stMgr.setStatus(WorkState.working, forKey: WorkerStatusKey.workState)
        case .working:  //已经处于工作状态，什么都不做
            break
        case .done:     //当前工作者不再可用
            throw WorkerError.unavailableError
        }
    }
    
    //完成工作，子类如果覆写这个方法，需要在做完清理工作的最后调用父类方法
    @objc func finishWork()
    {
        if currentWorkState != .done    //如果还不是完毕状态，那么清理资源并设置为完毕状态
        {
            monitor.deleteItem(self)    //从监控器中删除
            stMgr.setStatus(WorkState.done, forKey: WorkerStatusKey.workState)  //设置状态为完毕
        }
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
