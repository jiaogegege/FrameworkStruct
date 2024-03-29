//
//  WebAdapter.swift
//  FrameworkStruct
//
//  Created by jggg on 2022/2/23.
//

/**
 * Web适配器，主要和web页面对接和交互
 */
import UIKit

class WebAdapter: OriginAdapter, SingletonProtocol
{
    typealias Singleton = WebAdapter
    
    //MARK: 属性
    //单例
    static let shared = WebAdapter()
    
    //所有活跃的BasicWebViewController数组
    fileprivate var webVCArray: WeakArray = WeakArray.init()
    
    //当前显示的webvc
    fileprivate(set) weak var currentWebVC: BasicWebViewController?
    
    
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
extension WebAdapter: ExternalInterface
{
    ///在系统浏览器中打开url，返回是否打开成功
    func openInBrowser(_ urlStr: String, completion: ((_ success: Bool) -> Void)? = nil)
    {
        if let url = URL(string: urlStr)
        {
            UIApplication.shared.open(url, options: [:]) { (success) in
                if let comp = completion
                {
                    comp(success)
                }
            }
        }
        else
        {
            if let comp = completion
            {
                comp(false)
            }
        }
    }
    
    ///在内置safari中打开url，回调回传是否打开成功
    func openInSafari(_ urlStr: String, isSuccess: ((_ success: Bool) -> Void)? = nil)
    {
        do {
            try SafariServiceAdapter.shared.openInSafari(urlStr, entersReaderIfAvailable: false, barCollapsingEnabled: true, preferredBarTintColor: nil, preferredControlTintColor: nil, dismissButtonStyle: .close)
            if let cb = isSuccess
            {
                cb(true)
            }
        } catch {
            print(error)
            if let cb = isSuccess
            {
                cb(false)
            }
        }
    }
    
    ///添加url到safari阅读列表
    func addToSafariReadList(_ urlStr: String, title: String?, previewText: String?, isSuccess: ((_ success: Bool) -> Void)? = nil)
    {
        do {
            try SafariServiceAdapter.shared.addReadList(urlStr, title: title, previewText: previewText)
            if let cb = isSuccess
            {
                cb(true)
            }
        } catch {
            print(error)
            if let cb = isSuccess
            {
                cb(false)
            }
        }
    }
    
    /**************************************** webview交互 Section Begin ***************************************/
    
    ///在webView中打开一个url
    ///参数：hostVC：如果传这个参数，就用这个vc来pushwebviewVC，否则用最顶上的navVC来push
    func openInWebVC(url: String, remote: Bool = true, title: String? = nil, hideNavBar: Bool = false, showProgress: Bool = true, hostVC: UIViewController? = nil)
    {
        let vc = self.createWebVC(url: url, remote: remote, title: title, hideNavBar: hideNavBar, showProgress: showProgress)
        g_pushVC(vc)
    }
    
    ///创建一个webviewcontroller
    func createWebVC(url: String, remote: Bool = true, title: String? = nil, hideNavBar: Bool = false, showProgress: Bool = true) -> BasicWebViewController
    {
        let vc = BasicWebViewController()
        vc.hideNavBar = hideNavBar
        vc.url = remote ? .remote(url) : .local(url)
        if let title = title {
            vc.titleStr = title
        }
        //加入弱引用数组
        self.webVCArray.add(vc)
        vc.showProgress = showProgress
        return vc
    }
    
    ///将vc设置为当前正在显示的webviewVC，创建webviewVC的时候会自动调用
    func showWebVC(_ vc: BasicWebViewController?)
    {
        if let vc = vc {
            self.currentWebVC = vc
        }
    }
    
    ///获取当前页面的url，completion可能不会执行，所以调用该方法的对象要做一些回调未执行的处理
    func getCurrentPageUrl(completion: @escaping OpStrClo)
    {
        if let cur = currentWebVC
        {
            cur.callWebHandler(name: WebHandlerH5Name.getUrl.rawValue, param: nil) { (responseData) in
                completion(responseData as? String)
            }
        }
    }
    
    /**************************************** webview交互 Section End ***************************************/
    
}
