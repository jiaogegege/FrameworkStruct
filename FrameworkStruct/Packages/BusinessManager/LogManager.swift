//
//  LogManager.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/4/23.
//

/**
 * 日志管理器
 * 根据具体需求开发功能
 */
import UIKit

class LogManager: OriginManager
{
    //MARK: 属性
    //单例
    static let shared = LogManager()
    
    
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


//接口方法
extension LogManager: ExternalInterface
{
    
}
