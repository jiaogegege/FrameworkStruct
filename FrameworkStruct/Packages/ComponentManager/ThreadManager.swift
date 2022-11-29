//
//  ThreadManager.swift
//  FrameworkStruct
//
//  Created by jggg on 2021/12/19.
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
    fileprivate var operationQueueDict: Dictionary<String, OperationQueue> = [:]
    
    
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
    
    ///异步操作闭包类型，传入一个名为finish的无返回闭包，表示结束该任务，需要在异步操作完成后调用，不管异步操作是否成功都需要调用
    typealias DispatchGroupClosure = ((_ finish: @escaping VoidClosure) -> Void)
    
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
    
    ///在线程中异步执行代码，并在执行完后在原来调用的线程中返回；该方法主要用于处理耗时的后台任务并在原来的线程中返回
    ///queue：调用该方法时所在的队列
    func async(onMain: Bool = false, action: @escaping ((_ queue: DispatchQueue) -> Void))
    {
        let currentQueue = self.currentQueue()
        let queue = onMain ? DispatchQueue.main : DispatchQueue.global()
        queue.async {
            action(currentQueue)
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
    
    ///获得当前queue，如果没有，返回main
    func currentQueue() -> DispatchQueue
    {
        OperationQueue.current?.underlyingQueue ?? .main
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
                    group.leave()   //执行finish的回调，需要op在内部执行
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
    
    ///执行多个并发操作，每个操作都是同步的，内部无异步操作
    ///identifier:指定这一组操作的id
    ///ops:需要并发执行的操作
    ///dependencyOps：这个数组中的操作依赖ops中的操作完成后再执行
    ///onMain:是否在主线程执行
    ///maxConcurrent:最大并发数，-1为不限制，1为串行，大于1时不会超过系统最大值，不要设置为0
    ///completion:完成操作，如果还要添加额外的操作，那么不要设置这个值，等所有操作添加完了，调用`addCompletionToConcurrentQueue`来添加完成操作
    ///
    ///returns:返回队列，外部程序可以向队列中添加更多操作
    func concurrentQueue(identifier: String,
                         ops: Array<VoidClosure>,
                         dependencyOps: Array<VoidClosure>? = nil,
                         onMain: Bool = false,
                         maxConcurrent: Int = -1,
                         completion: VoidClosure? = nil) -> OperationQueue
    {
        let queue: OperationQueue
        if onMain
        {
            queue = OperationQueue.main
        }
        else
        {
            queue = OperationQueue()
        }
        queue.maxConcurrentOperationCount = maxConcurrent
        self.operationQueueDict[identifier] = queue //将队列添加到字典中
        
        //先处理依赖操作
        var dependencyArray: Array<Operation> = []
        if let deops = dependencyOps
        {
            for op in deops
            {
                let blockOp = BlockOperation {
                    op()
                }
                dependencyArray.append(blockOp)
            }
        }
        
        //处理ops
        for op in ops
        {
            let blockOp = BlockOperation {
                op()
            }
            for deop in dependencyArray
            {
                //每一个deop都要添加依赖
                deop.addDependency(blockOp)
            }
            queue.addOperation(blockOp)
        }
        
        //添加依赖操作到队列
        for deop in dependencyArray
        {
            queue.addOperation(deop)
        }
        
        //添加完成操作，如果还添加其他操作，这个completion不会执行
        if let comp = completion
        {
            weak var weakSelf = self
            weak var weakQ = queue
            queue.addBarrierBlock {
                if weakQ!.operationCount <= 0
                {
                    weakSelf?.operationQueueDict[identifier] = nil
                    comp()
                }
            }
        }
        
        return queue
    }
    
    ///向特定id的并发队列中添加操作
    ///如果操作对象之间有复杂的依赖关系，或者需要配置大量属性，建议使用这个方法
    func concurrentQueueAddOp(identifier: String, op: Operation)
    {
        //尝试获取队列，如果未获取到，那么重新创建
        var queue = self.operationQueueDict[identifier]
        if queue == nil
        {
            queue = self.concurrentQueue(identifier: identifier, ops: [])
        }
        queue?.addOperation(op)
    }
    
    ///向特定id的并发队列添加完成操作，如果不存在该队列则什么都不做
    ///如果调用了`addOpToConcurrentQueue`方法向队列中添加操作，如果需要监控所有操作完成的事件，那么一定要调用该方法
    func concurrentQueueAddCompletion(identifier: String, completion: @escaping VoidClosure)
    {
        if let queue = self.operationQueueDict[identifier]
        {
            weak var weakSelf = self
            weak var weakQ = queue
            queue.addBarrierBlock {
                if weakQ!.operationCount <= 0
                {
                    weakSelf?.operationQueueDict[identifier] = nil
                    completion()
                }
            }
        }
    }
    
}
