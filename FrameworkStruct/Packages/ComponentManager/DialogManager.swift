//
//  DialogManager.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/1/9.
//

/**
 * 用于各种添加到UIWindow上的自定义全屏弹窗的显示和生命周期管理，本质上是UIView
 */
import UIKit

//想要在管理器中显示的弹窗需要实现该协议中的方法
@objc protocol DialogManagerProtocol
{
    //显示后执行这个回调
    var showCallback: VoidClosure? {get set}
    
    //隐藏后，执行这个回调通知管理器
    var hideCallback: VoidClosure? {get set}
    
    //消失后，执行这个回调通知管理器
    var dismissCallback: VoidClosure? {get set}
    
    //要显示的弹框需要实现该方法，当管理器将要显示弹窗时，会调用这个方法，弹窗可根据实际情况进行显示的操作；hostView一般是UIWindow
    func show(hostView: UIView)
    
    //当某些弹窗的优先级更高，需要优先显示时，会隐藏当前正在显示的弹窗，这个方法告诉弹窗做一些处理工作，隐藏后等待时间再次显示
    func hide()
    
    //移除弹窗前，让弹窗清理一些资源，比如释放回调，清空数据容器等，然后弹窗自己remove掉
    func dismiss()
    
}

class DialogManager: OriginManager
{
    //MARK: 属性
    //单例对象
    static let shared = DialogManager()
    
    //待显示队列
    fileprivate let queue: FSQueue<DMDialogType> = FSQueue()
    
    //本来显示但是被强制隐藏的弹窗栈，当正在显示的弹窗消失后，需要优先显示这里的弹窗
    fileprivate let stack: FSStack<DMDialogType> = FSStack()
    
    //当前正在显示的弹窗
    weak var showingView: DMDialogType? = nil
    
    
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
    
    //显示一个弹窗
    fileprivate func show(_ vieww: DMDialogType? = nil)
    {
        let hostView = g_getWindow()
        if let v = vieww //如果传入了参数，那么优先显示参数的view
        {
            if self.isShowing() //如果正在显示view，先隐藏
            {
                if let vi = self.showingView
                {
                    self.backup(vieww: vi)   //隐藏
                }
                v.show(hostView: hostView)
                self.showingView = v
                self.stMgr.setStatus(true, forKey: DMStatusKey.isShowing)
            }
            else    //当前没有显示view，直接显示参数的view
            {
                v.show(hostView: hostView)
                self.showingView = v
                self.stMgr.setStatus(true, forKey: DMStatusKey.isShowing)
            }
        }
        else    //没有传入view参数，那么去数据结构中获取view
        {
            if !self.isShowing()    //如果当前没有显示view，尝试显示一个view
            {
                //先恢复堆栈中的view
                if self.restore()
                {
                    //如果成功从堆栈中显示一个view，那么什么都不做，因为正在显示
                }
                else    //尝试从队列中显示一个view
                {
                    if let vi = self.queue.pop()
                    {
                        vi.show(hostView: hostView)
                        self.showingView = vi
                        self.stMgr.setStatus(true, forKey: DMStatusKey.isShowing)
                    }
                    else
                    {
                        //如果队列中也没有view，那么什么也不做，此时处于空闲状态
                    }
                }
            }
        }
    }
    
    //当前是否在显示view
    fileprivate func isShowing() -> Bool
    {
        if let isShowing = self.stMgr.status(forKey: DMStatusKey.isShowing) as? Bool
        {
            return isShowing
        }
        else    //如果还未赋值，那么说明还没有显示过view，返回false
        {
            return false
        }
    }
    
    //备份正在显示的view
    //当有优先级更高的view时，要先隐藏正在显示的
    //参数1:要隐藏的alert，参数2:隐藏成功后的操作
    fileprivate func backup(vieww: DMDialogType)
    {
        //先保存一下
        self.stack.push(vieww)
        //再隐藏
        vieww.hide()
    }
    
    //恢复一个view
    //返回值：是否成功恢复了一个view，如果返回true，那么不要检索队列；如果返回false，说明没有恢复一个view，去检索队列然后显示一个普通的view
    fileprivate func restore() -> Bool
    {
        //如果有
        if let vi = self.stack.pop()
        {
            vi.show(hostView: g_getWindow())
            //标记为正在显示
            self.showingView = vi
            stMgr.setStatus(true, forKey: DMStatusKey.isShowing)
            return true
        }
        return false
    }
    
    
}


//内部类型
extension DialogManager: InternalType
{
    //可以被DialogManager管理的类型
    typealias DMDialogType = UIView & DialogManagerProtocol
    
    //状态key
    enum DMStatusKey: SMKeyType
    {
        case isShowing  //是否在显示dialog：true/false
    }
    
    //优先级
    enum DMADialogPriority {
        case defalut    //一般的dialog，都用这个，也是默认值
        case high   //需要优先显示的dialog，会提前显示
    }

}


//接口方法
extension DialogManager: ExternalInterface
{
    //想要显示一个view
    func wantShow(vi: DMDialogType, priority: DMADialogPriority = .defalut)
    {
        vi.showCallback = {() in
            
        }
        vi.hideCallback = {() in
            
        }
        vi.dismissCallback = {[weak self] () in
            //消失后，尝试显示下一个view
            self?.showingView = nil
            self?.stMgr.setStatus(false, forKey: DMStatusKey.isShowing)
            self?.show()
        }
        if priority == .high
        {
            self.show(vi)
        }
        else
        {
            self.queue.push(vi)
            self.show()
        }
    }
    
    //将当前显示的弹窗消失掉
    func dismiss()
    {
        if let vi = self.showingView
        {
            vi.dismiss()
        }
    }
    
    /**
     * 显示弹窗，这里只是举例演示，对于具体的弹窗，要写具体的方法，因为参数不一样，比如有按钮的弹窗需要传入回调
     */
    //想要显示一个dialog
    func wantShowCustom(vi: DMDialogType)
    {
        self.wantShow(vi: vi)
    }
    
    //直接显示一个dialog
    func directShowCustom(vi: DMDialogType)
    {
        self.wantShow(vi: vi, priority: .high)
    }
    
    ///想要显示青少年模式弹窗
    func wantShowTeenMode(enter:@escaping VoidClosure, confirm:@escaping VoidClosure)
    {
        let v = TeenagerModeDialog(frame: .zero)
        weak var weakObj = v
        v.enterTeenModeCallback = {() in
            weakObj?.dismiss()
            enter()
        }
        v.confirmCallback = {() in
            weakObj?.dismiss()
            confirm()
        }
        self.wantShow(vi: v)
    }
    
}
