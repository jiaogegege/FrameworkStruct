//
//  MonitorMonitor.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/12/16.
//

/**
 * 监控器的监控器，最基础的监控器，理论上可以从这个监控器获取程序中所有的对象，只不过比较麻烦
 */
import UIKit

class MonitorMonitor: OriginMonitor
{
    //单例
    static let shared = MonitorMonitor()
    
    //数据存取器监控器
    var accessorMonitor: AccessorMonitor!
    
    //数据校验器监控器
    var checkerMonitor: CheckerMonitor!
    
    //数据容器监控器
    var containerMonitor: ContainerMonitor!
    
    //适配器监控器
    var adapterMonitor: AdapterMonitor!
    
    //管理器监控器
    var managerMonitor: ManagerMonitor!
    
    //修饰器监控器
    var embellisherMonitor: EmbellisherMonitor!
    
    //工作者监控器
    var workerMonitor: WorkerMonitor!
    
    //私有化初始化方法
    private override init()
    {
        self.accessorMonitor = AccessorMonitor.shared
        self.checkerMonitor = CheckerMonitor.shared
        self.containerMonitor = ContainerMonitor.shared
        self.adapterMonitor = AdapterMonitor.shared
        self.managerMonitor = ManagerMonitor.shared
        self.embellisherMonitor = EmbellisherMonitor.shared
        self.workerMonitor = WorkerMonitor.shared
        super.init()
        self.addItem(item: self.accessorMonitor)
        self.addItem(item: self.checkerMonitor)
        self.addItem(item: self.containerMonitor)
        self.addItem(item: self.adapterMonitor)
        self.addItem(item: self.managerMonitor)
        self.addItem(item: self.embellisherMonitor)
        self.addItem(item: self.workerMonitor)
    }
    
    override func copy() -> Any
    {
        return self
    }
        
    override func mutableCopy() -> Any
    {
        return self
    }
    
}
