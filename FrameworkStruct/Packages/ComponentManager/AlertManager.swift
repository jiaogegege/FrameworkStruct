//
//  AlertManager.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2021/12/19.
//

/**
 * 系统弹框管理器
 * 包括UIAlertController和`present`显示的控制器
 * UIAlertController被添加到最顶层的控制器或者根控制器上，也可以传入自定义控制器
 */
import UIKit

//想要在管理器中显示的弹窗需要实现该协议中的方法
@objc protocol AlertManagerProtocol
{
    //alert消失后，执行这个回调通知管理器
    var dismissCallback: ((_ alert: UIViewController) -> Void) {get set}
    
}

class AlertManager: OriginManager
{
    //MARK: 属性
    //单例对象
    static let shared = AlertManager()
    
    //待显示的控制器队列
    fileprivate let queue: FSQueue<UIViewController> = FSQueue()
    
    //本来显示但是被强制隐藏的控制器栈，当正在显示的弹框消失后，需要优先显示这里的弹框
    fileprivate let stack: FSStack<UIViewController> = FSStack()
    
    //当前正在显示的alert
    weak var showingAlert: UIViewController? = nil
    
    
    //MARK: 方法
    //私有化init方法
    private override init()
    {
        super.init()
    }
    
    //重写复制方法
    override func copy() -> Any
    {
        return self
    }
        
    //重写复制方法
    override func mutableCopy() -> Any
    {
        return self
    }
    
    //present控制器
    //如果传入参数，那么隐藏正在显示的控制器，并直接显示参数中的控制器
    //如果参数为空，那么从队列中取出控制器并显示
    fileprivate func present(_ alertVC: UIViewController? = nil)
    {
        let topVC = ControllerManager.shared.topVC
        if let vc = alertVC //如果传入了参数，那么优先显示参数的alert
        {
            //判断当前是否在显示alert
            if self.isShowing()
            {
                //如果正在显示alert，先隐藏
                if let alert = self.showingAlert
                {
                    self.backup(alert: alert) {
                        //隐藏完成后，显示新的alert
                        topVC.present(vc, animated: true, completion: nil)
                        self.showingAlert = vc
                        self.stMgr.setStatus(true, forKey: AMStatusKey.isShowing)
                    }
                }
                else    //如果没有正在显示的alert，直接显示，理论上这里不该执行
                {
                    topVC.present(vc, animated: true, completion: nil)
                    self.showingAlert = vc
                    self.stMgr.setStatus(true, forKey: AMStatusKey.isShowing)
                }
            }
            else    //当前没有显示alert，直接显示参数的alert
            {
                topVC.present(vc, animated: true, completion: nil)
                self.showingAlert = vc
                self.stMgr.setStatus(true, forKey: AMStatusKey.isShowing)
            }
        }
        else    //没有传入alertVC参数，那么去数据结构中获取alert
        {
            if !self.isShowing()    //如果当前没在显示alert，那么尝试显示一个alert
            {
                //如果没有正在显示的alert，去堆栈和队列中获取
                if self.restore()   //优先从堆栈中获取
                {
                    //如果成功从堆栈中显示一个alert，那么什么都不做，因为正在显示
                }
                else    //尝试从队列中显示一个alert
                {
                    if let alert = self.queue.pop()
                    {
                        topVC.present(alert, animated: true, completion: nil)
                        self.showingAlert = alert
                        self.stMgr.setStatus(true, forKey: AMStatusKey.isShowing)
                    }
                    else
                    {
                        //如果队列中也没有alert，那么什么也不做，此时处于空闲状态
                    }
                }
            }
        }
    }
    
    //当前是否在显示alert
    fileprivate func isShowing() -> Bool
    {
        if let isShowing = self.stMgr.status(forKey: AMStatusKey.isShowing) as? Bool
        {
            return isShowing
        }
        else    //如果还未赋值，那么说明还没有显示过alert，返回false
        {
            return false
        }
    }
    
