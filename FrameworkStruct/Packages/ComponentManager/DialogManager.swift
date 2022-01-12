//
//  DialogManager.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/1/9.
//

/**
 * 用于各种自定义弹窗的显示和生命周期管理
 */
import UIKit

//想要在管理器中显示的弹窗需要实现该协议中的方法
protocol DialogManagerProtocol
{
    //要显示的弹框需要实现该方法，当管理器将弹框添加到控制器上时，会调用这个方法，弹框可根据实际情况进行显示的操作
    func show()
    
    //当某些弹框的优先级更高，需要优先显示时，会隐藏当前正在显示的弹框，这个方法告诉弹框做一些处理工作，隐藏后等待时间再次显示
    func hide()
    
    //移除弹框前，让弹框清理一些资源
    func dismiss()
    
}

class DialogManager: OriginManager
{
    //MARK: 属性
    //单例对象
    static let shared = DialogManager()
    
    
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
