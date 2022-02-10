//
//  NetworkAdapter.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/2/10.
//

/**
 网络适配器
 此处定义所有的网络接口方法
 */
import UIKit

class NetworkAdapter: OriginAdapter
{
    //MARK: 属性
    //单例
    static let shared = NetworkAdapter()
    
    //请求对象
    fileprivate let request = NetworkRequest.shared
    
    
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

//外部接口
extension NetworkAdapter: ExternalInterface
{
    
}
