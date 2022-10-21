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
    func allItems() -> [NSObject]
    
    //某个元素是否存在监控器中
    func isItemExist(_ item: NSObject) -> Bool
    
    //添加一个元素
    func addItem(_ item: NSObject)
    
    //删除一个元素
    func deleteItem(_ item: NSObject)
    
    //获取一个元素
    //暂时不知道这个方法的作用，留作扩展
    func getItem() -> NSObject?
    
    //查看所有元素信息，返回元素类型信息的数组
    func getAllItemsInfo() -> [String]
    
    //初始配置
    func originConfig()
}


/**
 * 所有监控器的父类，如果有通用的功能，可以在此处实现
 * 所有子类命名都应该以`Monitor`结尾
 */
class OriginMonitor: NSObject
{
    //容器
    fileprivate var container: FSVector = FSVector<NSObject>()
    
    //状态管理器，建议有复杂变化的状态都通过状态管理器管理
    fileprivate(set) lazy var stMgr: StatusManager = StatusManager(capacity: originStatusStep)

}


//MARK: 实现协议
/**
 * 实现`MonitorProtocol`协议
 */
extension OriginMonitor: MonitorProtocol
{
    var itemCount: Int {
        return self.container.count()
    }
    
    func allItems() -> [NSObject] {
        return self.container.allItems()
    }
    
    func isItemExist(_ item: NSObject) -> Bool {
        let index = self.container.indexOf(item)
        if index >= 0
        {
            return true
        }
        return false
    }
    
    func addItem(_ item: NSObject) {
        self.container.pushBack(item)
    }
    
    func deleteItem(_ item: NSObject) {
        _ = self.container.pop(item: item)
    }
    
    func getItem() -> NSObject? {
        return nil
    }
    
    func getAllItemsInfo() -> [String] {
        var infos = [String]()
        let arr = container.allItems()
        for item in arr
        {
            infos.append(item.description)
        }
        return infos
    }
    
    @objc func originConfig() {
        //子类实现具体功能
    }
    
}


/**
 * 实现`OriginProtocol`协议
 */
extension OriginMonitor: OriginProtocol
{
    func typeDesc() -> String
    {
        let typeStr = type(of: self)
        return typeStr.description()
    }
    
}
