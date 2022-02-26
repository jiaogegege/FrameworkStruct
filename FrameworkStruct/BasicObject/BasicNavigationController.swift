//
//  BasicNavigationController.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/11/5.
//

import UIKit

class BasicNavigationController: UINavigationController
{
    //MARK: 属性
    /******************** 内部属性 Section Begin *******************/
    //状态管理器，只能在本类中修改，外部和子类仅访问
    fileprivate(set) var stMgr: StatusManager = StatusManager(capacity: vcStatusStep)
    //当前主题，只能在本类中修改，外部和子类仅访问
    fileprivate(set) var theme = ThemeManager.shared.getCurrentTheme()
    /******************** 内部属性 Section End *******************/
    

    //MARK: 方法
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
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
    
    //返回顶层控制器状态栏颜色
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.topViewController!.preferredStatusBarStyle
    }
    
    //创建界面
    override func createUI()
    {
        
    }
    
    ///配置界面属性
    override func configUI()
    {
        self.themeUpdateUI(theme: theme)
    }
    
    //主题更新UI
    //如果子类覆写这个方法，需要调用父类方法
    //初始化时执行一次，主题变化时执行
    override func themeUpdateUI(theme: ThemeProtocol)
    {
        
    }
    
    //添加通知
    //如果子类覆写这个方法，需要调用父类方法
    override func addNotification()
    {
        //添加主题通知
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChangeNotification(notify:)), name: FSNotification.changeTheme.name, object: nil)
    }
    
    //析构方法，清理一些资源
    deinit {
        NotificationCenter.default.removeObserver(self)
        
        FSLog(getCurrentTimeString() + ": " + g_getObjClassName(self) + " dealloc")
    }

}


//代理和通知方法
extension BasicNavigationController:DelegateProtocol
{
    //处理主题通知的方法
    @objc fileprivate func themeDidChangeNotification(notify: Notification)
    {
        self.theme = notify.userInfo![FSNotification.changeTheme.paramKey] as! ThemeProtocol
        self.themeUpdateUI(theme: self.theme)
    }

}
