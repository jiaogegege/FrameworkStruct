//
//  UrlSchemeAdapter.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/4/1.
//

/**
 * 管理从其它app跳转到本app的逻辑处理
 * 通过在`info`中设置的`Url Schemes`进行跳转和功能开发，同时要考虑剪贴板
 * 具体的url规则根据实际需求定义
 */
import UIKit

class UrlSchemeAdapter: OriginAdapter
{
    //MARK: 属性
    //单例
    static let shared = UrlSchemeAdapter()
    
    
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
extension UrlSchemeAdapter: ExternalInterface
{
    ///从AppDelegate中统一调用url输入方法，在UrlSchemeAdapter中做具体处理
    func dispatchUrl(_ url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
    {
        //创建一个url结构体
        let urlStruct: UrlSchemeStructure = UrlSchemeStructure(url: url)
        //直接执行结构体预定义的功能，当然，也可以动态执行自定义功能
        urlStruct.performFunc()
    }
    
}
