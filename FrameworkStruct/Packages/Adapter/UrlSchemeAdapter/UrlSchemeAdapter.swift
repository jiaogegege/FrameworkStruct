//
//  UrlSchemeAdapter.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/4/1.
//

/**
 * 管理从其它app跳转到本app的逻辑处理
 * 通过在`info`中设置的`Url Schemes`进行跳转和功能开发，同时要考虑剪贴板
 * 具体的url规则根据实际需求定义
 */
import UIKit

class UrlSchemeAdapter: OriginAdapter, SingletonProtocol
{
    typealias Singleton = UrlSchemeAdapter
    
    //MARK: 属性
    //单例
    static let shared = UrlSchemeAdapter()
    
    //打开app时携带的信息
    fileprivate var openInfo: OpenUrlInfo?
    
    
    //MARK: 方法
    //私有化初始化方法
    private override init()
    {
        super.init()
        
        self.addNotification()
    }
    
    override func copy() -> Any
    {
        return self
    }
    
    override func mutableCopy() -> Any
    {
        return self
    }
    
    fileprivate func addNotification()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActiveNotification(notification:)), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
}


//协议通知
extension UrlSchemeAdapter: DelegateProtocol
{
    //app已经获得焦点
    @objc func applicationDidBecomeActiveNotification(notification: Notification)
    {
        //处理url，如果有的话
        if let info = self.openInfo
        {
            //创建一个url结构体
            let urlStruct: UrlSchemeStructure = UrlSchemeStructure(info.url)
            //options根据实际需求处理，此处不做示例
            //直接执行结构体预定义的功能，当然，也可以动态执行自定义功能
            urlStruct.performFunc()
            
            //处理完后清空
            self.openInfo = nil
        }
    }
    
}


//内部类型
extension UrlSchemeAdapter: InternalType
{
    //打开app的信息结构体，包括url/options
    struct OpenUrlInfo {
        //打开此app时传递的url
        var url: URL
        //通过appdelegate打开时携带的信息
        var appOptions: [UIApplication.OpenURLOptionsKey : Any]?
        //通过scenedelegate打开时携带的信息
        var sceneOptions: UIScene.OpenURLOptions?
    }
    
}


//接口方法
extension UrlSchemeAdapter: ExternalInterface
{
    ///判断url是否是通过url scheme打开的
    func isUrlScheme(_ url: URL) -> Bool
    {
        UrlSchemeProtocol.isLegalUrl(url)
    }
    
    ///从AppDelegate中统一调用url输入方法，在UrlSchemeAdapter中做具体处理
    ///对于options，根据实际需求另做处理
    func dispatchUrl(_ url: URL, appOptions: [UIApplication.OpenURLOptionsKey : Any]? = nil, sceneOptions: UIScene.OpenURLOptions? = nil)
    {
        self.openInfo = OpenUrlInfo(url: url, appOptions: appOptions, sceneOptions: sceneOptions)
    }
    
}
