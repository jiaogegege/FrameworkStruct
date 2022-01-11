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
protocol AlertManagerProtocol
{
    //要显示的弹框需要实现该方法，当管理器将弹框添加到控制器上时，会调用这个方法，弹框可根据实际情况进行显示的操作
    func show()
    
    //当某些弹框的优先级更高，需要优先显示时，会隐藏当前正在显示的弹框，这个方法告诉弹框做一些处理工作，隐藏后等待时间再次显示
    func hide()
    
    //移除弹框前，让弹框清理一些资源
    func dismiss()
    
}

class AlertManager: OriginManager
{
    //MARK: 属性
    //单例对象
    static let shared = AlertManager()
    
    //待显示的控制器队列
    let queue: FSQueue<UIViewController> = FSQueue()
    
    //本来显示但是被强制隐藏的控制器栈，当正在显示的弹框消失后，需要优先显示这里的弹框
    let stack: FSStack<UIViewController> = FSStack()
    
    
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
    
}


//接口方法
extension AlertManager: ExternalInterface
{
    //想要显示一个控制器，传入一个UIAlertController或UIViewController
    func wantPresent(vc: UIViewController)
    {
        
    }
    
}
