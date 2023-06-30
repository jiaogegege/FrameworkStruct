//
//  OriginContainer.swift
//  FrameworkStruct
//
//  Created by  jggg on 2021/11/5.
//

/**
 * 最初的数据容器
 */
import Foundation

/**
 * 数据容器服务
 */
protocol ContainerServices {
    //数据容器更新了某个数据，通知所有订阅对象更新该数据
    func containerDidUpdateData(key: AnyHashable, value: Any)
    
    //数据容器清空了某个数据,通知所有订阅对象数据被清空,订阅对象可根据实际需求作出反应
    func containerDidClearData(key: AnyHashable)
    
}

/**
 * 数据容器安全访问协议
 * 要访问数据容器的对象都要实现该协议
 * 主要针对修改操作进行安全性验证，防止任意对象修改数据容器中的内容
 */
protocol ContainerSecurityProtocol: NSObjectProtocol {
    //返回一个container生成的token，实现该协议的对象必须保存这个token，之后对数据容器的访问需要验证token
    func containerGeneratedToken(token: String)
    //想要访问数据容器的对象需要返回获取的token来通过验证
    func containerVerifyToken() -> String
}

/**
 * 数据容器定义的通用接口，如果有通用的功能需要子类实现，那么定义在此处
 * 可以作为类型使用
 */
protocol ContainerProtocol: NSObjectProtocol
{
    //同步获取数据，优先从容器中获取，如果没有则从数据源获取
    func get(key: AnyHashable) -> Any?
    
    //异步获取数据，优先从容器中获取，如果没有则从数据源获取
    func get(key: AnyHashable, completion: @escaping OpAnyClo)
    
    //获取所有已保存的key
    func getAllKeys() -> [AnyHashable]
        
    //同步修改数据，数据保存在容器中修改后通知所有订阅对象刷新数据
    func mutate(key: AnyHashable, value: Any, meta: DataModelMeta)
    
    //判断该key指定的value是否可以commit
    func canCommit(key: AnyHashable) -> Bool
    
    //同步提交数据，将数据写入本地数据源
    func commit(key: AnyHashable, value: Any)
    
    //异步提交数据，将数据写入本地数据源或远程数据源
    //参数：success：可能返回接口数据或者什么都不返回，failure：可能返回接口错误或自定义错误
    func commit(key: AnyHashable, value: Any, success: @escaping OpAnyClo, failure: @escaping NSErrClo)
    
    //同步提交所有数据，将所有数据写入本地数据源
    func commitAll()
    
    //异步提交所有数据，将所有数据写入本地数据源或远程数据源
    //异步提交所有数据涉及到多个异步操作的同步通信，并且不一定所有数据都支持异步提交服务，慎重使用这个方法
    //参数：success：可能返回接口数据或者什么都不返回，failure：可能返回接口错误或自定义错误
    func commitAll(success: @escaping OpAnyClo, failure: @escaping NSErrClo)
    
    //同步刷新某个数据，先清空缓存，再从数据源中重新读取，如果有的话，并通知所有相关对象刷新数据；同时返回这个数据
    func refresh(key: AnyHashable) -> Any?
    
    //异步刷新某个数据，先清空缓存，再从数据源中重新读取，如果有的话，并通知所有相关对象刷新数据，同时返回这个数据
    func refresh(key: AnyHashable, completion: @escaping OpAnyClo)
    
    //同步刷新所有数据，从数据源中重新读取，如果有的话，并通知所有相关对象刷新数据，同时返回所有刷新的数据，key就是数据的key
    func refreshAll() -> Dictionary<AnyHashable, Any>?
    
    //异步刷新所有数据，从数据源中重新读取，如果有的话，并通知所有相关对象刷新数据
    //异步刷新所有数据涉及到多个异步操作的同步通信，并且不一定所有数据都支持异步刷新服务，慎重使用这个方法
    //参数：datas：所有获取到的数据对象
    func refreshAll(completion: @escaping ((_ datas: Dictionary<AnyHashable, Any>?) -> Void))
    
