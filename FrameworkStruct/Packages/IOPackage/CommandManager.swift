//
//  CommandManager.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/5/23.
//

/**
 指令管理器
 负责指令和参数的解析
 */
import UIKit

class CommandManager: OriginManager
{
    //MARK: 属性
    //单例
    static let shared = CommandManager()
    
    //指令适配器
    fileprivate lazy var ca = CommandAdapter.shared
    
    
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
