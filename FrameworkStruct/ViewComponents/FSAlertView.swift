//
//  FSAlertView.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/1/12.
//

/**
 * 系统弹框
 */
import UIKit

class FSAlertView: UIAlertController, AlertManagerProtocol
{
    //MARK: 属性
    //静态变量，记录已经创建的FSAlertView对象
    static let identifierKeyMap = WeakDictionary.init()
    
    //遵循alertmanager协议，提供属性
    var dismissCallback: VoidClosure?
    
    //唯一标志符
    fileprivate(set) var identifierKey: String? = nil

    
    //MARK: 方法
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    deinit {
        if let callback = self.dismissCallback
        {
            callback()
        }
        FSLog("FSAlertView: dealloc")
    }
    
}


//接口方法
extension FSAlertView: ExternalInterface
{
    //创建一个alertview
    class func alertView(title: String? = nil,
                         message: String? = nil,
                         messageAlign: NSTextAlignment = .center,
                         needInput: Bool = false,
                         inputPlaceHolder: String? = nil,
                         usePlaceHolder: Bool = false,          //如果没有输入文字，是否使用placeholder代替
                         identifierKey: String,
                         tintColor: UIColor,
                         cancelTitle: String? = String.cancel,
                         cancelBlock:((UIAlertAction) -> Void)? = nil,
                         confirmTitle: String? = String.confirm,
                         confirmBlock:((UIAlertAction, _ inputText: String?) -> Void)? = nil,
                         inViewController: UIViewController? = nil) -> FSAlertView?
    {
        if identifierKeyMap.object(forKey: identifierKey) is FSAlertView
        {
            //如果有值那么不创建
            return nil
        }
        
        let alertView = FSAlertView(title: title, message: message, preferredStyle: .alert)
        alertView.identifierKey = identifierKey
        //改变字体大小和颜色
        if let ti = title
        {
            let attrTitle = NSMutableAttributedString(string: ti)
            attrTitle.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)], range: NSMakeRange(0, ti.count))
            alertView.setValue(attrTitle, forKey: "attributedTitle")
        }
        if let me = message
        {
            let attrMessage = NSMutableAttributedString(string: me)
            attrMessage.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], range: NSMakeRange(0, me.count))
            alertView.setValue(attrMessage, forKey: "attributedMessage")
        }
        //是否输入文本
        if needInput == true
        {
            alertView.addTextField { textField in
                //此处可以配置`textField`的属性
                textField.font = UIFont.systemFont(ofSize: 14)
                textField.placeholder = inputPlaceHolder
            }
        }
        //设置回调
        if let cancel = cancelBlock //如果cancel回调有值，那么创建取消按钮
        {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .default, handler: cancel)
            cancelAction.setValue(tintColor, forKey: "titleTextColor")
            alertView.addAction(cancelAction)
        }
        if let confirm = confirmBlock   //如果confirm回调有值，那么创建确定按钮
        {
            let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { [weak alertView] action in
                var inputText: String? = nil
                if let field = alertView?.textFields?.first {
                    if let text = field.text, g_validString(text) {
                        inputText = text
                    }
                    else {
                        inputText = field.placeholder
                    }
                }
                confirm(action, inputText)
            }
            confirmAction.setValue(tintColor, forKey: "titleTextColor")
            alertView.addAction(confirmAction)
        }
        //修改对齐方式
        if messageAlign != .center
        {
            let subView1 = alertView.view.subviews[0]
            let subView2 = subView1.subviews[0]
            let subView3 = subView2.subviews[0]
            let subView4 = subView3.subviews[0]
            let subView5 = subView4.subviews[0]
            var messageLabel: UILabel = UILabel()
            for v in subView5.subviews
            {
                if v.isKind(of: UILabel.self)
                {
                    messageLabel = v as! UILabel
                    break
                }
            }
            messageLabel.textAlignment = messageAlign
        }
        //设置自身到字典中
        identifierKeyMap.setObject(alertView, forKey: identifierKey)
        if let parent = inViewController
        {
            parent.present(alertView, animated: true, completion: nil)
        }
        return alertView
    }
    
    //消失掉所有的弹框
    static func dismissAllAlert(completion:VoidClosure?)
    {
        let keys = self.identifierKeyMap.keyEnumerator()
        for key in keys
        {
            let alertView = identifierKeyMap.object(forKey: key) as! FSAlertView
            alertView.presentingViewController?.dismiss(animated: false, completion: nil)
        }
        if let comp = completion
        {
            comp()
        }
    }
    
}
