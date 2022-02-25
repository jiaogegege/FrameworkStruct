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
    var name: String
    var data: Any?
    var handler: WVJBHandler?
    
}

/**
 * 预定义的native方法
 */
//js交互原生handler，根据具体需求定义
enum WebHandlerNative {
    /**************************************** 默认加载的handler Section Begin ****************************************/
    static let neededHandlersName = "neededHandlers"
    case neededHandlers(BasicWebViewController)                         //H5页面将其需要的所有handler名字传过来，navtive根据获取的列表加载相应的handler，参数：一个回调，返回所有的handlers名字
    static let goName = "go"
    case go(BasicWebViewController)                   //push进入某个界面，参数：push的界面，一般是WebViewController
    static let backName = "back"
    case back(BasicWebViewController)                 //返回上一个界面，参数：pop的界面，一般是self（WebViewController）
    static let alertName = "alert"
    case alert                                  //弹出一个弹框，带一个确定按钮
    static let alertConfirmCancelName = "alertConfirmCancel"
    case alertConfirmCancel                     //弹出一个弹框，带确定和取消按钮，并返回给js用户的选择结果
    
    /**************************************** 默认加载的handler Section End ****************************************/
    
    /**************************************** 可选handler Section Begin ****************************************/
    static let getUserIdName = "getUserId"
    case getUserId                              //获取当前用户id
    
    /**************************************** 可选handler Section End ****************************************/
    
    ///获取每个页面都要加载的handlers
    static func defaultHandlers(hostVC: BasicWebViewController) -> [WebContentHandler]
    {
        return [WebHandlerNative.neededHandlers(hostVC).getHandler(),
                WebHandlerNative.go(hostVC).getHandler(),
                WebHandlerNative.back(hostVC).getHandler(),
                WebHandlerNative.alert.getHandler(),
                WebHandlerNative.alertConfirmCancel.getHandler()]
    }
    
    //从字符串获取枚举类型
    static func getHandlerType(from name: String, hostVC: BasicWebViewController) -> WebHandlerNative
    {
        return WebHandlerNative.alert
    }
    
    //获取handler对象
    func getHandler() -> WebContentHandler
    {
        switch self {
        case .neededHandlers(let vc):
            let handler = WebContentHandler(name: WebHandlerNative.neededHandlersName, data: nil) {[weak vc] data, responseCallback in
                if let da = data as? [String]
                {
                    vc?.registerNeededHandler(handlerNames: da)
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

//js交互h5 handler
enum WebHandlerH5 {
    case alert              //弹出一个alert弹框
}

/**
 * Javascript片段
 */
typealias JavascriptExpression = String
let js_getTitle: JavascriptExpression = "document.title"
