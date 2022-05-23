//
//  IOManager.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/5/23.
//

/**
 输入输出管理器
 负责从控制台接收输入指令,并将执行结果输出到控制台
 */
import UIKit

class IOManager: OriginManager
{
    //MARK: 属性
    //单例
    static let shared = IOManager()
    
    //校验工具
    fileprivate lazy var ioc = IOChecker.shared
    
    //格式化工具
    fileprivate lazy var ioe = IOEmbellisher.shared
    
    //指令管理器
    fileprivate lazy var cm = CommandManager.shared
    
    
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