    //清空某个数据，从容器中删除
    func clear(key: AnyHashable)
    
    //清空所有数据，清空容器
    func clearAll()
    
    //订阅某数据模型，一般是上层业务逻辑订阅数据容器中的数据，如果该数据更新了，那么通知上层业务逻辑
    //参数：key：订阅的数据key；delegate：订阅该数据的对象，必须是class
    func subscribe<T: AnyObject & ContainerServices>(key: AnyHashable, delegate: T)
    
    //当数据变化的时候，通知所有订阅对象
    func dispatch(key: AnyHashable, value: Any)
    
}


/**
 * 所有数据容器的父类，如果有通用的功能，可以在此处实现
 * 所有子类命名都应该以`Container`结尾
 */
class OriginContainer: NSObject
{
    //MARK: 属性
    //状态管理器，建议有复杂变化的状态都通过状态管理器管理
    fileprivate(set) lazy var stMgr: StatusManager = StatusManager(capacity: originStatusStep)
    
    //监控器，每一个数据容器在创建的时候都要加入到监控器中
    fileprivate(set) weak var monitor: ContainerMonitor!
    
    //数据容器；key是数据对象的key，value是具体的数据模型
    fileprivate var container: Dictionary<AnyHashable, ContainerDataStruct> = Dictionary()
    
    //数据容器锁，在所有对container进行访问的地方都进行加锁
    fileprivate(set) lazy var containerLock: NSRecursiveLock = NSRecursiveLock()
    
    //注册安全性访问的对象
//    fileprivate lazy var accessSecurityDict: NSMapTable<NSString, AnyObject> = NSMapTable.strongToWeakObjects()
    
    //代理对象们，如果有的话；key是数据对象的key，value是弱引用数组，数组中保存订阅对象
    fileprivate var delegates: Dictionary<AnyHashable, NSPointerArray> = Dictionary()
    
    
    //MARK: 方法
    override init()
    {
        self.monitor = ContainerMonitor.shared
        super.init()
        monitor.addItem(self)
    }
    
    //返回一个拷贝的数据对象，如果是NSObject，那么返回copy对象；如果是Array/Dictionary，需要复制容器中的所有对象，返回新的容器和对象；其他返回原始值（基础类型、结构体、枚举等）
    fileprivate func getCopy(_ origin: Any?) -> Any?
    {
        if origin != nil
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
        else
        {
            return origin
        }
    }
    
    //暂不实现
    //注册访问验证token
    func registerAccessToken(_ obj: AnyObject & ContainerSecurityProtocol)
    {
//        let token = g_uuid()
//        accessSecurityDict.setObject(obj, forKey: (token as NSString))
//        obj.containerGeneratedToken(token: token)
    }
    
    //暂不实现
    //判断是否可以访问container
    func canAccess() -> Bool
    {
        //0:本方法；1:调用本方法的方法；2:调用本方法的方法的方法
//        let callStackStr = Thread.callStackSymbols
        //遍历安全性访问对象字典，找到调用类型信息，往上找5层
        
        return true
    }
    
}


//MARK: 实现协议
/**
 * 实现`ContainerProtocol`协议
 */
extension OriginContainer: ContainerProtocol
{
    //不建议覆写这个方法
    @objc func get(key: AnyHashable) -> Any? {
        containerLock.lock()
        guard let dataStruct = self.container[key] else {
            containerLock.unlock()
            return nil
        }
        containerLock.unlock()
        let data = dataStruct.data
        let meta = dataStruct.meta
        return meta.needCopy ? self.getCopy(data) : data
    }
    
    @objc func get(key: AnyHashable, completion: @escaping OpAnyClo) {
        //子类实现和具体存取器的交互
        //理论上优先从容器获取，如果没有则从具体的存取器获取
    }
    
    //获取所有已保存的key，不建议子类覆写该方法
    func getAllKeys() -> [AnyHashable] {
        container.allKeys
    }
    
