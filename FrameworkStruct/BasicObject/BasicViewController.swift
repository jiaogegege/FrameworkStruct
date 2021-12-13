//
//  BasicViewController.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/11/5.
//

import UIKit

class BasicViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.createUI()
        self.configUI()
        self.initData()
        self.addNotification()
    }
    
    //创建界面，一般用来创建界面组件，留给子类实现
    func createUI()
    {
        
    }
    
    //配置界面，用来设置界面组件，比如frame，约束，颜色等，留给子类实现
    func configUI()
    {
        
    }
    
    //初始化控制器数据，比如一些状态和变量，留给子类实现
    func initData()
    {
        
    }
    
    
    
    
    
    
    
    
    
    
    //MARK: 通知处理
    //添加通知
    func addNotification()
    {
        self.addThemeNotification()
    }
    
    //添加主题通知
    func addThemeNotification()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange(notify:)), name: NSNotification.Name(FSNotification.changeThemeNotification.rawValue), object: nil)
    }

    //处理主题通知的方法
    @objc dynamic func themeDidChange(notify: Notification)
    {
        //留给子类实现
    }

    

    
    
    
    
    
    
    
    
    
    
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
