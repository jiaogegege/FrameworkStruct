//
//  ControllerManager.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/12/16.
//

/**
 * 控制器管理器
 * 管理程序中所有的控制器，理论上，可以从这里获取到程序中所有的界面
 */
import UIKit

class ControllerManager: OriginManager
{
    //MARK: 属性
    //单例对象
    static let shared = ControllerManager()
    
    
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
