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
 * 数据容器服务
 */
protocol ContainerServices {
    //数据容器更新了某个数据，通知所有关联对象更新该数据
    func containerDidUpdateData(key: AnyHashable, value: Any)
    
}

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
    
    //刷新某个数据，，先清空缓存，再从数据源中重新读取，如果有的话，并通知所有相关对象刷新数据
    func refresh(key: AnyHashable)
    
    //刷新所有数据，从数据源中重新读取，如果有的话，并通知所有相关对象刷新数据
    func refreshAll()
    
    //清空某个数据，从容器中删除
    func clear(key: AnyHashable)
    
    //清空所有数据，清空容器
    func clearAll()
    
    //订阅某数据模型，一般是上层业务逻辑订阅数据容器中的数据，如果该数据更新了，那么通知上层业务逻辑
    //参数：key：订阅的数据key；delegate：订阅该数据的对象，必须是class
    func subscribe<T: AnyObject & ContainerServices>(key: AnyHashable, delegate: T)
    
}


/**
 * 所有数据容器的父类，如果有通用的功能，可以在此处实现
 * 所有子类命名都应该以`Container`结尾
 */
class OriginContainer: NSObject
{
    //MARK: 属性
    
    //数据容器；key是数据对象的key，value是具体的数据模型
    fileprivate var container: Dictionary<AnyHashable, Any> = Dictionary()
    
    //代理对象们，如果有的话；key是数据对象的key，value是弱引用数组，数组中保存订阅对象
    fileprivate var delegates: Dictionary<AnyHashable, NSPointerArray> = Dictionary()
    
    
    
}


//MARK: 实现协议
/**
 * 实现`ContainerProtocol`协议
 */
extension OriginContainer: ContainerProtocol
{
    func get(key: AnyHashable) -> Any? {
        let data = self.container[key]
        return self.getCopy(origin: data)
    }
    
    func mutate(key: AnyHashable, value: Any) {
        self.container[key] = self.getCopy(origin: value)
        //提交数据的时候，要对所有数据源发出通知
        self.dispatchChange(key: key, value: self.get(key: key) as Any)
    }
    
    @objc func commit(key: AnyHashable, value: Any) {
        //子类实现和具体存取器的交互
    }
    
    @objc func commitAll() {
        //子类实现和具体存取器的交互
    }
    
    @objc func refresh(key: AnyHashable) {
        //子类实现和具体存取器的交互
    }
    
    @objc func refreshAll() {
        //子类实现和具体存取器的交互
    }
    
    func clear(key: AnyHashable) {
        self.container.removeValue(forKey: key)
    }
    
    func clearAll() {
        self.container.removeAll()
    }
    
    //返回一个拷贝的数据对象，如果是NSObject，那么返回copy对象，其他返回原始值（结构体、枚举等）
    func getCopy(origin: Any?) -> Any
    {
        if let nsData = origin as? NSObject
        {
            return nsData.copy()
        }
        else if let array = origin as? Array<Any>
        {
            return array.copy()
        }
        else if let dic = origin as? Dictionary<AnyHashable, Any>
        {
            return dic.copy()
        }
        else
        {
            return origin as Any
        }
    }
    
    //订阅数据
    func subscribe<T>(key: AnyHashable, delegate: T) where T : AnyObject, T : ContainerServices
    {
        if let weakArr = self.delegates[key]
        {
            weakArr.addObject(delegate)
        }
        else
        {
            let weakArray = NSPointerArray.weakObjects()
            weakArray.addObject(delegate)
            self.delegates[key] = weakArray
        }
    }
    
    //当数据变化的时候，通知所有订阅对象
    func dispatchChange(key: AnyHashable, value: Any)
    {
        let array = self.delegates[key]
        array?.addPointer(nil)
        array?.compact()
        let count = array?.count ?? 0
        if count > 0
        {
            for i in 0..<count
            {
                let delegate = array?.object(at: i)
                if let delegateOp = delegate as? ContainerServices
                {
                    delegateOp.containerDidUpdateData(key: key, value: value)
                }
            }
        }
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
