//
//  MineNavigationController.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/2/16.
//

import UIKit

class MineNavigationController: BasicNavigationController {
    
    static func getViewController() -> MineNavigationController
    {
        let board = UIStoryboard(name: gMineSB, bundle: nil)
        return board.instantiateViewController(withIdentifier: "MineNavigationController") as! MineNavigationController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func configUI() {
        self.tabBarItem.title = String.mineVC
        self.tabBarItem.image = UIImage.iMineNormal?.withRenderingMode(.alwaysOriginal)
        self.tabBarItem.selectedImage = UIImage.iMineSelected?.withRenderingMode(.alwaysOriginal)
//        self.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)
    }
    
}
