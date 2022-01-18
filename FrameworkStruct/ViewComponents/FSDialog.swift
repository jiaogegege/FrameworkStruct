//
//  FSDialog.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/1/14.
//

/**
 * 所有可以被DialogManager管理的类都要继承这个类
 * 主要针对全屏幕覆盖，带有半透明背景的弹窗
 */
import UIKit

class FSDialog: UIView, DialogManagerProtocol
{
    //MARK: 属性
    //遵循DialogManagerProtocol协议，提供属性
    var showCallback: VoidClosure?
    var hideCallback: VoidClosure?
    var dismissCallback: VoidClosure?
    
    //背景颜色，默认黑色50%透明度
    var bgColor: UIColor = UIColor(white: 0, alpha: 0.5) {
        willSet {
            self.bgView.backgroundColor = newValue
        }
    }
    //show时的动画时长
    var animateInterval: TimeInterval = 0.25
    //主题色
    var themeColor: UIColor = ThemeManager.shared.getCurrentTheme().mainColor
    
    //UI组件
    var bgView: UIView! //背景蒙层，一般是半透明
    var containerView: UIView!  //放置内容部分的容器视图
    

    //MARK: 方法
    //初始化方法，参数随便传，大小永远是整个屏幕大
    override init(frame: CGRect = .zero) {
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: kScreenWidth, height: kScreenHeight))
        self.createView()
        self.configView()
        self.initData()
    }
    
    //这里会创建bgView和containerView
    //子类可以覆写这个方法，并且要调用父类方法
    override func createView()
    {
        self.bgView = UIView()
        self.addSubview(bgView)
        
        self.containerView = UIView()
        self.addSubview(containerView)
    }
    
    //配置view
    //子类可以覆写该方法，并且要调用父类方法
    override func configView()
    {
        bgView.frame = self.bounds
        bgView.backgroundColor = self.bgColor
    }
    
    //初始化数据
    //子类可以覆写该方法，并且要调用父类方法
    func initData()
    {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //设置成初始状态，隐藏containerView并根据需要调整位置和大小，bgView透明度0
    //子类可以覆写这个方法，根据具体需要调用父类方法
    func resetOrigin()
    {
        self.isHidden = true
        self.bgView.alpha = 0.0
    }
    
    //显示动画
    //子类可以覆写这个方法，根据具体需要调用父类方法
    func showAnimation(completion: @escaping VoidClosure)
    {
        self.isHidden = false
        weak var weakSelf = self
        UIView.animate(withDuration: self.animateInterval, delay: 0.0, options: .curveEaseOut) {
            weakSelf?.bgView.alpha = 1.0
            weakSelf?.containerView.alpha = 1.0
        } completion: { finished in
            completion()
        }
    }
    
    //隐藏动画
    //子类可以覆写这个方法，根据具体需要调用父类方法
    func hideAnimation(completion: @escaping VoidClosure)
    {
        weak var weakSelf = self
        UIView.animate(withDuration: self.animateInterval, delay: 0.0, options: .curveEaseOut) {
            weakSelf?.bgView.alpha = 0.0
            weakSelf?.containerView.alpha = 0.0
        } completion: { finished in
            completion()
        }
    }
    
    //消失动画
    //子类可以覆写这个方法，根据具体需要调用父类方法
    func dismissAnimation(completion: @escaping VoidClosure)
    {
        weak var weakSelf = self
        UIView.animate(withDuration: self.animateInterval, delay: 0.0, options: .curveEaseOut) {
            weakSelf?.bgView.alpha = 0.0
            weakSelf?.containerView.alpha = 0.0
        } completion: { finished in
            completion()
        }

    }
    
    deinit {
        if let callback = self.dismissCallback
        {
            callback()
        }
        print("FSDialog: dealloc")
    }
    
}


//接口方法
extension FSDialog: ExternalInterface
{
    //子类根据需要覆写这个方法
    func show(hostView: UIView)
    {
        self.resetOrigin()
        //执行显示动画
        hostView.addSubview(self)
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
