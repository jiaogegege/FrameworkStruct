//
//  BasicViewController.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/11/5.
//

import UIKit

class BasicViewController: UIViewController
{
    //MARK: 属性
    /**************************************** 外部接口属性 Section Begin ***************************************/
    /**
     * 请按照声明顺序设置以下属性
     */
    ///主题是否跟随系统暗黑模式变化，默认true，该属性只能子类修改，且只建议修改一次
    var followDarkMode: Bool = true {
        didSet {
            setFollowDarkMode()
        }
    }
    
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
    
    ///是否隐藏导航栏
    var hideNavBar: Bool = false {
        didSet {
            setHideNavigationBar()
        }
    }
    
    ///设置导航栏标题颜色
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
            //如果跟随系统黑暗模式并且当前是暗黑模式，永远返回light
            if self.followDarkMode && UITraitCollection.current.userInterfaceStyle == .dark
            {
                return .lightContent
            }
            return self.statusBarStyle == .dark ? .darkContent : .lightContent
        }
    }
    /**************************************** 外部接口属性 Section End ***************************************/
    
    /**************************************** 内部属性 Section Begin ***************************************/
    //状态管理器，只能在本类中修改，外部和子类仅访问
    fileprivate(set) lazy var stMgr: StatusManager = StatusManager(capacity: vcStatusStep)
    
    //当前主题，只能在本类中修改，外部和子类仅访问
    fileprivate(set) lazy var theme = ThemeManager.shared.getCurrentOrDark()
    
    /**************************************** 内部属性 Section End ***************************************/
    
    
    //MARK: 方法
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //初始化数据
        self.initData()
        
        //设置自定义样式
        self.customConfig()

        //设置UI的基础样式
        self.basicOnceConfig()
        
        //立即设置约束，保证获取的frame是正确的
