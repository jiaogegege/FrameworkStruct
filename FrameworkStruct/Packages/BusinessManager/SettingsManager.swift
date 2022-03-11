//
//  SettingsManager.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/3/3.
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
    ///设置是否跟随系统暗黑模式
    func setFollowDarkMode(_ follow: Bool)
    {
        //不一致的时候才设置
        if follow != ThemeManager.shared.isFollowDarkMode
        {
            ThemeManager.shared.setFollowDarkMode(follow: follow)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
}
