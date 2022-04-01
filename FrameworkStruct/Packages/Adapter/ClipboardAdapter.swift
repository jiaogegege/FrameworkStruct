//
//  ClipboardAdapter.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/4/1.
//

/**
 * 系统剪贴板适配器
 */
import UIKit

class ClipboardAdapter: OriginAdapter
{
    //MARK: 属性
    //单例
    static let shared = ClipboardAdapter()
    
    
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
