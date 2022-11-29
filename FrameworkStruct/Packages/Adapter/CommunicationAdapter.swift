//
//  CommunicationAdapter.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/4/8.
//

/**
 * 系统通信适配器
 * 打电话、发短信、发邮件等
 */
import UIKit
import Messages
import MessageUI

class CommunicationAdapter: OriginAdapter
{
    //MARK: 属性
    //单例
    static let shared = CommunicationAdapter()
    
    //自定义信息回调，返回值：是否发送成功
    var customSmsCompletionCallback: ((_ result: MessageComposeResult) -> Void)?
    //自定义邮件回调
    var customMailCompletionCallback: ((_ result: MFMailComposeResult) -> Void)?
    
    
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


//代理方法
extension CommunicationAdapter: DelegateProtocol, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate
{
    //发送信息的vc完成操作
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true)
        if let cb = self.customSmsCompletionCallback
        {
            cb(result)
            self.customSmsCompletionCallback = nil
        }
    }
    
    //发送邮件的vc完成操作
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        if let cb = self.customMailCompletionCallback
        {
            if let error = error {
                FSLog(error.localizedDescription)
                cb(.failed)
            }
            else
            {
                cb(result)
            }
            self.customMailCompletionCallback = nil
        }
    }
    
}


//接口方法
extension CommunicationAdapter: ExternalInterface
{
    ///获取本机号码
    ///私有API暂不接入，可通过集成运营商SDK获取
    var localPhone: String? {
        return nil
    }
    
    ///拨打电话
    func callPhone(_ phone: String, completion: ((_ success: Bool) -> Void)? = nil)
    {
        if g_validString(phone.trim())
        {
            if let url = URL(string: String(format: "tel://%@", phone.trim()))
            {
                UIApplication.shared.open(url, options: [:]) { success in
                    if let cb = completion
                    {
                        cb(success)
                    }
                }
            }
            else
            {
                if let cb = completion
                {
                    cb(false)
                }
            }
        }
        else
        {
            if let cb = completion
            {
                cb(false)
            }
        }
    }
    
    ///使用系统信息发送短信，可以传入手机号码
    func sendSystemSms(_ phone: String, completion: ((_ success: Bool) -> Void)? = nil)
    {
        if g_validString(phone.trim())
        {
            if let url = URL(string: String(format: "sms://%@", phone.trim()))
            {
                UIApplication.shared.open(url, options: [:]) { success in
                    if let cb = completion
                    {
                        cb(success)
                    }
                }
            }
            else
            {
                if let cb = completion
                {
                    cb(false)
                }
            }
        }
        else
        {
            if let cb = completion
            {
                cb(false)
            }
        }
    }
    
    ///发送自定义信息
    func sendCustomSms(phones: [String], message: String, subject: String? = nil, completion: ((_ result: MessageComposeResult) -> Void)? = nil)
    {
        if MFMessageComposeViewController.canSendText()
        {
            let vc = MFMessageComposeViewController()
            //信息内容
            vc.body = message
            //收件人列表
            vc.recipients = phones
            //主题
            if MFMessageComposeViewController.canSendSubject()
            {
                if let subject = subject {
                    vc.subject = subject
                }
            }
            //设置代理
            vc.messageComposeDelegate = self
            //设置回调，发送完信息后调用
            self.customSmsCompletionCallback = completion
            g_topVC().present(vc, animated: true)
        }
        else
        {
            if let completion = completion {
                completion(.failed)
            }
        }
    }
    
    ///使用系统邮件发送邮件
    func sendSystemMail(_ mailto: String, completion: ((_ success: Bool) -> Void)? = nil)
    {
        if DatasChecker.shared.checkMail(mailto.trim())
        {
            if let url = URL(string: String(format: "mailto://%@", mailto.trim()))
            {
                UIApplication.shared.open(url, options: [:]) { success in
                    if let cb = completion
                    {
                        cb(success)
                    }
                }
            }
            else
            {
                if let cb = completion
                {
                    cb(false)
                }
            }
        }
        else
        {
            if let cb = completion
            {
                cb(false)
            }
        }
    }
    
    ///发送自定义邮件
    ///参数：mails：收件人；cc：抄送；subject：主题；message：内容
    func sendCustomMail(mailto: [String], cc: [String]? = nil, subject: String, message: String, completion: ((_ result: MFMailComposeResult) -> Void)? = nil)
    {
        if MFMailComposeViewController.canSendMail()
        {
            let vc = MFMailComposeViewController()
            vc.setSubject(subject)
            vc.setMessageBody(message, isHTML: false)
            vc.setToRecipients(mailto)
            if let cc = cc {
                vc.setCcRecipients(cc)
            }
            vc.mailComposeDelegate = self
            self.customMailCompletionCallback = completion
            g_topVC().present(vc, animated: true)
        }
        else
        {
            if let completion = completion {
                completion(.failed)
            }
        }
    }
    
    
}
