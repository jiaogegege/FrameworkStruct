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
    //状态管理器，只能在本类中修改，外部和子类仅访问
    fileprivate(set) var stMgr: StatusManager = StatusManager(capacity: 5)
    //当前主题，只能在本类中修改，外部和子类仅访问
    fileprivate(set) var theme = ThemeManager.shared.getCurrentTheme()
    
    /**
     * 请按照声明顺序设置以下属性
     */
    ///返回按钮样式
    var backStyle: VCBackStyle = .dark {
        didSet {
            setBackStyle()
        }
    }
    
    ///是否支持侧滑返回，默认true
    var canLeftSlideBack: Bool = true {
        didSet {
            setLeftSlideBack()
        }
    }
    
    ///设置背景色
    var backgroundStyle: VCBackgroundStyle = .none {
        didSet {
            setBackgroundColor()
        }
    }
    
    ///导航栏背景色
    var navBackgroundColor: UIColor = .white {
        didSet {
            setNavBackgroundColor()
        }
    }
    
    ///设置导航栏是否透明，默认不透明
    ///该属性必须在`navBackgroundColor`之后设置，否则会失效
    var navAlpha: Bool = false {
        didSet {
            setNavAlpha()
        }
    }
    
    ///设置是否隐藏导航栏底部横线
    var hideNavBottomLine: Bool = true {
        didSet {
            setHiddenNavBottomLine()
        }
    }
    
    ///设置标题颜色
    var navTitleColor: UIColor = .black {
        didSet {
            setNavTitleColor()
        }
    }
    
    ///设置状态栏内容颜色
    var statusBarStyle: VCStatusBarStyle = .dark {
        didSet {
            setStatusBarStyle()
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return self.statusBarStyle == .dark ? .default : .lightContent
        }
    }
    
    
    //MARK: 方法
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //先设置UI的基础样式
        self.basicConfig()
        
        //立即设置约束，保证获取的frame是正确的
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        //创建UI/配置UI/初始化数据/更新界面/添加通知
        self.createUI()
        self.configUI()
        self.initData()
        self.updateUI()
        self.addNotification()
        
        //创建完成后添加到管理器中
        ControllerManager.shared.pushController(controller: self)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //每次UI显示都更新导航栏样式，因为其他界面可能修改导航栏样式
        self.basicNavConfig()
        //显示为当前控制器
        ControllerManager.shared.showController(controller: self)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
    }
    
    //在这里可以对UI的布局进行更新和修改
    //如果子类覆写这个方法，需要调用父类方法
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        //更新UI布局
        self.layoutUI()
    }
    
    //基础设置，设置这个控制器的基础属性
    fileprivate func basicConfig()
    {
        //返回按钮样式
        self.setBackStyle()
        //侧滑返回
        self.setLeftSlideBack()
        //背景色
        self.setBackgroundColor()
    }
    
    //设置导航栏和状态栏样式
    fileprivate func basicNavConfig()
    {
        //导航栏背景色
        self.setNavBackgroundColor()
        //导航栏透明
        self.setNavAlpha()
        //隐藏导航栏底部横线
        self.setHiddenNavBottomLine()
        //导航标题颜色
        self.setNavTitleColor()
        //状态栏内容颜色
        self.setStatusBarStyle()
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
        let bgContent = self.backgroundStyle.getContent()
        if let color = bgContent as? UIColor
        {
            self.view.backgroundColor = color
        }
        else if let la = bgContent as? CALayer
        {
            self.view.backgroundColor = .white  //如果背景是图片，那么背景色设置成白色
            self.view.layer.addSublayer(la)
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
//                self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
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
//                self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
                self.navigationController?.navigationBar.shadowImage = nil
            }
        }
    }
    
    //设置导航标题颜色
    fileprivate func setNavTitleColor()
    {
        let attrDic = [NSAttributedString.Key.foregroundColor: self.navTitleColor]
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
    
    //设置状态栏内容颜色
    fileprivate func setStatusBarStyle()
    {
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    
    //MARK: 可被子类覆写的方法
    
    //返回按钮事件
    //子类可以覆写这个方法
    @objc func backAction(sender: UIBarButtonItem)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    //创建界面，一般用来创建界面组件
    //如果子类覆写这个方法，需要调用父类方法
    //初始化时执行一次
    func createUI()
    {
        
    }
    
    //配置界面，用来设置界面组件，比如frame，约束，颜色，字体等
    //如果子类覆写这个方法，需要调用父类方法
    //初始化时执行一次
    func configUI()
    {
        //用主题更新UI元素，如果有的话
        self.themeUpdateUI(theme: self.theme)
    }
    
    //更新UI组件的布局，比如frame、约束等
    //这个方法可能被多次执行，所以不要在这里创建任何对象
    //如果子类覆写这个方法，需要调用父类方法
    //会多次执行
    func layoutUI()
    {
        
    }
    
    //初始化控制器数据，比如一些状态和变量
    //如果子类覆写这个方法，需要调用父类方法
    //初始化时执行一次
    func initData()
    {
        
    }
    
    //更新界面，一般是更新界面上的一些数据
    //如果子类覆写这个方法，需要调用父类方法
    //初始化时执行一次
    //可以手动调用这个方法
    func updateUI()
    {
        
    }
    
    //主题更新UI
    //如果子类覆写这个方法，需要调用父类方法
    //初始化时执行一次，主题变化时执行
    func themeUpdateUI(theme: ThemeProtocol)
    {
        //留给子类实现
    }
    
    //添加通知
    //如果子类覆写这个方法，需要调用父类方法
    func addNotification()
    {
        //添加主题通知
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChangeNotification(notify:)), name: FSNotification.changeTheme.name, object: nil)
    }
    

    //析构方法，清理一些资源
    deinit {
        NotificationCenter.default.removeObserver(self)
        
        print(getCurrentTimeString() + ": " + Utility.getObjClassName(self) + " dealloc")
    }
    
}


//代理和通知方法
extension BasicTableViewController:DelegateProtocol, UIGestureRecognizerDelegate
{
    //处理主题通知的方法
    @objc fileprivate func themeDidChangeNotification(notify: Notification)
    {
        self.theme = notify.userInfo![FSNotification.changeTheme.paramKey] as! ThemeProtocol
        self.themeUpdateUI(theme: self.theme)
    }

    //侧滑返回功能
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool
    {
        if let count = self.navigationController?.viewControllers.count, count <= 1
        {
            return false
        }
        return true
    }
    
}
