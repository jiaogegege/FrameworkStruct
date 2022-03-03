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
    
    override func customConfig() {
        self.backStyle = .none
        self.navBackgroundColor = self.theme.mainColor
        self.title = String.mineVC
        self.statusBarStyle = .light
        self.navTitleColor = .white
    }
    
    override func createUI() {
        super.createUI()
        let settingBtn = UIButton(type: .custom)
        settingBtn.setImage(UIImage.iSysSettingIcon, for: .normal)
        settingBtn.addTarget(self, action: #selector(gotoSysSettingAction(sender:)), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: settingBtn)
        self.navigationItem.rightBarButtonItems = [rightItem]
    }
    
    override func configUI() {
        super.configUI()

    }
    
    override func themeUpdateUI(theme: ThemeProtocol) {
        self.navBackgroundColor = self.theme.mainColor
    }
    
    //进入系统设置
    @objc func gotoSysSettingAction(sender: UIButton)
    {
        let vc = SystemSettingViewController.getViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
