//
//  ToastManager.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2021/12/19.
//

/**
 * Toast管理器
 * 使用SVProgressHUD、MBProgressHUD或其他Toast组件
 * 默认，同时只能显示一个HUD，当一个HUD消失之后再显示另一个HUD，如果同时有多个HUD要显示，那么剩余的HUD放入队列中，直到前一个HUD消失
 * 也提供了直接显示HUD的方法，将会占据队列中HUD的位置直接插入到显示队列中，等其显示完毕在显示队列中的其他HUD
 */
import UIKit

class ToastManager: OriginManager
{
    //MARK: 属性
    //单例对象
    static let shared = ToastManager()
    
    //hud显示队列
    //存储hud，对hud进行统一管理，所有hud先进入这个队列，然后按顺序显示，当显示完一个之后，再显示另一个，直到队列被清空
    //实际存储的是操作闭包，当一个闭包执行时显示HUD，当HUD消失后，执行下一个闭包
    fileprivate let hudQueue: FSQueue<VoidClosure> = FSQueue()
    
    //临时保存正在显示的MB实例
    fileprivate(set) weak var tmpMBHUD: MBProgressHUD? = nil
    
    //HUD类型，目前支持`SVProgressHUD、MBProgressHUD`
    var hudType: TMHudType = .mbHud
    
    /**
     * HUD显示属性配置
     * 对于MB和SV，可配置属性有一些不同，这里列出共同可配置项，不可配置的项使用对应HUD的默认配置
     * 如果想要指定特定的HUD并配置属性，可以直接调用`custom`方法并传入闭包
     */
    //显示风格，默认黑底白字
    var style:TMShowStyle = .dark
    
    //内容区域是否有模糊效果，默认有(仅SV有效)
    var blur: Bool = true
    
    //内容文本的字体，使用对应组件默认字体即可
//    var font: UIFont = UIFont.systemFont(ofSize: 16)
    
    //内容颜色，包括文本和动画，默认白色，这个值和style对比
    var contentColor: UIColor = .white
    
    //背景颜色，默认透明黑色，这个值和style对应
    var backgroundColor: UIColor = UIColor(white: 0, alpha: 0.8)
    
    //转圈的风格，默认系统菊花
    var animateType: TMAnimationType = .activityIndicator
    
    //显示HUD时是否能操作后面的UI，默认不能操作
    var interaction: Bool = false
    
    //显示的最小时长
    var minTimeInterval: TimeInterval = 2.0
    
