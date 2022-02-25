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
    case neededHandlers(([String]) -> Void)                         //H5页面将其需要的所有handler名字传过来，navtive根据获取的列表加载相应的handler，参数：一个回调，返回所有的handlers名字
    case go(UIViewController)                   //push进入某个界面，参数：push的界面，一般是WebViewController
    case back(UIViewController)                 //返回上一个界面，参数：pop的界面，一般是self（WebViewController）
    case alert                                  //弹出一个弹框，带一个确定按钮
    case alertConfirmCancel                     //弹出一个弹框，带确定和取消按钮，并返回给js用户的选择结果

    func getHandler() -> WebContentHandler
    {
        switch self {
        case .neededHandlers(let callback):
            let handler = WebContentHandler(name: "neededHandlers", data: nil) { data, responseCallback in
                if let da = data as? [String]
                {
                    callback(da)
                }
            }
            return handler
        case .go(let vc):
            let handler = WebContentHandler(name: "go", data: nil) { data, responseCallback in
                let webVC = BasicWebViewController()
                webVC.url = .remote(data as! String)
                vc.navigationController?.pushViewController(webVC, animated: true)
            }
            return handler
        case .back(let vc):
            let handler = WebContentHandler(name: "back", data: nil) { data, responseCallback in
                vc.navigationController?.popViewController(animated: true)
            }
            return handler
        case .alert:
            let handler = WebContentHandler(name: "alert", data: nil) { data, responseCallback in
                if let data = data
                {
                    AlertManager.shared.wantPresentAlert(title: nil, message: (data as! String), messageAlign: .center, leftTitle: nil, leftBlock: nil, rightTitle: String.confirm) {
                        
                    }
                }
            }
            return handler
        case .alertConfirmCancel:
            let handler = WebContentHandler(name: "alertConfirmCancel", data: nil) { data, responseCallback in
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
