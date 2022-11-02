//
//  FSDialog.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/1/14.
//

/**
 * 所有可以被DialogManager管理的类都要继承这个类
 * 主要针对全屏幕覆盖，带有半透明背景的弹窗
 * 可以是显示在屏幕中间，或从底部往上弹，或从上往下弹，或者其他。根据实际需要实现
 *
 * - note: 子类建议以`Dialog`结尾
 *
 */
import UIKit

class FSDialog: UIView, DialogManagerProtocol
{
    //MARK: 属性
    /**************************************** 接口属性 Section Begin ****************************************/
    //遵循DialogManagerProtocol协议，提供属性
    var showCallback: VoidClosure?
    var hideCallback: VoidClosure?
    var dismissCallback: VoidClosure?
    
    //背景颜色，默认黑色50%透明度
    var bgColor: UIColor = .cBlack_50Alpha {
        willSet {
            self.bgView.backgroundColor = newValue
        }
    }
    
    //是否可以点击背景蒙层关闭view
    var isTapDismissEnabled: Bool = false {
        willSet {
            self.tapGesture.isEnabled = newValue
        }
    }
    
    //宿主view，默认全局UIWindow，如果在`show()`的时候指定了hostView，那么该属性不起作用
    var hostView: UIView = g_window()
    
    //显示消失的动画效果类型
    //如果子类覆写了`showAnimation`等动画方法，其优先级高于该属性
    var showType: FSDShowType = .gradient
    
    //show时的动画时长
    var animateInterval: TimeInterval = 0.25
    
    //主题色
    var themeColor: UIColor = ThemeManager.shared.getCurrentTheme().mainColor
    
    /**************************************** 接口属性 Section End ****************************************/
    
    ///UI组件
    fileprivate var bgView: UIView! //背景蒙层，一般是半透明
    var containerView: UIView!  //放置内容部分的容器视图
    
    fileprivate var tapGesture: UITapGestureRecognizer!     //背景点击手势
    

    //MARK: 方法
    //初始化方法，参数随便传，大小永远是整个屏幕大
    override init(frame: CGRect = .zero) {
        super.init(frame: .fullScreen)
        self.initData()
        self.createView()
        self.configView()
    }
    
    //初始化数据
    //子类可以覆写该方法，并且要调用父类方法
    func initData()
    {
        
    }
    
