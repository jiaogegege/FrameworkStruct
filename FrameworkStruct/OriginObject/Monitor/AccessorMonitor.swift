//
//  AccessorMonitor.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/12/16.
//

/**
 * 数据存储器监控器
 */
import UIKit

class AccessorMonitor: OriginMonitor
{
    //单例
    static let shared = AccessorMonitor()
    
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
extension AccessorMonitor: ExternalInterface
{
    ///添加需要初始化的组件
    override func originConfig() {
        super.originConfig()
        //初始化数据库
        _ = DatabaseAccessor.shared
    }
    
}
