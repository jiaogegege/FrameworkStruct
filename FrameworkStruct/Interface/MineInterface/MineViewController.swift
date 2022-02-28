//
//  MineViewController.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/2/16.
//

import UIKit

class MineViewController: BasicViewController {

    override class func getViewController() -> Self {
        getVC(from: gMineSB)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configUI() {
        self.backStyle = .none
        self.navBackgroundColor = self.theme.mainColor
        self.title = String.mineVC
        self.statusBarStyle = .light
        self.navTitleColor = .white
    }
    
    override func themeUpdateUI(theme: ThemeProtocol) {
        self.navBackgroundColor = self.theme.mainColor
    }
    
}