    //一个很久的时间
    let longDistanceFuture: TimeInterval = 999999999
    
    
    //MARK: 方法
    //私有化init方法
    private override init()
    {
        super.init()
        self.addNotification()
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
    
    //添加SV通知
    fileprivate func addNotification()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(svWillAppear(notify:)), name: NSNotification.Name.SVProgressHUDWillAppear, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(svDidAppear(notify:)), name: NSNotification.Name.SVProgressHUDDidAppear, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(svWillDisappear(notify:)), name: NSNotification.Name.SVProgressHUDWillDisappear, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(svDidDisappear(notify:)), name: NSNotification.Name.SVProgressHUDDidDisappear, object: nil)
    }
    
    //删除通知
    fileprivate func removeNotification()
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    //返回一个闭包，将要显示的hud参数都配置好，并不决定是否要显示这个hud，交给调用的方法处理
    fileprivate func createHudClosure(text: String? = nil,
                                      detail: String? = nil,
                                      animate: Bool = true,
                                      hideDelay:TimeInterval = 2.0,
                                      completion: CompletionCallback? = nil) -> VoidClosure
    {
         let closure = {[weak self] in
            if self?.hudType == .mbHud
            {
                let hud = MBProgressHUD.showAdded(to: g_window(), animated: true)
                self?.tmpMBHUD = hud
                hud.delegate = self
                hud.label.textColor = self?.contentColor
                hud.label.text = text
                hud.detailsLabel.textColor = self?.contentColor
                hud.detailsLabel.text = detail
                hud.bezelView.style = self?.style == .dark ? .solidColor : .blur
                hud.bezelView.backgroundColor = self?.backgroundColor
                hud.removeFromSuperViewOnHide = true
                hud.contentColor = self?.contentColor
                hud.mode = animate ? .indeterminate : .text
                if let inter = self?.interaction
                {
                    hud.isUserInteractionEnabled = !inter
                }
                if let callback = completion
                {
                    hud.completionBlock = callback
                }
                hud.hide(animated: true, afterDelay: (hideDelay < self!.generateShowTime(text: text, detail: detail) ? self!.generateShowTime(text: text, detail: detail) : hideDelay))
            }
            else
            {
                SVProgressHUD.setDefaultStyle(self?.style == .dark ? .dark : .light)
                SVProgressHUD.setMinimumDismissTimeInterval(self!.generateShowTime(text: text, detail: detail))
                SVProgressHUD.setMaximumDismissTimeInterval(hideDelay + self!.generateShowTime(text: text, detail: detail))
                if self?.blur == false
                {
                    SVProgressHUD.setDefaultStyle(.custom)
                    SVProgressHUD.setForegroundColor(self!.contentColor)
                    SVProgressHUD.setBackgroundColor(self!.backgroundColor)
                }
                SVProgressHUD.setDefaultAnimationType(self?.animateType == .activityIndicator ? .native : .flat)
                if let inter = self?.interaction
                {
                    SVProgressHUD.setDefaultMaskType(inter == false ? .clear : .none)
                }
                if animate
                {
                    SVProgressHUD.show(withStatus: text)
                }
                else
                {
                    //只显示文字的前提是注释了`SVProgressHUD.m`的422行
                    //因此，如果只显示文字，建议使用MB
                    SVProgressHUD.showInfo(withStatus: text)
                }
                SVProgressHUD.dismiss(withDelay: (hideDelay < self!.generateShowTime(text: text, detail: detail) ? self!.generateShowTime(text: text, detail: detail) : hideDelay), completion: completion)
            }
        }
        return closure
    }
    
    //显示HUD
    //如果传入参数，那么直接执行那个闭包
    //如果参数为空，那么从队列中取出闭包并执行
    fileprivate func show(_ closure: (()-> Void)? = nil)
    {
        if let clo = closure
        {
            clo()
            //显示hud后将状态设置为正在显示
            stMgr.set(true, key: TMStatusKey.isShowing)
        }
        else
        {
            //如果当前不在显示hud，那么可以显示下一个hud
            if let isShowing = stMgr.status(TMStatusKey.isShowing) as? Bool
            {
                if !isShowing
                {
                    if let closure = self.hudQueue.pop()
                    {
                        closure()
                        //显示hud后将状态设置为正在显示
                        stMgr.set(true, key: TMStatusKey.isShowing)
                    }
                }
            }
            else    //还没有显示过，那么可以显示
            {
                if let closure = self.hudQueue.pop()
                {
                    closure()
                    //显示hud后将状态设置为正在显示
                    stMgr.set(true, key: TMStatusKey.isShowing)
                }
            }
        }
    }
    
    //计算toast文本显示时长，默认有一个最小时间，用户可以传入一个特定时间，如果不传，根据文本长度计算显示时长，最小不小于默认最小时间
    fileprivate func generateShowTime(text: String?, detail: String?) -> TimeInterval
    {
        if text == nil && detail == nil     //都没有值的时候返回最小时间
        {
            return self.minTimeInterval
        }
        //计算文本长度
        var tx: String = ""
        if let text = text {
            tx += text
        }
        if let detail = detail {
            tx += detail
        }
        
        return maxBetween(Double(tx.count) * 0.06 + 0.5, self.minTimeInterval) //计算动态时间和最小时间的较大值
    }
    
    //析构方法，理论上永远不会执行
    deinit {
        self.removeNotification()
    }
    
}


/**
 * HUD通知和代理方法
 * SV有通知和`completion`
 * MB有`delegate`和`completionBlock`
 */
extension ToastManager: DelegateProtocol, MBProgressHUDDelegate
{
    //MBProgressHUD消失后清理一些资源
    func hudWasHidden(_ hud: MBProgressHUD)
    {
        hud.delegate = nil
        hud.completionBlock = nil
        if hud.isEqual(self.tmpMBHUD)
        {
            self.tmpMBHUD = nil
            //状态设置为不在显示hud
            stMgr.set(false, key: TMStatusKey.isShowing)
        }
        
        //尝试显示下一个闭包，如果有的话
        self.show()
    }
    
    //SV将要显示
    @objc fileprivate func svWillAppear(notify: Notification)
    {
        if let userInfo = notify.userInfo
        {
            print(userInfo[SVProgressHUDStatusUserInfoKey] as Any)
        }
        //状态设置为正在显示hud
        stMgr.set(true, key: TMStatusKey.isShowing)
    }
    
    //SV已经显示
    @objc fileprivate func svDidAppear(notify: Notification)
    {
        if let userInfo = notify.userInfo
        {
            print(userInfo[SVProgressHUDStatusUserInfoKey] as Any)
        }
    }
    
    //SV将要消失
    @objc fileprivate func svWillDisappear(notify: Notification)
    {
        if let userInfo = notify.userInfo
        {
            print(userInfo[SVProgressHUDStatusUserInfoKey] as Any)
        }
    }
    
    //SV已经消失
    @objc fileprivate func svDidDisappear(notify: Notification)
    {
        if let userInfo = notify.userInfo
        {
            print(userInfo[SVProgressHUDStatusUserInfoKey] as Any)
        }
        //状态设置为不在显示hud
        stMgr.set(false, key: TMStatusKey.isShowing)
        
        //尝试显示下一个闭包，如果有的话
        self.show()
    }
    
}


/**
 * 内部类型
 */
extension ToastManager: InternalType
{
    //状态key
    enum TMStatusKey: SMKeyType {
        case isShowing  //是否在显示HUD:true/false
    }
    
    //使用HUD的类型
    enum TMHudType
    {
        case mbHud  //MBProgressHUD，默认
        case svHud  //SVProgressHUD
    }
    