    //不建议覆写这个方法
    @objc func mutate(key: AnyHashable, value: Any, meta: DataModelMeta = DataModelMeta()) {
        containerLock.lock()
        let dataStruct = ContainerDataStruct(data: (meta.needCopy ? self.getCopy(value) as Any : value), meta: meta)
        self.container[key] = dataStruct
        containerLock.unlock()
        //提交数据的时候，要对所有订阅对象发出通知
        self.dispatch(key: key, value: self.get(key: key) as Any)
    }
    
    //判断该key指定的value是否可以commit
    //不建议覆写这个方法
    func canCommit(key: AnyHashable) -> Bool
    {
        containerLock.lock()
        guard let dataStruct = self.container[key] else {
            containerLock.unlock()
            return false
        }
        containerLock.unlock()
        let meta = dataStruct.meta
        return meta.canCommit
    }
    
    @objc func commit(key: AnyHashable, value: Any) {
        //子类实现和具体存取器的交互
    }
    
    @objc func commit(key: AnyHashable, value: Any, success: @escaping OpAnyClo, failure: @escaping NSErrClo) {
        //子类实现和具体存取器的交互
    }
    
    @objc func commitAll() {
        //子类实现和具体存取器的交互
    }
    
    func commitAll(success: @escaping OpAnyClo, failure: @escaping NSErrClo) {
        //子类实现和具体存取器的交互
    }
    
    @objc func refresh(key: AnyHashable) -> Any? {
        //子类实现和具体存取器的交互
        return nil
    }
    
    @objc func refresh(key: AnyHashable, completion: @escaping OpAnyClo) {
        //子类实现和具体存取器的交互
    }
    
    @objc func refreshAll() -> Dictionary<AnyHashable, Any>? {
        //子类实现和具体存取器的交互
        return nil
    }
    
    @objc func refreshAll(completion: @escaping ((Dictionary<AnyHashable, Any>?) -> Void)) {
        //子类实现和具体存取器的交互
    }
    
    //不建议覆写这个方法
    @objc func clear(key: AnyHashable) {
        containerLock.lock()
        self.container.removeValue(forKey: key)
        containerLock.unlock()
        //清空数据的时候，要对所有订阅对象发出通知
        let array = self.delegates[key]
        array?.addPointer(nil)
        array?.compact()
        let count = array?.count ?? 0
        if count > 0
        {
            for i in 0..<count
            {
                if let delegate = array?.object(at: i) as? ContainerServices
                {
                    delegate.containerDidClearData(key: key)
                }
            }
        }
        else    //如果没有对象，那么删除这个key/value（节省内存空间）
        {
            self.delegates[key] = nil
        }
    }
    
    //不建议覆写这个方法
    @objc func clearAll() {
        //遍历key，依次清空对应的数据
        for key in self.container.keys
        {
            self.clear(key: key)
        }
    }
    
    //订阅数据
    func subscribe<T>(key: AnyHashable, delegate: T) where T : AnyObject, T : ContainerServices
    {
        if let weakArr = self.delegates[key]
        {
            weakArr.compact()
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
    func dispatch(key: AnyHashable, value: Any)
    {
        let array = self.delegates[key]
        array?.addPointer(nil)
        array?.compact()
        let count = array?.count ?? 0
        if count > 0
        {
            for i in 0..<count
            {
                if let delegate = array?.object(at: i) as? ContainerServices
                {
                    delegate.containerDidUpdateData(key: key, value: value)
                }
            }
        }
        else    //如果没有对象，那么删除这个key/value（节省内存空间）
        {
            self.delegates[key] = nil
        }
    }
    
}


/**
 * 内部类型
 */
extension OriginContainer
{
    //数据模型存储结构，包括数据域和元数据域
    struct ContainerDataStruct {
        var data: Any                           //数据域
        var meta: DataModelMeta                 //元数据域
    }
    
}


/**
 * 实现`OriginProtocol`协议
 */
extension OriginContainer: OriginProtocol
{
    func typeDesc() -> String
    {
        let typeStr = type(of: self)
        return typeStr.description()
    }
    
}
