//
//  CalendarAdapter.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/2/20.
//

/**
 * 系统日历适配器
 * 主要对接系统日历相关功能
 */
import UIKit

class CalendarAdapter: OriginAdapter
{
    //单例
    static let shared = CalendarAdapter()
    
    //私有化初始化方法
    private override init()
    {
        
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
extension CalendarAdapter: ExternalInterface
{
    
}
