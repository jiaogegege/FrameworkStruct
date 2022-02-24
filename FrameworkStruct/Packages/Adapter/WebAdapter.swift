//
//  WebAdapter.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/2/23.
//

/**
 * Web适配器，主要和web页面对接和交互
 */
import UIKit

class WebAdapter: OriginAdapter
{
    //MARK: 属性
    //单例
    static let shared = WebAdapter()
    
    
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
