//
//  DocumentMonitor.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2021/12/28.
//

/**
 * 文档监控器
 */
import UIKit

class DocumentMonitor: OriginMonitor
{
    //单例
    static let shared = DocumentMonitor()
    
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