    //显示模式，并行或者串行
    //如果不明确指定显示模式，那么使用串行，如果设置并行，只在那一次设置的时候有效
    enum TMShowMode
    {
        case serial //串行，同时只能显示一个hud，默认模式，并且推荐使用该方式
        case concurrent //并行，同时可显示多个hud，不推荐，多个hud同时显示会造成干扰和不可预见的情况
    }
    
    //显示风格，白底黑字或者黑底白字
    enum TMShowStyle
    {
        case dark   //黑底白字
        case light  //白底黑字
    }
    
    //转圈的风格
    enum TMAnimationType
    {
        case activityIndicator  //系统自带菊花
        case indefiniteRing     //无限转圈圆环，仅SV有
    }
    
    //完成回调的类型
    typealias CompletionCallback = VoidClosure
    
}


/**
 * 外部接口方法
 * 当外部程序要使用该类的功能时，调用这里的方法
 */
extension ToastManager: ExternalInterface
{
    //只显示一个文本，一段时间后消失
    func wantShowText(_ text: String)
    {
        self.wantShow(text: text, animate: false)
    }
    
    //只显示一个文本，一段时间后消失，并执行一个回调
    func wantShowText(text: String, completion: @escaping CompletionCallback)
    {
        self.wantShow(text: text, animate: false, completion: completion)
    }
    
    //只显示一个文本，设置一段时间后消失，并执行一个回调
    func wantShowText(text:String, hideDelay: TimeInterval, completion: CompletionCallback? = nil)
    {
        self.wantShow(text: text, animate: false, hideDelay: hideDelay, completion: completion)
    }
    
    //显示一个带动画的文字，不消失
    func wantShowTextAnimate(_ text: String)
    {
        self.wantShow(text: text, hideDelay: self.longDistanceFuture)
    }
    
    //只显示一个动画，不消失，一般用于请求接口的时候
    //mode：是否可和其他HUD同时显示，默认不可以，如果想要立即显示这个HUD，可以先隐藏现有的hud再调用这个方法
    func wantShowAnimate(mode: TMShowMode = .serial)
    {
        self.wantShow(hideDelay: self.longDistanceFuture, mode: mode)
    }

    /**
     * 显示一个hud，会生成一个闭包放到队列中，然后按顺序显示
     * - Parameters:
     *  - text: 主要文本，默认空字符串
     *  - detail:详细文本(仅MB，SV忽略)，默认空字符串
     *  - animate:是否有转圈动画
     *  - hideDelay:延迟多少秒后消失，最小2.0
     *  - mode:显示模式，默认串行
     *  - completion:HUD消失之后执行的回调
     */
    func wantShow(text: String? = nil, detail: String? = nil, animate: Bool = true, hideDelay:TimeInterval = 2.0, mode: TMShowMode = .serial, completion: CompletionCallback? = nil)
    {
        let closure = self.createHudClosure(text: text, detail: detail, animate: animate, hideDelay: hideDelay, completion: completion)
        if mode == .serial  //串行，进入队列
        {
            self.hudQueue.push(closure)
            //尝试执行一次显示HUD
            self.show()
        }
        else    //并行，直接执行
        {
            self.show(closure)
        }
    }
    
    /**
     * 直接显示一个HUD，不放入队列中
     * 建议少用，当直接显示hud时会阻碍队列中其他hud的显示，直到该hud消失
     * 如果一定要直接显示，建议使用MB，因为SV都是静态方法，无法获取实例，多个hud之间会产生干扰
     * - Parameters:
     *  - text: 主要文本，默认空字符串
     *  - detail:详细文本(仅MB，SV忽略)，默认空字符串
     *  - animate:是否有转圈动画
     *  - hideDelay:延迟多少秒后消失，最小2.0
     *  - completion:HUD消失之后执行的回调
     */
    func directShow(text: String? = nil, detail: String? = nil, animate: Bool = true, hideDelay: TimeInterval = 2.0, completion: CompletionCallback? = nil)
    {
        self.wantShow(text: text, detail: detail, animate: animate, hideDelay: hideDelay, mode: .concurrent, completion: completion)
    }
    
    /**
     * 显示自定义HUD，放入队列中
     * 外部程序可以在参数闭包中自定义一个MB或者SV，设置好各项参数并显示
     * 所有自定义代码都会放入闭包队列中，然后尝试执行
     */
    func wantShowCustom(closure: @escaping VoidClosure)
    {
        self.hudQueue.push(closure)
        self.show()
    }
    
    /**
     * 直接显示一个自定义HUD，不进入队列
     */
    func directShowCustom(closure: @escaping VoidClosure)
    {
        self.show(closure)
    }
    
    //让一个HUD手动消失
    func hideHUD()
    {
        if self.hudType == .mbHud
        {
            if let hud = self.tmpMBHUD
            {
                hud.hide(animated: true)
            }
            else
            {
                MBProgressHUD.hide(for: g_window(), animated: true)
            }
        }
        else
        {
            SVProgressHUD.dismiss()
        }
    }
    
}
