//
//  BasicWebViewController.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/2/25.
//

/**
 * 基础`WebViewCongroller`，添加对wkwebview和js交互的支持
 */
import UIKit
import WebKit

class BasicWebViewController: BasicViewController
{
    //MARK: 属性
    /**************************************** 外部属性 Section Begin ***************************************/
    //资源类型和url字符串
    var url: WVResourceType?
    
    //标题，将作为导航栏标题使用，如果不传，默认使用网页的title
    var titleStr: String?
    
    //是否显示加载进度条
    var showProgress: Bool = true
    
    //特定H5页面要添加的handlers，根据不同的页面添加不同的handlers
    var neededHandlers: [WebContentHandler]? {
        didSet {
            if let neededHandlers = neededHandlers {
                for handler in neededHandlers {
                    jsBridge.registerHandler(handler.name, handler: handler.handler)
                }
            }
        }
    }
    
    //特定H5页面支持navtive调用的js handlers
    var supportHandlers: [String]?
    
    /**************************************** 外部属性 Section End ***************************************/
    
    //默认handlers，每个页面都会添加，有一些默认的handlers一定会添加，比如go/back等
    fileprivate lazy var defaultHandlers: [WebContentHandler] = {
        return WebHandlerNative.defaultHandlers(hostVC: self)
    }()

    //webview
    fileprivate var webView: WKWebView!
    //进度条
    fileprivate var progressBar: UIProgressView!
    
    //js交互对象
    fileprivate var jsBridge: WKWebViewJavascriptBridge!
    

    //MARK: 方法
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        WebAdapter.shared.showWebVC(self)
    }
    
    override func createUI() {
        super.createUI()
        //webview
        self.webView = WKWebView(frame: .fullScreen, configuration: WKWebViewConfiguration())
        self.view.addSubview(webView)
        //进度条
        self.progressBar = UIProgressView(frame: CGRect(x: 0, y: (self.hideNavBar ? kStatusHeight : kSafeTopHeight), width: kScreenWidth, height: 2.0))
        self.view.addSubview(progressBar)
    }
    
    override func configUI() {
        //设置标题
        if let titleStr = titleStr {
            self.title = titleStr
        }
        //webview
        webView.frame = .fullScreen
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.addObserver(self, forKeyPath: WVObserveKey.webViewProgress.rawValue, options: [.old, .new], context: nil)
        //加载js bridge列表
        self.configJsBridge()
        //进度条
        progressBar.frame = CGRect(x: 0, y: (self.hideNavBar ? kStatusHeight : kSafeTopHeight), width: kScreenWidth, height: 2.0)
        progressBar.progressViewStyle = .default
        progressBar.progressTintColor = theme.mainColor
        progressBar.trackTintColor = .clear
        progressBar.progress = 0.0
    }

    //配置js交互handler
    fileprivate func configJsBridge()
    {
        self.jsBridge = WKWebViewJavascriptBridge(for: self.webView)
        jsBridge.setWebViewDelegate(self)
        //添加默认handlers
        for handler in defaultHandlers {
            jsBridge.registerHandler(handler.name, handler: handler.handler)
        }
    }
    
    //监听进度
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == WVObserveKey.webViewProgress.rawValue   //加载进度
        {
            self.progressBar.setProgress(Float(self.webView.estimatedProgress), animated: true)
            if webView.estimatedProgress >= 1.0
            {
                //加载完成后一定时间隐藏进度条
                g_after(BasicWebViewController.progressHiddenDelay) {
                    self.progressBar.isHidden = true
                }
            }
        }
        else
        {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    //将进度条重置为初始状态
    fileprivate func resetProgressBar()
    {
        self.progressBar.isHidden = false
        self.progressBar.progressTintColor = theme.mainColor
        self.progressBar.setProgress(0.0, animated: false)
    }
    
    //加载资源
    fileprivate func loadRequest()
    {
        self.resetProgressBar()
        
        if let url = self.url {
            switch url
            {
            case .remote(_):
                if let u = url.getUrl()
                {
                    webView.load(URLRequest(url: u))
                }
            case .local(_):
                if let u = url.getUrl()
                {
                    webView.loadFileURL(u, allowingReadAccessTo: u)
                }
            }
        }
    }
    
    //清除缓存
    fileprivate func deleteWebCache()
    {
        let data = WKWebsiteDataStore.allWebsiteDataTypes()
        let fromDate = Date(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: data, modifiedSince: fromDate) {
            
        }
    }
    
    //清理
    fileprivate func cleanUp()
    {
        //清理js句柄
        for handler in defaultHandlers
        {
            jsBridge.removeHandler(handler.name)
        }
        if let handlers = neededHandlers
        {
            for handler in handlers
            {
                jsBridge.removeHandler(handler.name)
            }
        }
        webView.removeObserver(self, forKeyPath: WVObserveKey.webViewProgress.rawValue)
        //清理缓存
        self.deleteWebCache()
        //清理webview
        self.webView.removeFromSuperview()
        self.webView = nil
    }

    deinit {
        self.cleanUp()
    }
    
}


