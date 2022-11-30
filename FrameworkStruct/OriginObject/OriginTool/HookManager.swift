//
//  HookManager.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/11/29.
//

/**
 用来代替散落在各处的生命周期方法，也可用于各种触发事件
 封装一个闭包，并提供一些描述信息
 主要好处是可以统一注册和管理生命周期方法中执行的动作
 */
import UIKit

class HookManager: NSObject {
    //MARK: 属性
    //保存hook的容器，key是事件，值是一个字典，字典的key是特定hook的标识，值是具体的hook动作和描述信息，字典的key方便查找和修改；如果用户不设置，则自动从0开始计数
    fileprivate lazy var hookContainer: [HookEventType: [AnyHashable: HookDataStruct]] = [:]
    
    //MARK: 方法
    ///在某个event下添加一个hook，多次添加则会存在多个hook
    //参数：event：要添加hook的事件；key：用于标记指定hook；meta：绑定的hook的元信息；action：要执行的hook
    func add(_ event: HookEventType, key: String? = nil, meta: HookMetaInfo = HookMetaInfo(), action: @escaping VoidClosure)
    {
        var hooks = hookContainer[event]
        if hooks == nil
        {
            hooks = [:]
        }
        //创建hook数据
        let hook = HookDataStruct(key: (key != nil ? key! : "\(hooks!.count)"), action: action, meta: meta)
        hooks![(key != nil ? key! : "\(hooks!.count)")] = hook
        hookContainer[event] = hooks
    }
    
    ///删除某个hook
    ///参数：event：指定的事件；key：指定的hook的key，若不指定则删除event下所有hook
    func delete(_ event: HookEventType, key: String?)
    {
        if var hooks = hookContainer[event] {
            if let key = key {
                hooks.removeValue(forKey: key)
            }
            else {
                hooks.removeAll()
            }
            //重新设置到容器中
            hookContainer[event] = hooks
        }
    }
    
    ///执行某个event下的hooks，如果不指定key则根据规则执行所有
    func perform(_ event: HookEventType, key: String? = nil)
    {
        if let hooks = hookContainer[event] {
            if let key = key {  //指定key
                if var hook = hooks[key], hook.key == key {
                    hook.performAction {[weak self] meta in
                        //执行完成后做一些工作
                        if meta.onlyOnce {
                            self?.delete(event, key: key)
                        }
                    }
                }
            }
            else    //执行所有hook
            {
                for key in hooks.keys {
                    if var hook = hooks[key], hook.key == key as? String {
                        hook.performAction {[weak self] meta in
                            //执行完成后做一些工作
                            if meta.onlyOnce, let k = key as? String {
                                self?.delete(event, key: k)
                            }
                        }
                    }
                }
            }
        }
    }
    
    ///查询某个event下的key指定的hook信息
    func getMeta(_ event: HookEventType, key: String) -> HookMetaInfo?
    {
        if let hooks = hookContainer[event] {
            return hooks[key]?.meta
        }
        
        return nil
    }
    
    ///修改某个event下的key指定的hook信息
    func updateMeta(_ event: HookEventType, key: String, meta: HookMetaInfo)
    {
        if var hooks = hookContainer[event] {
            if var hook = hooks[key] {
                if hook.key == key {
                    hook.meta = meta
                    hooks[key] = hook
                    hookContainer[event] = hooks
                }
            }
        }
    }
    
    ///修改某个event下的key指定的hook是否可以执行
    func setCanPerform(_ event: HookEventType, key: String, canPerform: Bool)
    {
        if var meta = getMeta(event, key: key) {    //已经有了才可以修改
            meta.canPerform = canPerform
            updateMeta(event, key: key, meta: meta)
        }
    }
    
}


//内部类型
extension HookManager: InternalType
{
    //key类型定义，所有使用该组件的对象的hook的key都是用此定义
    typealias HookEventType = String
    
    //hook结构体
    struct HookDataStruct {
        var key: String             //用于标记一个action的key，方便查找和修改；如果用户不设置，则自动从0开始计数
        var action: VoidClosure     //要执行的动作
        var meta: HookMetaInfo      //hook描述信息
        
        //执行hook
        mutating func performAction(_ completion: ((HookMetaInfo) -> Void)?)
        {
            if meta.canPerform
            {
                action()
            }
            //不管是否执行了action都要重置
            meta.reset()
            if let cb = completion {
                cb(meta)
            }
        }
    }
    
    //hook描述信息
    struct HookMetaInfo {
        private var _canPerform: Bool = true    //记录`canPerform`的初始化值，在生命周期内保持不变
        var canPerform: Bool = true //是否可以执行绑定的动作，可以在任何时候动态修改，以控制何时执行，何时不执行；如果为false，则不执行绑定的hook
        
        var onlyOnce: Bool = false          //是否只执行一次绑定的hook，如果为true，那么执行一次hook后就删除该hook
        
        var shouldReset: Bool = false       //当执行一次hook后，是否将所有设置值重置为初始化值；该设置对`canPerform`有效
        
        //初始化方法，代替默认初始化器
        init() {
            
        }
        
        init(canPerform: Bool, onlyOnce: Bool, shouldReset: Bool) {
            self.canPerform = canPerform
            self._canPerform = canPerform
            self.onlyOnce = onlyOnce
            self.shouldReset = shouldReset
        }
        
        //重置为初始化值
        mutating func reset()
        {
            if shouldReset
            {
                canPerform = _canPerform
            }
        }
    }
    
}


//外部接口
extension HookManager: ExternalInterface
{
    
}
