//
//  SafariServiceManager.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/7/28.
//

/**
 提供safari浏览器服务，包括在app中内置safari应用，和系统safari共享cookie等数据
 */

import UIKit
import SafariServices

/**
 服务代理方法
 */
protocol SafariServiceManagerServices: NSObjectProtocol {
    //打开初始url成功或失败
    func safariServiceManagerDidOpenUrl(_ urlStr: String, isSuccess: Bool)
    
    //重定向初始url到某个url
    func safariServiceManagerDidRedirectTo(originUrl: String, newUrl: String)
    
    //即将跳转到系统浏览器打开url
    func safariServiceManagerWillOpenInSystemBrowser(_ urlStr: String)
    
    //关闭safari界面时调用
    func safariServiceManagerDidClose(_ urlStr: String)
    
}

class SafariServiceManager: OriginManager
{
    //MARK: 属性
    //单例
    static let shared = SafariServiceManager()
    
    //容器，绑定初始url和safari界面
    fileprivate lazy var urlDict: Dictionary<String, SFSafariViewController> = [:]
    
    //服务代理对象
    weak var delegate: SafariServiceManagerServices?
    
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

    ///创建一个内置safari浏览器
    fileprivate func createInternalSafari(url: URL,
                                          config: SFSafariViewController.Configuration,
                                          preferredBarTintColor: UIColor?,
                                          preferredControlTintColor: UIColor?,
                                          dismissButtonStyle: SFSafariViewController.DismissButtonStyle) -> SFSafariViewController
    {
        let vc = SFSafariViewController(url: url, configuration: config)
        vc.preferredBarTintColor = preferredBarTintColor
        vc.preferredControlTintColor = preferredControlTintColor
        vc.dismissButtonStyle = dismissButtonStyle
        vc.delegate = self
        self.urlDict[url.absoluteString] = vc
        return vc
    }
    
    //根据vc获得初始url
    fileprivate func getUrl(_ vc: SFSafariViewController) -> String?
    {
        for (key, value) in self.urlDict
        {
            if value.isEqual(vc)
            {
                return key
            }
        }
        //如果没有找到，那么返回nil
        return nil
    }
    
}


///代理方法
extension SafariServiceManager: DelegateProtocol, SFSafariViewControllerDelegate
{
    //传入的url第一次加载完毕后调用，不管成功还是失败
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        if let url = getUrl(controller) //如果保存了对应的url，那么执行服务协议
        {
            self.delegate?.safariServiceManagerDidOpenUrl(url, isSuccess: didLoadSuccessfully)
        }
    }

    //当加载第一个url被重定向到另一个url时调用
    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
        if let originUrl = getUrl(controller)
        {
            self.delegate?.safariServiceManagerDidRedirectTo(originUrl: originUrl, newUrl: URL.absoluteString)
        }
    }
    
    //当点击底部工具栏上的`分享`按钮时显示自定义UIActivity列表，根据实际需求设计
    func safariViewController(_ controller: SFSafariViewController, activityItemsFor URL: URL, title: String?) -> [UIActivity] {
        return []
    }
    
    //针对某些url排除显示某些UIActivity按钮
    func safariViewController(_ controller: SFSafariViewController, excludedActivityTypesFor URL: URL, title: String?) -> [UIActivity.ActivityType] {
        []
    }
    
    //用户在内置safari界面中点击了`在系统浏览器中打开`，即将跳转到系统默认浏览器
    func safariViewControllerWillOpenInBrowser(_ controller: SFSafariViewController) {
        if let url = getUrl(controller)
        {
            self.delegate?.safariServiceManagerWillOpenInSystemBrowser(url)
        }
    }
    
    //点击完成按钮，safari界面退出，可以清理一些资源并通知上一个界面代理对象
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        //关闭界面时清理资源
        if let url = getUrl(controller)
        {
            self.urlDict[url] = nil
            self.delegate?.safariServiceManagerDidClose(url)
        }
    }
    
}


///内部类型
extension SafariServiceManager: InternalType
{
    //错误类型
    enum SSMError: Error {
        case unsupportUrl   //不支持的url
    }
    
}


///外部接口
extension SafariServiceManager: ExternalInterface
{
    /**
     - 功能： 使用内置safari打开一个web页面
     - 参数：
     urlStr：url地址；
     entersReaderIfAvailable：如果阅读器可用是否进入阅读器视图；
     barCollapsingEnabled：页面滚动时是否折叠导航条和底部条；
     preferredBarTintColor：导航栏和工具栏背景色；
     preferredControlTintColor：导航栏和工具栏上按钮颜色；
     dismissButtonStyle：关闭页面的按钮样式；
     - 提示：iOS15后可提供`activityButton`和`eventAttribution`功能，此处暂时不提供
     */
    func openInSafari(_ urlStr: String,
                      entersReaderIfAvailable: Bool = false,
                      barCollapsingEnabled: Bool = true,
                      preferredBarTintColor: UIColor? = nil,
                      preferredControlTintColor: UIColor? = nil,
                      dismissButtonStyle: SFSafariViewController.DismissButtonStyle = .done) throws
    {
        if let url = URL(string: urlStr)
        {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = entersReaderIfAvailable
            config.barCollapsingEnabled = barCollapsingEnabled
            let vc = self.createInternalSafari(url: url, config: config, preferredBarTintColor: preferredBarTintColor, preferredControlTintColor: preferredControlTintColor, dismissButtonStyle: dismissButtonStyle)
            g_presentVC(vc)
        }
        else
        {
            throw SSMError.unsupportUrl
        }
    }
    
}
