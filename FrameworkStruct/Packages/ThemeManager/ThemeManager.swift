//
//  ThemeManager.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/12/9.
//

/**
 * 主题管理器
 */
import UIKit

class ThemeManager: OriginManager
{
    //MARK: 属性
    //单例对象
    static let shared = ThemeManager()
    
    
    //MARK: 方法
    //私有化init方法
    private override init()
    {
        super.init()
        
    }
    
    //重写复制方法
    override func copy() -> Any
    {
        return self // ThemeManager.shared
    }
        
    //重写复制方法
    override func mutableCopy() -> Any
    {
        return self // ThemeManager.shared
    }
    
    
}

/**
 * 对外接口
 */
extension ThemeManager
{
    
}