    //这里会创建bgView和containerView
    //子类可以覆写这个方法，并且要调用父类方法
    override func createView()
    {
        self.bgView = UIView()
        self.addSubview(bgView)
        
        self.containerView = UIView()
        self.addSubview(containerView)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(bgTapAction(sender:)))
        tapGesture.isEnabled = self.isTapDismissEnabled
        self.bgView.addGestureRecognizer(tapGesture)
    }
    
    //配置view
    //子类可以覆写该方法，并且要调用父类方法
    override func configView()
    {
        bgView.frame = self.bounds
        bgView.backgroundColor = self.bgColor
        
        containerView.backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //手势点击动作
    @objc func bgTapAction(sender: UIGestureRecognizer)
    {
        self.dismiss()
    }
    
    //设置成初始状态，隐藏containerView并根据需要调整位置和大小，bgView透明度0
    //子类可以覆写这个方法，根据具体需要调用父类方法
    func resetOrigin()
    {
        self.isHidden = true
        self.bgView.alpha = 0.0
        if showType == .none
        {
            self.containerView.alpha = 0.0
        }
        else if showType == .gradient
        {
            self.containerView.alpha = 0.0
        }
        else if showType == .bounce
        {
            self.containerView.y = self.height
        }
    }
    
    //显示动画
    //子类可以覆写这个方法，根据具体需要调用父类方法
    func showAnimation(completion: @escaping VoidClosure)
    {
        self.isHidden = false
        weak var weakSelf = self
        if showType == .none
        {
            self.bgView.alpha = 1.0
            self.containerView.alpha = 1.0
            completion()
        }
        else if showType == .gradient
        {
            UIView.animate(withDuration: self.animateInterval, delay: 0.0, options: .curveEaseOut) {
                weakSelf?.bgView.alpha = 1.0
                weakSelf?.containerView.alpha = 1.0
            } completion: { finished in
                completion()
            }
        }
        else if showType == .bounce
        {
            UIView.animate(withDuration: self.animateInterval, delay: 0.0, options: .curveEaseOut) {
                weakSelf?.bgView.alpha = 1.0
                weakSelf?.containerView.y = weakSelf!.height - weakSelf!.containerView.height
            } completion: { finished in
                completion()
            }
        }
    }
    
    //隐藏动画
    //子类可以覆写这个方法，根据具体需要调用父类方法
    func hideAnimation(completion: @escaping VoidClosure)
    {
        weak var weakSelf = self
        if showType == .none
        {
            self.bgView.alpha = 0.0
            self.containerView.alpha = 0.0
            completion()
        }
        else if showType == .gradient
        {
            UIView.animate(withDuration: self.animateInterval, delay: 0.0, options: .curveEaseOut) {
                weakSelf?.bgView.alpha = 0.0
                weakSelf?.containerView.alpha = 0.0
            } completion: { finished in
                completion()
            }
        }
        else if showType == .bounce
        {
            UIView.animate(withDuration: self.animateInterval, delay: 0.0, options: .curveEaseOut) {
                weakSelf?.bgView.alpha = 0.0
                weakSelf?.containerView.y = weakSelf!.height
            } completion: { finished in
                completion()
            }

        }
    }
    
    //消失动画
    //子类可以覆写这个方法，根据具体需要调用父类方法
    func dismissAnimation(completion: @escaping VoidClosure)
    {
        weak var weakSelf = self
        if showType == .none
        {
            self.bgView.alpha = 0.0
            self.containerView.alpha = 0.0
            completion()
        }
        else if showType == .gradient
        {
            UIView.animate(withDuration: self.animateInterval, delay: 0.0, options: .curveEaseOut) {
                weakSelf?.bgView.alpha = 0.0
                weakSelf?.containerView.alpha = 0.0
            } completion: { finished in
                completion()
            }
        }
        else
        {
            UIView.animate(withDuration: self.animateInterval, delay: 0.0, options: .curveEaseOut) {
                weakSelf?.bgView.alpha = 0.0
                weakSelf?.containerView.y = weakSelf!.height
            } completion: { finished in
                completion()
            }
        }
    }
    
    deinit {
        if let callback = self.dismissCallback
        {
            callback()
        }
        FSLog("\(self.className) dealloc")
    }
    
}


//内部类型
extension FSDialog
{
    //显示类型，主要控制显示和消失的动画效果
    //子类可以自定义动画效果，自定义动画效果优先级高于该属性
    enum FSDShowType {
        case none           //无动画效果
        case gradient       //该类型一般用于显示在屏幕中间，做一个渐显的动画效果
        case bounce         //该类型一般用于显示在屏幕底部，做一个向上弹的动画效果
    }
    
}


//接口方法
extension FSDialog
{
    //子类根据需要覆写这个方法，默认添加在全局window上
    func show(_ hostView: UIView?)
    {
        self.resetOrigin()
        //计算hostView
        var hv: UIView
        if let host = hostView {
            hv = host
        }
        else {
            hv = self.hostView
        }
        hv.addSubview(self)
        //执行显示动画
        weak var weakSelf = self
        self.showAnimation {
            if let cb = weakSelf?.showCallback
            {
                cb()
            }
        }
    }
    
    //子类根据需要覆写这个方法
    func hide()
    {
        weak var weakSelf = self
        self.hideAnimation {
            weakSelf?.isHidden = true
            weakSelf?.removeFromSuperview()
            if let cb = weakSelf?.hideCallback
            {
                cb()
            }
        }
    }
    
    //子类根据需要覆写这个方法
    func dismiss()
    {
        weak var weakSelf = self
        self.dismissAnimation {
            weakSelf?.isHidden = true
            weakSelf?.removeFromSuperview()
            if let cb = weakSelf?.dismissCallback
            {
                cb()
            }
        }
    }
    
}
