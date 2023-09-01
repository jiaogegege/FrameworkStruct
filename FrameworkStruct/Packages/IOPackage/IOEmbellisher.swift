//
//  IOEmbellisher.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/5/23.
//

/**
 输入输出格式化器
 负责对控制台输入和输出的内容进行格式化,主要是输出
 */
import UIKit

class IOEmbellisher: OriginEmbellisher, SingletonProtocol
{
    typealias Singleton = IOEmbellisher
    
    //MARK: 属性
    //单例
    static let shared = IOEmbellisher()
    
    
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
