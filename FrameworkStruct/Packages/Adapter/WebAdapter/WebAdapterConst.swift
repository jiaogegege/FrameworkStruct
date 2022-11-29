//
//  WebAdapterConst.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/2/25.
//

import Foundation

//native和js的交互方法类型
//参数：
//name：交互方法名称
//data：方法中传递的数据
//handler：方法体
struct WebContentHandler {
    var name: String                //方法名
    var data: Any?                  //传输的数据
    var handler: WVJBHandler?       //处理闭包
}

/**
 * 预定义的native方法
 */
//MARK: js交互原生handler，原生提供给h5调用的方法，根据具体需求定义
enum WebHandlerNative {
    static let noneName = "none"
    case none                                                           //空
    
    /**************************************** 默认加载的handler Section Begin ****************************************/
    static let neededHandlersName = "neededHandlers"
    case neededHandlers(BasicWebViewController)                         //H5页面将其需要的所有handler名字传过来，navtive根据获取的列表加载相应的handler，参数：一个回调，返回所有的handlers名字
    
    static let supportHandlersName = "supportHandlers"
    case supportHandlers(BasicWebViewController)                        //H5页面支持调用的方法
    
    static let getAppNameName = "getAppName"
    case getAppName                                                     //获得应用名称
    
    static let goName = "go"
    case go(BasicWebViewController)                                     //进入一个新的H5界面，参数：push的界面，一般是WebViewController
    
    static let backName = "back"
    case back(BasicWebViewController)                                   //返回上一个界面，参数：pop的界面，一般是self（WebViewController）
    
    static let pushName = "push"
    case push(BasicWebViewController)                                   //H5页面想要push一个本地界面，H5需要传一个页面的标志符和相关参数
    
    static let hideNavBarName = "hideNavBar"
    case hideNavBar(BasicWebViewController)                             //隐藏webVC导航栏，传参数：1:隐藏，0:显示
    
    static let alertName = "alert"
    case alert                                                          //弹出一个弹框，带一个确定按钮
    
    static let alertConfirmCancelName = "alertConfirmCancel"
    case alertConfirmCancel                                             //弹出一个弹框，带确定和取消按钮，并将用户的选择结果返回给js
    
    /**************************************** 默认加载的handler Section End ****************************************/
    
    /**************************************** 可选handler Section Begin ****************************************/
    static let getUserIdName = "getUserId"
    case getUserId                                                      //获取当前用户id
    
    /**************************************** 可选handler Section End ****************************************/
    
    ///获取每个页面都要加载的默认handlers
    static func defaultHandlers(hostVC: BasicWebViewController) -> [WebContentHandler]
    {
        [WebHandlerNative.neededHandlers(hostVC).getHandler(),
         WebHandlerNative.supportHandlers(hostVC).getHandler(),
         WebHandlerNative.getAppName.getHandler(),
         WebHandlerNative.go(hostVC).getHandler(),
         WebHandlerNative.back(hostVC).getHandler(),
         WebHandlerNative.push(hostVC).getHandler(),
         WebHandlerNative.hideNavBar(hostVC).getHandler(),
         WebHandlerNative.alert.getHandler(),
         WebHandlerNative.alertConfirmCancel.getHandler()]
    }
    
    //从字符串获取枚举类型，一般是H5传递需要的handler名称
    static func getHandlerType(from name: String, hostVC: BasicWebViewController) -> WebHandlerNative
    {
        switch name {
        case neededHandlersName:
            return WebHandlerNative.neededHandlers(hostVC)
        case supportHandlersName:
            return WebHandlerNative.supportHandlers(hostVC)
        case getAppNameName:
            return WebHandlerNative.getAppName
        case goName:
            return WebHandlerNative.go(hostVC)
        case backName:
            return WebHandlerNative.back(hostVC)
        case pushName:
            return WebHandlerNative.push(hostVC)
        case hideNavBarName:
            return WebHandlerNative.hideNavBar(hostVC)
        case alertName:
            return WebHandlerNative.alert
        case alertConfirmCancelName:
            return WebHandlerNative.alertConfirmCancel
        case getUserIdName:
            return WebHandlerNative.getUserId
        default:
            return WebHandlerNative.none
        }
    }
    
