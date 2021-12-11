//
//  OriginContainer.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/11/5.
//

/**
 * 最初的数据容器
 */
import Foundation


/**
 * 数据容器定义的通用接口，如果有通用的功能需要子类实现，那么定义在此处
 * 可以作为类型使用
 */
protocol ContainerProtocol
{
    //获取数据
    func get(key: AnyHashable) -> Any?
        
    //修改数据，数据保存在容器中
    func mutate(key: AnyHashable, value: Any)
    
    //提交数据，将数据写入本地数据源
    func commit(key: AnyHashable, value: Any)
    
    //提交所有数据，将所有数据写入本地数据源
    func commitAll()
    
    //刷新某个数据，从数据源中重新读取，如果有的话，并通知所有相关对象刷新数据
    func refresh(key: AnyHashable)
    
    //刷新所有数据，从数据源中重新读取，如果有的话，并通知所有相关对象刷新数据
    func refreshAll()
    
    //清空某个数据，从容器中删除
    func clear(key: AnyHashable)
    
    //清空所有数据，清空容器
    func clearAll()
    
}


/**
 * 所有数据容器的父类，如果有通用的功能，可以在此处实现
 * 所有子类命名都应该以`Container`结尾
 */
class OriginContainer: NSObject
{
    //MARK: 属性
    //容器
    fileprivate var container: Dictionary<AnyHashable, Any> = Dictionary()
    
    
    
    
}


//MARK: 实现协议
/**
 * 实现`ContainerProtocol`协议
 */
extension OriginContainer: ContainerProtocol
{
    func get(key: AnyHashable) -> Any? {
        return self.container[key]
    }
    
    func mutate(key: AnyHashable, value: Any) {
        self.container[key] = value
    }
    
    func commit(key: AnyHashable, value: Any) {
        //子类实现和具体存取器的交互
    }
    
    func commitAll() {
        //子类实现和具体存取器的交互
    }
    
    func refresh(key: AnyHashable) {
        //子类实现和具体存取器的交互
    }
    
    func refreshAll() {
        //子类实现和具体存取器的交互
    }
    
    func clear(key: AnyHashable) {
        self.container.removeValue(forKey: key)
    }
    
    func clearAll() {
        self.container.removeAll()
    }
    
    
}


/**
 * 实现`OriginProtocol`协议
 */
extension OriginContainer: OriginProtocol
{
    func desString() -> String
    {
        let typeStr = type(of: self)
        return typeStr.description()
    }
    
}
