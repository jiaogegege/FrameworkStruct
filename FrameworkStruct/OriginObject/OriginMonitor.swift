//
//  OriginMonitor.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/11/26.
//

/**
 * 最初的监控器
 */
import Foundation


/**
 * 监控器定义的通用接口，如果有通用的功能需要子类实现，那么定义在此处
 * 可以作为类型使用
 */
protocol MonitorProtocol
{
    //监控器中所有元素的数量
    var itemCount: Int {get}
    
    //获取监控器中所有元素
    func allItems() -> [AnyObject]
    
    //某个元素是否存在监控器中
    func isItemExist(item: AnyObject) -> Bool
    
    //添加一个元素
    func addItem(item: AnyObject)
    
    //删除一个元素
    func deleteItem(item: AnyObject)
    
    //获取一个元素
    //暂时不知道这个方法的作用，留作扩展
    func getItem() -> AnyObject
}


/**
 * 所有监控器的父类，如果有通用的功能，可以在此处实现
 * 所有子类命名都应该以`Monitor`结尾
 */
class OriginMonitor: NSObject
{
    
}


//MARK: 实现协议
/**
 * 实现`MonitorProtocol`协议
 */
extension OriginMonitor: MonitorProtocol
{
    var itemCount: Int {
        <#code#>
    }
    
    func allItems() -> [AnyObject] {
        <#code#>
    }
    
    func isItemExist(item: AnyObject) -> Bool {
        <#code#>
    }
    
    func addItem(item: AnyObject) {
        <#code#>
    }
    
    func deleteItem(item: AnyObject) {
        <#code#>
    }
    
    func getItem() -> AnyObject {
        <#code#>
    }
    
    
}


/**
 * 实现`OriginProtocol`协议
 */
extension OriginMonitor: OriginProtocol
{
    func desString() -> String
    {
        let typeStr = type(of: self)
        return typeStr.description()
    }
    
}