    //获取handler对象
    func getHandler() -> WebContentHandler
    {
        switch self {
        case .none:
            return WebContentHandler(name: WebHandlerNative.noneName, data: nil) { data, responseCallback in
                
            }
        case .neededHandlers(let vc):
            let handler = WebContentHandler(name: WebHandlerNative.neededHandlersName, data: nil) {[weak vc] data, responseCallback in
                if let names = data as? [String]
                {
                    var typeArray: [WebContentHandler] = []
                    //创建枚举对象
                    for name in names
                    {
                        let type = WebHandlerNative.getHandlerType(from: name, hostVC: vc!)
                        typeArray.append(type.getHandler())
                    }
                    //传给控制器
                    vc?.neededHandlers = typeArray
                }
            }
            return handler
        case .supportHandlers(let vc):
            let handler = WebContentHandler(name: WebHandlerNative.supportHandlersName, data: nil) {[weak vc] data, responseCallback in
                if let names = data as? [String]
                {
                    vc?.supportHandlers = names
                }
            }
            return handler
        case .getAppName:
            let handler = WebContentHandler(name: WebHandlerNative.getAppNameName, data: nil) { data, responseCallback in
                if let cb = responseCallback
                {
                    cb(String.appName)
                }
            }
            return handler
        case .go(let vc):
            let handler = WebContentHandler(name: WebHandlerNative.goName, data: nil) {[weak vc] data, responseCallback in
                let webVC = WebAdapter.shared.createWebVC(url: data as? String ?? "", remote: true, title: nil, hideNavBar: false, showProgress: true)
                vc?.navigationController?.pushViewController(webVC, animated: true)
            }
            return handler
        case .back(let vc):
            let handler = WebContentHandler(name: WebHandlerNative.backName, data: nil) {[weak vc] data, responseCallback in
                vc?.navigationController?.popViewController(animated: true)
            }
            return handler
        case .push(let vc):
            let handler = WebContentHandler(name: WebHandlerNative.pushName, data: nil) {[weak vc] (data, responseCallback) in
                //获取对应的页面相关参数
                if let params = data as? Dictionary<String, Any>
                {
                    WebPushNativeVC.gotoVC(params: params, hostVC: vc)
                }
            }
            return handler
        case .hideNavBar(let vc):
            let handler = WebContentHandler(name: WebHandlerNative.hideNavBarName, data: nil) {[weak vc] (data, responseCallback) in
                if let hide = data as? Int
                {
                    vc?.hideNavBar = hide == 1 ? true : false
                }
            }
            return handler
        case .alert:
            let handler = WebContentHandler(name: WebHandlerNative.alertName, data: nil) { data, responseCallback in
                if let data = data
                {
                    AlertManager.shared.wantPresentAlert(title: nil, message: (data as! String), messageAlign: .center, leftTitle: nil, leftBlock: nil, rightTitle: String.confirm) { text in
                        
                    }
                }
            }
            return handler
        case .alertConfirmCancel:
            let handler = WebContentHandler(name: WebHandlerNative.alertConfirmCancelName, data: nil) { data, responseCallback in
                if let data = data
                {
                    AlertManager.shared.wantPresentAlert(title: nil, message: (data as! String), messageAlign: .center, leftTitle: String.cancel, leftBlock: {
                        if let cb = responseCallback
                        {
                            cb(false)
                        }
                    }, rightTitle: String.confirm) { text in
                        if let cb = responseCallback
                        {
                            cb(true)
                        }
                    }
                }
            }
            return handler
        case .getUserId:
            let handler = WebContentHandler(name: WebHandlerNative.getUserIdName, data: nil) { data, responseCallback in
                let userId = UserManager.shared.currentUserId
                if let cb = responseCallback
                {
                    cb(userId)
                }
            }
            return handler
        }
    }
}


//MARK: js交互h5 handler名称，h5提供给原生调用的方法名，根据H5页面提供定义
enum WebHandlerH5Name: String {
    case getUrl                         //获取页面url地址字符串
    
}


//MARK: H5想要push的本地界面的标志符，和`push`方法配合使用，根据实际需求定义
enum WebPushNativeVC: Int {
    static let vcType: String = "vcType"                //H5页面push本地界面时传递的对应界面标志符的参数key
    
    case none = 1000                                    //未指定界面
    case simpleTableVC = 1001                           //进入简单表格界面
    
    //跳转界面
    static func gotoVC(params: Dictionary<String, Any>, hostVC: BasicWebViewController?)
    {
        //H5页面传递的参数根据项目实际情况约定
        let type = WebPushNativeVC(rawValue: (params[WebPushNativeVC.vcType] as? Int ?? WebPushNativeVC.none.rawValue))
        switch type {
        case .simpleTableVC:
            let vc = SimpleTableViewController.getViewController()
            vc.titleStr = params["titleStr"] as? String
            hostVC?.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}


//MARK: 项目中一些特定url路径，根据实际需求定义
enum WebUrlPath: String {
    case appDownloadUrl = "/st/appDownload.html"                            //App下载地址
    case privacyUrl = "/st/privacyPolicy.html"                              //隐私政策
    case userAgreementUrl = "/st/userAgreement.html"                        //用户协议
    case helpCenterUrl = "/st/helpCenter.html"                              //帮助中心
    case waitSeckillUrl = "/st/activityList.html"                           //云待秒杀
    case bigSubsidyUrl = "/st/brandSubsidies.html"                          //大牌补贴
    
    //获取完整url，拼接可获取的默认参数，其他参数可手动拼接
    func getUrl() -> String
    {
        NetworkAdapter.shared.currentHost + self.joinParams()
    }
    
    //拼接参数
    func joinParams() -> String
    {
        switch self {
        case .appDownloadUrl:
            return self.rawValue
        case .privacyUrl:
            return self.rawValue
        case .userAgreementUrl:
            return self.rawValue
        case .helpCenterUrl:
            return self.rawValue
        case .waitSeckillUrl:
            return self.rawValue.joinUrlParam(g_userToken, key: WUParamKey.token.rawValue)
        case .bigSubsidyUrl:
            return self.rawValue.joinUrlParam(g_userToken, key: WUParamKey.token.rawValue).joinUrlParam(g_userId, key: WUParamKey.userId.rawValue)
        }
    }
    
    //拼接的url参数key列表
    enum WUParamKey: String {
        case token                      //用户token
        case userId                     //用户id
    }
}


//MARK: Javascript代码片段
///获取h5页面标题
let js_getTitle: JavascriptExpression = "document.title"
