//
//  BasicTabbarController.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/11/5.
//

import UIKit

class BasicTabbarController: UITabBarController
{
    //MARK: 属性
    ///主题是否跟随系统暗黑模式变化，默认true，该属性只能子类修改，且只建议修改一次
    var followDarkMode: Bool = true {
        didSet {
            setFollowDarkMode()
        }
    }
    
    //状态管理器，只能在本类中修改，外部和子类仅访问
    fileprivate(set) var stMgr: StatusManager = StatusManager(capacity: vcStatusStep)
    
    fileprivate(set) lazy var theme = ThemeManager.shared.getCurrentOrDark()
    

    //MARK: 方法
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        basicConfig()
        
        createUI()
        configUI()
        addNotification()

        //创建完成后添加到管理器中
        ControllerManager.shared.pushController(controller: self)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        ControllerManager.shared.showController(controller: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
    
    //基础设置，设置这个控制器的基础属性
    fileprivate func basicConfig()
    {
        setFollowDarkMode()
    }
    
    ///创建界面，也就是控制器
    ///留给子类实现
    override func createUI()
    {
        
    }
    
    ///配置界面属性
    override func configUI()
    {
        self.themeUpdateUI(theme: self.theme)
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
        self.tabBar.tintColor = theme.mainColor
    }
    
    //暗黑模式适配
    //子类覆写这个方法的时候，要先调用父类方法，如果设置`followDarkMode`为false，则无需覆写这个方法
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        //如果子类设置了只使用某一种模式，那么不需要更新主题
        if self.followDarkMode == true
        {
            //当系统暗黑模式变化的时候，设置基础属性
            super.traitCollectionDidChange(previousTraitCollection)
            setFollowDarkMode()
            themeUpdateUI(theme: theme, isDark: ThemeManager.shared.isDarkTheme(theme))
        }
    }

    
    //析构方法，清理一些资源
    deinit {
        NotificationCenter.default.removeObserver(self)
        
        FSLog(getCurrentTimeString() + ": " + g_getObjClassName(self) + " dealloc")
    }

}


//代理和通知方法
extension BasicTabbarController:DelegateProtocol
{
    //处理主题通知的方法
    @objc fileprivate func themeDidChangeNotification(notify: Notification)
    {
//        self.theme = notify.userInfo![FSNotification.changeTheme.paramKey] as! ThemeProtocol
        setFollowDarkMode()     //切换主题的时候支持暗黑模式
        themeUpdateUI(theme: theme, isDark: ThemeManager.shared.isDarkTheme(theme))
    }

}