//        self.view.setNeedsLayout()
//        self.view.layoutIfNeeded()
        
        //创建UI/配置UI/更新界面/添加通知
        self.createUI()
        self.configUI()
        self.updateUI()
        self.addNotification()
        
        //创建完成后添加到管理器中
        ControllerManager.shared.recordController(self)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //每次UI显示都更新导航栏样式，因为其他界面可能修改导航栏样式
        self.basicMultiConfig()
        //显示为当前控制器
        ControllerManager.shared.displayController(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.basicMultiDidConfig()
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
    
    //设置是否跟随系统暗黑模式
    fileprivate func setFollowDarkMode()
    {
        if self.followDarkMode  //如果跟随暗黑模式
        {
            self.theme = ThemeManager.shared.getCurrentOrDark()
        }
        else    //如果不跟随系统，那么设置为light
        {
            self.overrideUserInterfaceStyle = .light
            self.theme = ThemeManager.shared.getCurrentTheme()
        }
    }
    
    //设置返回按钮样式
    fileprivate func setBackStyle()
    {
        switch backStyle {
        case .dark, .darkAlways, .darkThin, .lightAlways, .darkClose:
            if let image = backStyle.getImage() //如果有图片，那么创建返回按钮
            {
                let backItem = UIBarButtonItem(image: image.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backAction(sender:)))
                let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
                spaceItem.width = -10
                self.navigationItem.leftBarButtonItems = [backItem]
            }
            else    //如果没有返回图片，那么使用系统自带返回按钮
            {
                self.navigationItem.hidesBackButton = false
            }
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
            self.view.backgroundColor = theme.backgroundColor  //如果背景是图片，那么背景色设置成主题背景
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
                barAppearance.backgroundColor = nil
                barAppearance.backgroundImage = nil
                barAppearance.backgroundEffect = nil
                barAppearance.shadowColor = nil
                barAppearance.shadowImage = nil
                self.navigationController?.navigationBar.scrollEdgeAppearance = barAppearance
                self.navigationController?.navigationBar.standardAppearance = barAppearance
            }
            else
            {
                self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
                self.navigationController?.navigationBar.shadowImage = UIImage()
            }
            self.navigationController?.navigationBar.isTranslucent = true
        }
        else
        {
            if #available(iOS 15.0, *)
            {
                //根据各种条件判断最终的颜色
                let color = useDarkMode() ? self.navBackgroundColor.switchDarkMode(keepDark: true) : self.navBackgroundColor
                let barAppearance = UINavigationBarAppearance()
                barAppearance.backgroundColor = color
                barAppearance.shadowColor = color
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
        //根据各种条件判断最终的颜色
        let color = useDarkMode() ? self.navBackgroundColor.switchDarkMode(keepDark: true) : self.navBackgroundColor
        if #available(iOS 15.0, *)
        {
            self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = color
            self.navigationController?.navigationBar.standardAppearance.backgroundColor = color
        }
        else
        {
            self.navigationController?.navigationBar.barTintColor = color
//            self.navigationController?.navigationBar.tintColor = color  //这一行会修改导航栏上的系统按钮颜色，比如返回按钮
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
    
    //是否隐藏导航栏
    fileprivate func setHideNavigationBar()
    {
        self.navigationController?.navigationBar.isHidden = self.hideNavBar
    }
    
    //设置导航标题颜色
    fileprivate func setNavTitleColor()
    {
        //根据各种条件判断最终的颜色
        let color = useDarkMode() ? self.navTitleColor.switchDarkMode(keepBright: true) : self.navTitleColor
        let attrDic = [NSAttributedString.Key.foregroundColor: color]
        if #available(iOS 15.0, *)
        {
            self.navigationController?.navigationBar.scrollEdgeAppearance?.titleTextAttributes = attrDic
            self.navigationController?.navigationBar.standardAppearance.titleTextAttributes = attrDic
        }
        else
        {
            self.navigationController?.navigationBar.titleTextAttributes = attrDic
//            self.navigationController?.navigationBar.tintColor = self.navTitleColor   //这一行会修改导航栏上的系统按钮颜色，比如返回按钮
        }
    }
    
    //设置状态栏内容颜色
    fileprivate func setStatusBarStyle()
    {
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    //是否使用暗黑主题
    func useDarkMode() -> Bool
    {
        if self.followDarkMode == true && UITraitCollection.current.userInterfaceStyle == .dark
        {
            return true
        }
        return false
    }
    
    //MARK: 可被子类覆写的方法
    //返回按钮事件
    //子类可以覆写这个方法
    @objc func backAction(sender: UIBarButtonItem)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    //初始化控制器数据，比如一些状态和变量，这个方法在所有方法之前调用，如果有任何基础变量和数据要设置，那么子类在这个方法中设置
    //如果子类覆写这个方法，需要在最后调用父类方法
    //初始化时执行一次
    override func initData()
    {
        
    }
    
    //自定义设置，提供给子类使用，该方法会在`basicConfig`和`basicNavConfig`之前调用
    func customConfig()
    {
        
    }
    
    //基础设置，设置这个控制器的基础属性，默认在VC创建时执行一次
    //不建议覆写这个方法
    func basicOnceConfig()
    {
        setFollowDarkMode()
        //导航栏透明
        self.setNavAlpha()
        //返回按钮样式
        self.setBackStyle()
        //背景色
        self.setBackgroundColor()
    }
    
    //设置导航栏和状态栏样式，可多次执行，默认每次进入VC执行一次
    //在`viewDidAppear`中执行
    //不建议覆写这个方法
    func basicMultiConfig()
    {
        //导航栏隐藏
        self.setHideNavigationBar()
        //导航栏透明
        self.setNavAlpha()
        //隐藏导航栏底部横线
        self.setHiddenNavBottomLine()
        //导航标题颜色
        self.setNavTitleColor()
        //状态栏内容颜色
        self.setStatusBarStyle()
        
        //如果导航栏没有设置透明，那么设置背景色
        if self.navAlpha == false
        {
            self.setNavBackgroundColor()
        }
    }
    
    //这个方法在`viewDidAppear`中执行，可多次执行，主要针对一些不能在`viewWillAppear`中执行的方法
    //不建议覆写这个方法
    func basicMultiDidConfig()
    {
        //侧滑返回
        self.setLeftSlideBack()
    }
    
    //创建界面，一般用来创建界面组件
    //如果子类覆写这个方法，需要在最前调用父类方法
    //初始化时执行一次
    override func createUI()
    {
        
    }
    
    //配置界面，用来设置界面组件，比如frame，约束，颜色，字体等
    //如果子类覆写这个方法，需要在最后调用父类方法
    //初始化时执行一次
    override func configUI()
    {
        //用主题更新UI元素，如果有的话
        self.themeUpdateUI(theme: self.theme)
    }
    
    //更新UI组件的布局，比如frame、约束等
    //这个方法可能被多次执行，所以不要在这里创建任何对象
    //如果子类覆写这个方法，需要调用父类方法
    //页面布局变化的时候会多次执行
    override func layoutUI()
    {
        
    }
    
    //更新界面，一般是更新界面上的一些数据
    //如果子类覆写这个方法，需要调用父类方法
    //初始化时执行一次
    //可以手动调用这个方法，比如数据更新的时候
    override func updateUI()
    {
        
    }
    
    //添加通知
    //如果子类覆写这个方法，需要调用父类方法
    override func addNotification()
    {
        //添加主题通知
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChangeNotification(notify:)), name: FSNotification.changeTheme.name, object: nil)
    }

    //主题更新UI
    //如果子类覆写这个方法，需要调用父类方法
    //初始化时执行一次，主题变化时执行，包括暗黑模式
    override func themeUpdateUI(theme: ThemeProtocol, isDark: Bool = false)
    {
        //留给子类实现
    }
    
    //暗黑模式适配
    //子类覆写这个方法的时候，要先调用父类方法，如果设置`followDarkMode`为false，则无需覆写这个方法
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        //如果子类设置了只使用某一种模式，那么不需要更新主题
        if self.followDarkMode == true
        {
            super.traitCollectionDidChange(previousTraitCollection)
            //当系统暗黑模式变化的时候，设置基础属性
            setFollowDarkMode()
            setBackStyle()
            setBackgroundColor()
            setNavBackgroundColor()
            setNavTitleColor()
            setStatusBarStyle()
            themeUpdateUI(theme: theme, isDark: ThemeManager.shared.isDarkTheme(theme))
        }
    }
    

    //析构方法，清理一些资源
    deinit {
        NotificationCenter.default.removeObserver(self)
        
        FSLog(self.className + " dealloc")
    }
    
}


