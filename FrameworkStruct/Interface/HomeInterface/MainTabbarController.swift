//
//  MainTabbarController.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/2/13.
//

/**
 最主要的tabbar控制器
 包括主页、我的等最外层的核心模块
 */
import UIKit

class MainTabbarController: BasicTabbarController
{
    override class func getViewController() -> Self {
        getVC(from: gMainSB)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func createUI() {
        //首页
        let homeNav = HomeNavigationController.getViewController()
        //我的
        let mineNav = MineNavigationController.getViewController()
        mineNav.configUI()  //界面未加载的时候，图标出不来，所以调用一下
        
        self.viewControllers = [homeNav, mineNav]
    }
    
    
    
    
    
}
