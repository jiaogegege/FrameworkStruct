//
//  CommandAdapter.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/5/23.
//

/**
 指令适配器
 负责指令和实际功能函数的对接
 */
import UIKit

class CommandAdapter: OriginAdapter
{
    //MARK: 属性
    //单例
    static let shared = CommandAdapter()
    
    
    //MARK: 方法
    //私有化初始化方法
    private override init()
    {
        super.init()
    }
    
    override func copy() -> Any
    {
        return self
    }
    
    override func mutableCopy() -> Any
    {
        return self
    }

}
