//
//  MineNavigationController.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/2/16.
//

import UIKit

class MineNavigationController: BasicNavigationController {
    
    override class func getViewController() -> Self {
        getVC(from: gMineSB)
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
