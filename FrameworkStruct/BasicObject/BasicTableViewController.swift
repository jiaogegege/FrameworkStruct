//
//  BasicTableViewController.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/12/8.
//

import UIKit

class BasicTableViewController: UITableViewController
{
    //MARK: 属性
    //获取当前主题
    var theme = ThemeManager.shared.getCurrentTheme()
    
    //返回按钮样式
    var backStyle: VCBackStyle = .dark {
        didSet {
            setBackStyle()
        }
    }
    
    //是否支持侧滑返回，默认true
    var canLeftSlideBack: Bool = true {
        didSet {
            setLeftSlideBack()
        }
    }
    
    //设置背景色
    var backgroundStyle: VCBackgroundStyle = .none {
        didSet {
            setBackgroundColor()
        }
    }
    
    //设置导航栏是否透明，默认不透明
    var navAlpha: Bool = false {
        didSet {
            setNavAlpha()
        }
    }
    
    //导航栏背景色
    var navBackgroundColor: UIColor? = nil {
        didSet {
            setNavBackgroundColor()
        }
    }
    
    //设置是否隐藏导航栏底部横线
    var hideNavBottomLine: Bool = true {
        didSet {
            setHiddenNavBottomLine()
        }
    }
    
    //设置标题颜色
    var navTitleColor: UIColor? = nil {
        didSet {
            setNavTitleColor()
        }
    }
    
    
    //MARK: 方法
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.createUI()
        self.configUI()
        self.initData()
        self.updateUI()
        self.addNotification()
    }
    
    //创建界面，一般用来创建界面组件
    //如果子类覆写这个方法，需要调用父类方法
    func createUI()
    {
        //返回按钮样式
        self.setBackStyle()
        //侧滑返回
        self.setLeftSlideBack()
        //背景色
        self.setBackgroundColor()
        //导航栏透明
        self.setNavAlpha()
        //导航栏背景色
        self.setNavBackgroundColor()
        //隐藏导航栏底部横线
        self.setHiddenNavBottomLine()
        //导航标题颜色
        self.setNavTitleColor()
    }
    
    //配置界面，用来设置界面组件，比如frame，约束，颜色等
    //如果子类覆写这个方法，需要调用父类方法
    func configUI()
    {
        self.themeConfigUI(theme: self.theme)
    }
    
    //更新界面，一般是更新界面上的一些数据
    //如果子类覆写这个方法，需要调用父类方法
    func updateUI()
    {
        
    }
    
    //初始化控制器数据，比如一些状态和变量
    //如果子类覆写这个方法，需要调用父类方法
    func initData()
    {
        
    }
    
    //设置返回按钮样式
    fileprivate func setBackStyle()
    {
        switch self.backStyle
        {
        case .dark:
            let backItem = UIBarButtonItem(image: UIImage.iBackDark?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backAction(sender:)))
            let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            spaceItem.width = -10
            self.navigationItem.leftBarButtonItems = [backItem]
        case .light:
            let backItem = UIBarButtonItem(image: UIImage.iBackLight?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backAction(sender:)))
            let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            spaceItem.width = -10
            self.navigationItem.leftBarButtonItems = [backItem]
        case .close:
            let backItem = UIBarButtonItem(image: UIImage.iBackClose?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backAction(sender:)))
            let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            spaceItem.width = -10
            self.navigationItem.leftBarButtonItems = [backItem]
        case .none:
            self.navigationItem.hidesBackButton = true
            self.navigationItem.leftBarButtonItems = []
        }
    }
    
    //返回按钮事件
    @objc func backAction(sender: UIBarButtonItem)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    //设置是否侧滑返回
    fileprivate func setLeftSlideBack()
    {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = canLeftSlideBack
        if self.canLeftSlideBack
        {
            weak var weakSelf = self
            self.navigationController?.interactivePopGestureRecognizer?.delegate = weakSelf
        }
    }
    
    //设置背景色
    fileprivate func setBackgroundColor()
    {
        switch self.backgroundStyle
        {
        case .clear:
            self.view.backgroundColor = .clear
        case .black:
            self.view.backgroundColor = .black
        case .white:
            self.view.backgroundColor = .white
        case .lightGray:
            self.view.backgroundColor = .cGrayf4f4f4
        case .pink:
            self.view.backgroundColor = .cPinkff709b
        case .none:
            break
        }
    }
    
    //设置导航栏是否透明
    fileprivate func setNavAlpha()
    {
        if self.navAlpha
        {
            if #available(iOS 15.0, *)
            {
                let barAppearance = UINavigationBarAppearance()
                barAppearance.backgroundColor = UIColor.clear
                barAppearance.backgroundEffect = nil;
                barAppearance.shadowColor = nil;
                self.navigationController?.navigationBar.scrollEdgeAppearance = barAppearance
                self.navigationController?.navigationBar.standardAppearance = barAppearance
            }
            else
            {
                self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
                self.navigationController?.navigationBar.shadowImage = UIImage()
            }
        }
        else
        {
            if #available(iOS 15.0, *)
            {
                let barAppearance = UINavigationBarAppearance()
                barAppearance.backgroundColor = self.navBackgroundColor
                barAppearance.shadowColor = self.navBackgroundColor
                self.navigationController?.navigationBar.scrollEdgeAppearance = barAppearance
                self.navigationController?.navigationBar.standardAppearance = barAppearance
            }
            else
            {
                self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
                self.navigationController?.navigationBar.shadowImage = nil
            }
        }
    }
    
    //设置导航栏背景色
    fileprivate func setNavBackgroundColor()
    {
        if #available(iOS 15.0, *)
        {
            self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = self.navBackgroundColor
            self.navigationController?.navigationBar.standardAppearance.backgroundColor = self.navBackgroundColor
        }
        else
        {
            self.navigationController?.navigationBar.barTintColor = self.navBackgroundColor
            self.navigationController?.navigationBar.tintColor = self.navBackgroundColor
        }
    }
    
    //设置导航栏是否隐藏底部横线
    fileprivate func setHiddenNavBottomLine()
    {
        if self.hideNavBottomLine
        {
            if #available(iOS 15.0, *)
            {
                self.navigationController?.navigationBar.scrollEdgeAppearance?.shadowColor = nil
                self.navigationController?.navigationBar.standardAppearance.shadowColor = nil
            }
            else
            {
                self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
                self.navigationController?.navigationBar.shadowImage = UIImage()
            }
        }
        else
        {
            if #available(iOS 15.0, *)
            {
//                let barAppearance = UINavigationBarAppearance()
//                self.navigationController?.navigationBar.scrollEdgeAppearance = barAppearance
//                self.navigationController?.navigationBar.standardAppearance = barAppearance
            }
            else
            {
                self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
                self.navigationController?.navigationBar.shadowImage = nil
            }
        }
    }
    
    //设置导航标题颜色
    fileprivate func setNavTitleColor()
    {
        let attrDic = [NSAttributedString.Key.foregroundColor: UIColor.cBlack333333]
        if #available(iOS 15.0, *)
        {
            self.navigationController?.navigationBar.scrollEdgeAppearance?.titleTextAttributes = attrDic
            self.navigationController?.navigationBar.standardAppearance.titleTextAttributes = attrDic
        }
        else
        {
            self.navigationController?.navigationBar.titleTextAttributes = attrDic
        }
    }
    
    
    //MARK: 通知处理
    //添加通知
    //如果子类覆写这个方法，需要调用父类方法
    func addNotification()
    {
        //添加主题通知
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange(notify:)), name: NSNotification.Name(FSNotification.changeTheme.rawValue), object: nil)
    }

    //处理主题通知的方法
    @objc func themeDidChange(notify: Notification)
    {
        self.theme = notify.userInfo![FSNotification.changeTheme.paramKey()] as! ThemeProtocol
        self.themeConfigUI(theme: self.theme)
    }

    //主题更新UI
    //如果子类覆写这个方法，需要调用父类方法
    func themeConfigUI(theme: ThemeProtocol)
    {
        //留给子类实现
    }
    

    //析构方法，清理一些资源
    deinit {
        print(TimeEmbellisher.getCurrentTimeString() + ": " + Utility.getObjClassName(obj: self) + " dealloc")
        NotificationCenter.default.removeObserver(self)
    }
    
}

/**
 * 侧滑返回功能
 */
extension BasicTableViewController: UIGestureRecognizerDelegate
{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let count = self.navigationController?.viewControllers.count, count <= 1
        {
            return false
        }
        return true
    }
    
}
