//
//  ThemeManager.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/12/9.
//

/**
 * 主题管理器
 */
import UIKit

class ThemeManager: OriginManager
{
    //MARK: 属性
    //单例对象
    static let shared = ThemeManager()
    //主题容器
    fileprivate var themeContainer: ThemeContainer = ThemeContainer()
    //当前主题，主要用于缓存，防止多次从容器中读取
    fileprivate var currentTheme: CustomTheme? = nil
    
    //MARK: 方法
    //私有化init方法
    private override init()
    {
        super.init()
        //订阅当前主题更新服务
        self.themeContainer.subscribe(key: TCGetKey.currentTheme, delegate: self)
    }
    
    //重写复制方法
    override func copy() -> Any
    {
        return self // ThemeManager.shared
    }
        
    //重写复制方法
    override func mutableCopy() -> Any
    {
        return self // ThemeManager.shared
    }
    
    
}

/**
 * 对外接口
 */
extension ThemeManager
{
    //当前主题对象
    func getCurrentTheme() -> CustomTheme
    {
        if let curTheme = self.currentTheme
        {
            return curTheme
        }
        else
        {
            self.currentTheme = self.themeContainer.getCurrentTheme()
            return self.currentTheme!
        }
    }
    
    //所有主题对象
    var allTheme: [CustomTheme] {
        return self.themeContainer.getAllTheme()
    }
    
    //切换主题
    func changeTheme(theme: CustomTheme)
    {
        //选择了不同的主题才切换
        if self.currentTheme?.theme.id != theme.theme.id
        {
            self.themeContainer.setCurrentTheme(newTheme: theme)
        }
    }
    
}

/**
 * 订阅主题容器服务
 */
extension ThemeManager: ContainerServices
{
    func containerDidUpdateData(key: AnyHashable, value: Any)
    {
        if let k = key as? TCGetKey
        {
            //切换当前主题的服务
            if k == TCGetKey.currentTheme
            {
                self.currentTheme = (value as! CustomTheme)
                //发出切换主题的通知
                NotificationCenter.default.post(name: NSNotification.Name(FSNotification.changeThemeNotification.rawValue), object: nil, userInfo: [FSNotification.changeThemeNotification.getParameter(): self.currentTheme!])
            }
        }
    }
    
    
}
