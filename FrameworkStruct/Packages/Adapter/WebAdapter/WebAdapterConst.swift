//
//  WebAdapterConst.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/2/25.
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
    var webHandler: WVJBResponseCallback?   //h5回调
}

/**
 * 预定义的native方法
 */
//js交互原生handler，根据具体需求定义
enum WebHandlerNative {
    static let noneName = "none"
    case none                       //空
    /**************************************** 默认加载的handler Section Begin ****************************************/
    static let neededHandlersName = "neededHandlers"
    case neededHandlers(BasicWebViewController)                         //H5页面将其需要的所有handler名字传过来，navtive根据获取的列表加载相应的handler，参数：一个回调，返回所有的handlers名字
    
    static let supportHandlersName = "supportHandlers"
    case supportHandlers(BasicWebViewController)                        //H5页面支持调用的方法
    
    static let getAppNameName = "getAppName"
    case getAppName                             //获得应用名称
    
    static let goName = "go"
    case go(BasicWebViewController)                   //进入一个新的H5界面，参数：push的界面，一般是WebViewController
    
    static let backName = "back"
    case back(BasicWebViewController)                 //返回上一个界面，参数：pop的界面，一般是self（WebViewController）
    
    static let alertName = "alert"
    case alert                                  //弹出一个弹框，带一个确定按钮
    
    static let alertConfirmCancelName = "alertConfirmCancel"
    case alertConfirmCancel                     //弹出一个弹框，带确定和取消按钮，并将用户的选择结果返回给js
    
    /**************************************** 默认加载的handler Section End ****************************************/
    
    /**************************************** 可选handler Section Begin ****************************************/
    static let getUserIdName = "getUserId"
    case getUserId                              //获取当前用户id
    
    /**************************************** 可选handler Section End ****************************************/
    
    ///获取每个页面都要加载的默认handlers
    static func defaultHandlers(hostVC: BasicWebViewController) -> [WebContentHandler]
    {
        return [WebHandlerNative.neededHandlers(hostVC).getHandler(),
                WebHandlerNative.supportHandlers(hostVC).getHandler(),
                WebHandlerNative.getAppName.getHandler(),
                WebHandlerNative.go(hostVC).getHandler(),
                WebHandlerNative.back(hostVC).getHandler(),
                WebHandlerNative.alert.getHandler(),
                WebHandlerNative.alertConfirmCancel.getHandler()]
    }
    
    //从字符串获取枚举类型
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
                if let res = responseCallback
                {
                    res(String.appName)
                }
            }
            return handler
        case .go(let vc):
            let handler = WebContentHandler(name: WebHandlerNative.goName, data: nil) {[weak vc] data, responseCallback in
                let webVC = BasicWebViewController()
                webVC.url = .remote(data as! String)
                vc?.navigationController?.pushViewController(webVC, animated: true)
            }
            return handler
        case .back(let vc):
            let handler = WebContentHandler(name: WebHandlerNative.backName, data: nil) {[weak vc] data, responseCallback in
                vc?.navigationController?.popViewController(animated: true)
            }
            return handler
        case .alert:
            let handler = WebContentHandler(name: WebHandlerNative.alertName, data: nil) { data, responseCallback in
                if let data = data
                {
                    AlertManager.shared.wantPresentAlert(title: nil, message: (data as! String), messageAlign: .center, leftTitle: nil, leftBlock: nil, rightTitle: String.confirm) {
                        
                    }
                }
            }
            return handler
        case .alertConfirmCancel:
            let handler = WebContentHandler(name: WebHandlerNative.alertConfirmCancelName, data: nil) { data, responseCallback in
                if let data = data
                {
                    AlertManager.shared.wantPresentAlert(title: nil, message: (data as! String), messageAlign: .center, leftTitle: String.cancel, leftBlock: {
                        if let res = responseCallback
                        {
                            res(false)
                        }
                    }, rightTitle: String.confirm) {
                        if let res = responseCallback
                        {
                            res(true)
                        }
                    }
                }
            }
            return handler
        case .getUserId:
            let handler = WebContentHandler(name: WebHandlerNative.getUserIdName, data: nil) { data, responseCallback in
                let userId = UserManager.shared.currentUserId
                if let res = responseCallback
                {
                    res(userId)
                }
            }
            return handler
        }
    }
}

//js交互h5 handler名称
enum WebHandlerH5Name: String {
    case getUrl                         //获取页面url地址字符串
    
}


//MARK: Javascript代码片段
/**
 * Javascript片段
 */
typealias JavascriptExpression = String
let js_getTitle: JavascriptExpression = "document.title"
