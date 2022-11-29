//
//  CommandManager.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/5/23.
//

/**
 指令管理器
 负责指令和参数的解析
 指令和实际功能函数的对接
 */
import UIKit

class CommandManager: OriginManager
{
    //MARK: 属性
    //单例
    static let shared = CommandManager()
    
    
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
