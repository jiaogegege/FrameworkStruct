//
//  ControllerManager.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/12/16.
//

/**
 * 控制器管理器
 * 管理程序中所有的控制器，理论上，可以从这里获取到程序中所有的界面
 * 主要提供对控制器的访问，一般是只读属性
 * 这里对所有控制器都是弱引用，不能影响控制器的正常创建和释放
 */
import UIKit

class ControllerManager: OriginManager
{
    //MARK: 属性
    //单例对象
    static let shared = ControllerManager()
    
    //这里记录所有存在的控制器，当控制器被创建时，这里会有弱引用，当控制器被释放时，这里也随之消失
    let allControllers: WeakArray = WeakArray.init()
    
    //当前tabbarcontroller
    //一般只有一个
    weak var tabbarVC: UITabBarController? = nil
    
    //导航控制器弱引用数组
    //这里记录所有被创建的导航控制器，基本上每个tabbar元素都对应一个导航控制器
    let navArray: WeakArray = WeakArray.init()
    
    //当前导航控制器
    weak var currentNavVC: UINavigationController? = nil
    
    //当前控制器，一般是UIViewController，显示在最顶层
    weak var currentVC: UIViewController? = nil
    
    //计算属性，rootViewController
    var rootVC: UIViewController {
        get {
            return g_getWindow().rootViewController!
        }
    }
    
    //计算属性，任何一个控制器，主要用来present另一个控制器
    //优先返回`currentVC`，然后返回`currentNavVC`，然后返回`tabbarVC`,然后返回`rootVC`
    var topVC: UIViewController {
        get {
            if let vc = self.currentVC
            {
                return vc
            }
            else if let vc = self.currentNavVC
            {
                return vc
            }
            else if let vc = self.tabbarVC
            {
                return vc
            }
            else
            {
                return self.rootVC
            }
        }
    }
    
    
    //MARK: 方法
    //私有化init方法
    private override init()
    {
        super.init()
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
    
}


//外部接口
extension ControllerManager: ExternalInterface
{
    //当一个控制器被创建的时候，调用这个方法并传入self，记录
    //建议在viewDidLoad方法中调用
    func pushController(controller: UIViewController)
    {
        self.allControllers.add(controller)
        //判断控制器类型
        if controller.isKind(of: UITabBarController.self)
        {
            self.tabbarVC = controller as? UITabBarController
        }
        else if controller.isKind(of: UINavigationController.self)
        {
            self.navArray.add(controller)
            self.currentNavVC = controller as? UINavigationController
        }
        else
        {
            self.currentVC = controller
        }
    }
    
    //控制器正在显示
    //建议在viewWillAppear方法中调用
    func showController(controller: UIViewController)
    {
        if controller.isKind(of: UITabBarController.self)
        {
            self.tabbarVC = controller as? UITabBarController
        }
        else if controller.isKind(of: UINavigationController.self)
        {
            self.currentNavVC = controller as? UINavigationController
        }
        else
        {
            self.currentVC = controller
        }
    }
    
}
