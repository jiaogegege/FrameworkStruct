//
//  HomeNavigationController.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/2/16.
//

import UIKit

class HomeNavigationController: BasicNavigationController {
    
    static func getViewController() -> HomeNavigationController
    {
        let board = UIStoryboard(name: gMainSB, bundle: nil)
        return board.instantiateViewController(withIdentifier: "HomeNavigationController") as! HomeNavigationController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func configUI() {
        self.tabBarItem.title = String.homeVC
        self.tabBarItem.image = UIImage.iHomeNormal?.withRenderingMode(.alwaysOriginal)
        self.tabBarItem.selectedImage = UIImage.iHomeSelected?.withRenderingMode(.alwaysOriginal)
//        self.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)
    }

}