//代理和通知方法
extension BasicViewController: UIGestureRecognizerDelegate
{
    //处理主题通知的方法
    @objc fileprivate func themeDidChangeNotification(notify: Notification)
    {
//        self.theme = notify.userInfo![FSNotification.changeTheme.paramKey] as! ThemeProtocol
        setFollowDarkMode()     //切换主题的时候支持暗黑模式
        themeUpdateUI(theme: self.theme, isDark: ThemeManager.shared.isDarkTheme(theme))
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


//接口方法
extension BasicViewController
{
    //是否可以push一个VC，取决于自身有没有navigationVC
    func canPush() -> Bool
    {
        self.navigationController != nil
    }
    
    //push一个VC，可能失败，取决于自身有没有navigationVC
    func push(_ vc: UIViewController, hideTabBar: Bool = true, animated: Bool = true)
    {
        vc.hidesBottomBarWhenPushed = hideTabBar
        self.navigationController?.pushViewController(vc, animated: animated)
    }
    
    ///pop返回上一VC或rootVC
    func pop(_ toRoot: Bool = false, animated: Bool = true)
    {
        if toRoot
        {
            self.navigationController?.popToRootViewController(animated: animated)
        }
        else
        {
            self.navigationController?.popViewController(animated: animated)
        }
    }
    
    ///pop返回多层VC，如果index大于最大VC数，则返回到rootVC
    ///参数：index：返回第几个VC，0=当前VC；1=上一个VC；2=上上个VC
    func popAt(_ index: UInt, animated: Bool = true)
    {
        if let vcs = self.navigationController?.viewControllers
        {
            if index <= 0
            {
                //当前VC什么都不做
            }
            else if index >= vcs.count - 1   //返回rootVC
            {
                self.navigationController?.popToRootViewController(animated: animated)
            }
            else    //返回某一个VC
            {
                let vc = vcs[vcs.count - 1 - Int(index)]
                self.navigationController?.popToViewController(vc, animated: animated)
            }
        }
    }
    
    ///pop返回到stack中的第一个某一种VC，没找到则什么都不做
    func popTo(_ vcType: UIViewController.Type, animated: Bool = true)
    {
        if let vcs = self.navigationController?.viewControllers
        {
            //查找第一个符合要求的vc，反向遍历
            for (_, value) in vcs.enumerated().reversed()
            {
                if type(of: value) == vcType
                {
                    self.navigationController?.popToViewController(value, animated: animated)
                    break
                }
            }
        }
    }
    
    ///modal显示一个VC
    ///参数：
    ///mode：modal模式；isModal：是否禁止手动下滑让modal的VC消失，默认不禁止
    func modal(_ vc: UIViewController, mode: UIModalPresentationStyle = .fullScreen, isModal: Bool = false, animated: Bool = true, completion: VoidClosure? = nil)
    {
        vc.modalPresentationStyle = mode
        vc.isModalInPresentation = isModal
        self.present(vc, animated: animated) {
            if let cb = completion
            {
                cb()
            }
        }
    }
    
}
