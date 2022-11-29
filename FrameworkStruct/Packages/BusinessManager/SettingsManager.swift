//
//  SettingsManager.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/3/3.
//

/**
 * 管理应用中各种设置和选项
 */
import UIKit

class SettingsManager: OriginManager
{
    //MARK: 属性
    //单例
    static let shared = SettingsManager()
    
    
    //MARK: 方法
    //私有化初始化方法
    private override init()
    {
        super.init()
    }
    
    override func copy() -> Any
    {
        return self
    }
    
    override func mutableCopy() -> Any
    {
        return self
    }

}


//接口方法
extension SettingsManager: ExternalInterface
{
    ///进入App系统设置界面
    func gotoSystemSetting()
    {
        if let url = URL(string: UIApplication.openSettingsURLString)
        {
            if UIApplication.shared.canOpenURL(url)
            {
                UIApplication.shared.open(url, options: [:]) { success in
                    FSLog("open setting :\(success)")
                }
            }
        }
    }
    
    ///是否跟随系统暗黑模式
    var followDarkMode: Bool {
        get {
            ThemeManager.shared.isFollowDarkMode
        }
        set {
            //不一致的时候才设置
            if newValue != ThemeManager.shared.isFollowDarkMode
            {
                ThemeManager.shared.setFollowDarkMode(follow: newValue)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
