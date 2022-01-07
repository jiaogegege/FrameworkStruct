//
//  ControllerManager.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/12/16.
//

/**
 * 控制器管理器
 * 管理程序中所有的控制器，理论上，可以从这里获取到程序中所有的界面
 * 主要提供对控制器的访问，一般是只读属性
 * 这里对所有控制器都是弱引用，不能影响控制器的正常创建和释放
 */
import UIKit

class ControllerManager: OriginManager
{
    //MARK: 属性
    //单例对象
    static let shared = ControllerManager()
    
    //这里记录所有存在的控制器，当控制器被创建时，这里会有弱引用，当控制器被释放时，这里也随之消失
    fileprivate let allControllers: WeakArray = WeakArray.init()
    
    
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

//外部接口
extension ControllerManager: ExternalInterface
{
    
}
