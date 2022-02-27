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
    
    ///在弱引用数组中添加一个vc
    func showWebVC(_ vc: BasicWebViewController)
    {
        self.currentWebVC = vc
    }
    
    ///获取当前页面的url，completion可能不会执行，所以调用该方法的对象要做一些回调未执行的处理
    func getCurrentPageUrl(completion: @escaping ((String?) -> Void))
    {
        if let cur = currentWebVC
        {
            cur.callWebHandler(name: WebHandlerH5Name.getUrl.rawValue, param: nil) { (responseData) in
                completion(responseData as? String)
            }
        }
    }
    
}
