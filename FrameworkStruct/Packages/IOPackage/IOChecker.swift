//
//  IOChecker.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/5/23.
//

/**
 输入输出校验器
 对输入输出的内容进行校验,主要是输入
 */
import UIKit

class IOChecker: OriginChecker
{
    //MARK: 属性
    //单例
    static let shared = IOChecker()
    
    
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
