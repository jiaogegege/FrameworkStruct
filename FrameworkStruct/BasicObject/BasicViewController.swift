//
//  BasicViewController.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/11/5.
//

import UIKit

class BasicViewController: UIViewController
{
    //MARK: 方法
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.createUI()
        self.configUI()
        self.initData()
        self.addNotification()
        self.updateUI()
    }
    
    //创建界面，一般用来创建界面组件，留给子类实现
    func createUI()
    {
        
    }
    
    //配置界面，用来设置界面组件，比如frame，约束，颜色等，留给子类实现
    func configUI()
    {
        
    }
    
    //更新界面，一般是更新界面上的一些数据
    func updateUI()
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
        //添加主题通知
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange(notify:)), name: NSNotification.Name(FSNotification.changeThemeNotification.rawValue), object: nil)
    }

    //处理主题通知的方法
    @objc dynamic func themeDidChange(notify: Notification)
    {
        //留给子类实现
    }

    

    
    
    
    
    
    
    
    
    
    
    
    
    //析构方法，清理一些资源
    deinit {
        print(TimeEmbellisher.currentTime() + ": " + Utility.getObjClassName(obj: self) + " dealloc")
        NotificationCenter.default.removeObserver(self)
    }
    
}
