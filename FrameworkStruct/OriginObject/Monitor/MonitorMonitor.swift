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
    
    //文档监控器
    var documentMonitor: DocumentMonitor!
    
    //文档处理器监控器
    var handlerMonitor: HandlerMonitor!
    
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
        self.documentMonitor = DocumentMonitor.shared
        self.handlerMonitor = HandlerMonitor.shared
        self.adapterMonitor = AdapterMonitor.shared
        self.managerMonitor = ManagerMonitor.shared
        self.embellisherMonitor = EmbellisherMonitor.shared
        self.workerMonitor = WorkerMonitor.shared
        super.init()
        self.addItem(self.accessorMonitor)
        self.addItem(self.checkerMonitor)
        self.addItem(self.containerMonitor)
        self.addItem(self.documentMonitor)
        self.addItem(self.handlerMonitor)
        self.addItem(self.adapterMonitor)
        self.addItem(self.managerMonitor)
        self.addItem(self.embellisherMonitor)
        self.addItem(self.workerMonitor)
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


//接口方法
extension MonitorMonitor: ExternalInterface
{
    ///最初的配置，需要外部调用
    override func originConfig() {
        super.originConfig()
        self.accessorMonitor.originConfig()
        self.checkerMonitor.originConfig()
        self.containerMonitor.originConfig()
        self.documentMonitor.originConfig()
        self.handlerMonitor.originConfig()
        self.adapterMonitor.originConfig()
        self.managerMonitor.originConfig()
        self.embellisherMonitor.originConfig()
        self.workerMonitor.originConfig()
    }
    
}
