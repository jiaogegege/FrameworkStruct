//
//  BasicTabbarController.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/11/5.
//

import UIKit

class BasicTabbarController: UITabBarController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

        //创建完成后添加到管理器中
        ControllerManager.shared.pushController(controller: self)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        ControllerManager.shared.showController(controller: self)
    }

}
