//
//  SystemSettingViewController.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/3/3.
//

import UIKit

class SystemSettingViewController: BasicTableViewController {
    /**************************************** UI组件 Section Begin ***************************************/
    //切换暗黑模式
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var darkModeLabel: UILabel!
    
    /**************************************** UI组件 Section End ***************************************/
    
    /**************************************** 内部属性 Section Begin ***************************************/
    //系统设置管理器
    fileprivate var setMgr = SettingsManager.shared
    //主题管理器
    fileprivate lazy var themeMgr = ThemeManager.shared
    
    /**************************************** 内部属性 Section End ***************************************/

    override class func getViewController() -> Self {
        getVC(from: gMineSB)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func customConfig() {
        self.statusBarStyle = .light
        self.backStyle = .lightAlways
        self.navBackgroundColor = self.theme.mainColor
        self.navTitleColor = .white
    }
    
    override func configUI() {
        super.configUI()
        self.darkModeSwitch.onTintColor = themeMgr.getCurrentTheme().mainColor
    }
    
    //各种设置项的初始状态
    override func updateUI() {
        super.updateUI()
        self.darkModeSwitch.isOn = setMgr.followDarkMode
    }
    
    //设置是否跟随系统暗黑模式
    @IBAction func darkModeSwitchAction(_ sender: UISwitch) {
        setMgr.followDarkMode = sender.isOn
    }
    
    override func themeUpdateUI(theme: ThemeProtocol, isDark: Bool = false) {
        self.navBackgroundColor = self.theme.mainColor
    }

}
