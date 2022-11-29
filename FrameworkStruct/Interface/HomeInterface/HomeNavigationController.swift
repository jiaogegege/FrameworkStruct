//
//  HomeNavigationController.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/2/16.
//

import UIKit

class HomeNavigationController: BasicNavigationController {
    
    override class func getViewController() -> Self {
        getVC(from: gMainSB)
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
