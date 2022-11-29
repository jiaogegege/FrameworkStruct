//
//  HookManager.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/11/29.
//

/**
 用来代替散落在各处的生命周期方法
 封装一个闭包，并提供一些描述信息
 主要好处是可以统一注册和管理生命周期方法中执行的动作
 */
import UIKit

class HookManager: NSObject {
    //MARK: 属性
    fileprivate lazy var dict: [HookKeyType: [HookDataStruct]] = [:]
    
    //MARK: 方法
    
}


//内部类型
extension HookManager: InternalType
{
    //key类型定义，所有使用该组件的对象的hook的key都是用此定义
    typealias HookKeyType = String
    
    //hook结构体
    struct HookDataStruct {
        var action: VoidClosure     //要执行的动作
        var meta: HookMetaInfo      //hook描述信息
    }
    
    //hook描述信息
    struct HookMetaInfo {
        var canPerform: Bool = true         //是否可以执行绑定的动作，可以在任何时候动态修改，以控制何时执行，何时不执行；如果为false，则不执行绑定的hook
        var onlyOnce: Bool = false          //是否只执行一次绑定的hook，如果为true，那么执行一次hook后就删除该hook
        var resetOrigin: Bool = false       //当执行一次hook后，是否将所有设置值重置为初始化值；该设置对`canPerform`有效
    }
    
}


//外部接口
extension HookManager: ExternalInterface
{
    //在某个key下添加一个hook，多次添加则会有存在多个hook
    func add(_ key: HookKeyType, meta: HookMetaInfo = HookMetaInfo(), action: @escaping VoidClosure)
    {
        
    }
    
}
