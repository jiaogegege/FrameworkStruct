//
//  MenuInteractionManager.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/4/7.
//

/**
 * 对于`UIContextMenuInteraction`功能的封装
 * 还没想好怎么弄，参考：https://blog.csdn.net/guoyongming925/article/details/110839969
 */
import UIKit

class MenuInteractionManager: OriginManager
{
    //MARK: 属性
    //单例
    static let shared = MenuInteractionManager()
    
    
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
