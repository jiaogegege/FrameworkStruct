//
//  NetworkAdapter.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/2/9.
//

/**
 * 网络适配器
 * 所有和网络请求相关的功能都在这里
 */
import UIKit

class NetworkAdapter: OriginAdapter
{
    //MARK: 属性
    //单例
    static let shared = NetworkAdapter()
    
    
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
extension NetworkAdapter: ExternalInterface
{
    
}