//代理方法
extension BasicWebViewController: WKNavigationDelegate, WKUIDelegate
{
    /**************************************** WKNavigationDelegate Section Begin ***************************************/
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.resetProgressBar()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        g_after(BasicWebViewController.progressHiddenDelay) {
            self.progressBar.isHidden = true
        }
        //标题，如果外部没有传入标题，那么从这里获取
        if self.titleStr == nil
        {
            webView.evaluateJavaScript(js_getTitle) {[weak self] (title, error) in
                self?.title = title as? String
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        g_after(BasicWebViewController.progressHiddenDelay) {
            self.progressBar.isHidden = true
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
    
    //网页内容进程中断
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
    }
    
    /**************************************** WKNavigationDelegate Section End ***************************************/
    
    /**************************************** WKUIDelegate Section Begin ***************************************/
//    func webViewDidClose(_ webView: WKWebView) {
//        webView.removeFromSuperview()
//    }
    
    //网页弹框
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        AlertManager.shared.directPresentAlert(title: nil, message: message, leftTitle: nil, leftBlock: nil, rightTitle: String.confirm) {
            completionHandler()
        }
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        AlertManager.shared.directPresentAlert(title: nil, message: message, leftTitle: String.cancel, leftBlock: {
            completionHandler(false)
        }, rightTitle: String.confirm) {
            completionHandler(true)
        }
    }
    
//    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
//        completionHandler(defaultText)
//    }
    
    /**************************************** WKUIDelegate Section End ***************************************/
}


//内部类型
extension BasicWebViewController: InternalType
{
    //资源类型
    enum WVResourceType {
        case remote(String)     //网络资源，绑定一个url地址
        case local(String)      //本地资源，绑定一个file路径
        
        //获取url字符串
        func getUrlStr() -> String
        {
            switch self {
            case .remote(let string):
                return string
            case .local(let string):
                return string
            }
        }
        
        //获取URL
        func getUrl() -> URL?
        {
            switch self {
            case .remote(let string):
                return URL(string: string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            case .local(let string):
                return URL(fileURLWithPath: string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            }
        }
    }
    
    //KVO监听类型
    enum WVObserveKey: String {
        case webViewProgress = "estimatedProgress"      //webivew进度
    }
    
    //页面加载完成后进度条延迟消失的时间
    static let progressHiddenDelay: TimeInterval = 0.4
    
}


//接口方法
extension BasicWebViewController: ExternalInterface
{
    ///重新加载页面
    func reload()
    {
        webView.reload()
    }
    
    ///能否在这个页面上执行某个H5 handler
    func canCallWebHandler(_ handlerName: String) -> Bool
    {
        if let supports = self.supportHandlers
        {
            if supports.contains(handlerName)
            {
                return true
            }
        }
        return false
    }
    
    ///调用js方法
    func callWebHandler(name: String, param: Any?, completion: ((Any?) -> Void)?)
    {
        if self.canCallWebHandler(name)
        {
            jsBridge.callHandler(name, data: param) { (responseData) in
                if let comp = completion
                {
                    comp(responseData)
                }
            }
        }
    }
    
}
