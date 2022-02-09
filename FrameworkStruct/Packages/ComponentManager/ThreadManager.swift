//
//  ThreadManager.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2021/12/19.
//

/**
 * 多线程管理器
 * 主要管理多线程的创建、执行、同步等
 */
import UIKit

class ThreadManager: OriginManager
{
    //MARK: 属性
    //单例对象
    static let shared = ThreadManager()
    
    //操作队列容器
    fileprivate var groupDict: Dictionary<String, DispatchGroup> = [:]
    fileprivate var groupQueueDict: Dictionary<String, DispatchQueue> = [:]
    
    
    //MARK: 方法
    //私有化init方法
    private override init()
    {
        super.init()
    }
    
    //重写复制方法
    override func copy() -> Any
    {
        return self
    }
        
    //重写复制方法
    override func mutableCopy() -> Any
    {
        return self
    }
    
}


//接口方法
extension ThreadManager: ExternalInterface
{
    ///在线程中异步执行代码
    func async(onMain: Bool = true, action: @escaping VoidClosure)
    {
        if onMain
        {
            DispatchQueue.main.async(execute: action)
        }
        else
        {
            DispatchQueue.global().async(execute: action)
        }
    }
    
    ///在线程中同步执行代码
    ///注意：一般不会这么使用
    func sync(onMain: Bool = true, action: @escaping VoidClosure)
    {
        if onMain
        {
            DispatchQueue.main.sync(execute: action)
        }
        else
        {
            DispatchQueue.global().sync(execute: action)
        }
    }
    
    ///一个操作队列中包含多个异步操作，要等所有异步操作完成之后再执行一个动作，一般用于多个网络请求
    ///参数：
    ///groupQueueLabel：在哪个线程中执行操作
    ///ops:操作列表，也就是多个网络请求操作，传入闭包，对闭包的要求是提供一个接收DispatchGroup的参数
    ///completion:完成后的操作
    func asyncGroup(ops: Array<DispatchGroupClosure>, groupQueueLabel: ThreadLabel = .main, completion: @escaping VoidClosure)
    {
        //先从容器中获取已有的队列看是否相等
        let group: DispatchGroup
        if let gr = self.groupDict[groupQueueLabel.getLabel()]
        {
            group = gr
        }
        else
        {
            group = DispatchGroup()
            self.groupDict[groupQueueLabel.getLabel()] = group  //创建后保存
        }
        let groupQueue: DispatchQueue
        if let gq = self.groupQueueDict[groupQueueLabel.getLabel()]
        {
            groupQueue = gq
        }
        else
        {
            if groupQueueLabel == .main
            {
                groupQueue = DispatchQueue.main //主队列
            }
            else if groupQueueLabel == .global  //全局队列
            {
                groupQueue = DispatchQueue.global()
            }
            else
            {
                groupQueue = DispatchQueue(label: groupQueueLabel.getLabel())   //自定义队列
            }
            self.groupQueueDict[groupQueueLabel.getLabel()] = groupQueue    //创建后保存
        }
        
        //添加操作到队列中
        for op in ops
        {
            group.enter()
            groupQueue.async {
                op {
                    group.leave()
                }
            }
        }
        
        //添加完成操作
        group.notify(queue: groupQueue) {
            self.groupDict[groupQueueLabel.getLabel()] = nil
            self.groupQueueDict[groupQueueLabel.getLabel()] = nil
            completion()
        }
    }
    
}


//内部类型
extension ThreadManager: InternalType
{
    ///线程标签
    enum ThreadLabel: Equatable
    {
        case main
        case global
        case custom(String)
        
        //获取label文本
        func getLabel() -> String
        {
            switch self {
            case .main:
                return "main"
            case .global:
                return "global"
            case .custom(let label):
                return label
            }
        }
        
        //比较
        static func == (lhs: Self, rhs: Self) -> Bool
        {
            switch (lhs, rhs) {
            case (.main, .main):
                return true
            case (.global, .global):
                return true
            case (.custom(let ll), .custom(let rl)):
                return ll == rl
            default:
                return false
            }
        }
    }
    
    ///异步操作闭包类型
    typealias DispatchGroupClosure = ((_ finish: @escaping VoidClosure) -> Void)
    
}