    //备份正在显示的alert
    //备份有两种情况：1.主动present一个VC；2.有优先级更高的alert要显示
    //参数1:要隐藏的alert，参数2:隐藏成功后的操作
    fileprivate func backup(alert: UIViewController, completion: (() -> Void)? = nil)
    {
        //先保存一下
        self.stack.push(alert)
        //再隐藏
        assert(alert.presentingViewController != nil, "Present父控制器为空，请debug")
        if let parent = alert.presentingViewController
        {
            weak var weakSelf = self
            parent.dismiss(animated: false) {
                weakSelf?.showingAlert = nil
                weakSelf?.stMgr.setStatus(false, forKey: AMStatusKey.isShowing)
                if let comp = completion
                {
                    comp()
                }
            }
        }
        else    //理论上不应该执行以下代码，如果执行了，那么需要debug
        {
            if let comp = completion
            {
                comp()
            }
        }
    }
    
    //恢复一个alert
    //返回值：是否成功恢复了一个alert，如果返回true，那么不要检索队列；如果返回false，说明没有恢复一个alert，去检索队列然后显示一个普通的alert
    fileprivate func restore() -> Bool
    {
        //如果有
        if let alert = self.stack.pop()
        {
            ControllerManager.shared.topVC.present(alert, animated: true, completion: nil)
            //标记为正在显示
            self.showingAlert = alert
            stMgr.setStatus(true, forKey: AMStatusKey.isShowing)
            return true
        }
        return false
    }
    
}


//接口方法
extension AlertManager: ExternalInterface
{
    //想要显示一个控制器，传入一个UIAlertController或UIViewController，并且遵循协议
    //优先级默认
    func wantPresent<T: UIViewController>(vc: T, priority: AMAlertPriority = .defalut) where T: AlertManagerProtocol
    {
        //给vc添加一个消失的回调
        vc.dismissCallback = {[weak self](alert) in
            self?.showingAlert = nil
            self?.stMgr.setStatus(false, forKey: AMStatusKey.isShowing)
            //消失后尝试显示一个alert
            self?.present()
        }
        if priority == .high
        {
            //如果是高优先级，直接显示
            self.present(vc)
        }
        else
        {
            self.queue.push(vc) //先添加到队列中
            self.present()  //尝试显示一个alert
        }
    }
    
    /**
     * 想要显示一个CKAlertView
     * - parameters:
     *  - title:大标题
     *  - message:具体内容
     *  - messageAlign:对齐方式
     *  - leftTitle:左边按钮标题，默认·取消·，传nil则不创建按钮
     *  - rightTitle:右边按钮标题，默认·确定·，传nil则不创建按钮
     */
    func wantPresentAlert(title: String? = nil,
                          message: String? = nil,
                          messageAlign: NSTextAlignment = .center,
                          leftTitle: String? = String.sCancel,
                          leftBlock: (() -> Void)? = nil,
                          rightTitle: String? = String.sConfirm,
                          rightBlock: (() -> Void)? = nil)
    {
        var ident = ""
        if let ti = title
        {
            ident += ti
        }
        if let me = message
        {
            ident += me
        }
        if let lt = leftTitle
        {
            ident += lt
        }
        if let rt = rightTitle
        {
            ident += rt
        }
        let alert = CKAlertView(title: title, message: message, messageAlign: messageAlign, identifierKey: ident, tintColor: UIColor.cAccent!, cancelTitle: leftTitle, cancel: { action in
            if let block = leftBlock
            {
                block()
            }
        }, confirmTitle: rightTitle, confirmBlock: { action in
            if let block = rightBlock
            {
                block()
            }
        }, in: nil) as! AlertManagerProtocol
        self.wantPresent(vc: alert)
    }
    
    //想要显示一个照片选择弹框
    func wantPresentPhotoSelect()
    {
        
    }
    
    //想要显示一个CKActionSheet
    func wantPresentSheet()
    {
        
    }
    
}


//内部类型
extension AlertManager: InternalType
{
    //状态key
    enum AMStatusKey: SMKeyType
    {
        case isShowing  //是否在显示alert：true/false
    }
    
    //优先级
    enum AMAlertPriority {
        case defalut    //一般的alert，都用这个，也是默认值
        case high   //需要优先显示的alert，会提前显示
    }

}
