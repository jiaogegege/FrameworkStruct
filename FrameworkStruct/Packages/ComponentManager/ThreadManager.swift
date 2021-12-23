//
//  ThreadManager.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2021/12/19.
//

/**
 * 多线程管理器
 * 主要管理多线程的创建、执行、同步等
 */
import UIKit

class ThreadManager: OriginManager
{
    //MARK: 属性
    //单例对象
    static let shared = ThreadManager()
    
    
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
