//
//  FSAlertView.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/1/12.
//

import UIKit

class FSAlertView: UIAlertController {
    //MARK: 属性
    //静态变量，记录已经创建的CKAlertView对象
    static let identifierKeyMap = WeakDictionary.init()
    
    //唯一标志符
    fileprivate(set) var identifierKey: String? = nil

    
    //MARK: 方法
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}


//接口方法
extension FSAlertView: ExternalInterface
{
    static func alertView(title: String? = nil,
                          message: String? = nil,
                          messageAlign: NSTextAlignment = .center,
                          identifierKey: String,
                          tintColor: UIColor,
                          cancelTitle: String? = String.sCancel,
                          cancelBlock:((UIAlertAction) -> Void)? = nil,
                          confirmTitle: String? = String.sConfirm,
                          confirmBlock:((UIAlertAction) -> Void)? = nil,
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
        if let cancel = cancelBlock //如果cancel回调有值，那么创建取消按钮
        {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .default, handler: cancel)
            cancelAction.setValue(tintColor, forKey: "titleTextColor")
            alertView.addAction(cancelAction)
        }
        if let confirm = confirmBlock   //如果confirm回调有值，那么创建确定按钮
        {
            let confirmAction = UIAlertAction(title: confirmTitle, style: .default, handler: confirm)
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
    static func dismissAllAlert(completion:(() -> Void)?)
    {
        
    }
    
}
