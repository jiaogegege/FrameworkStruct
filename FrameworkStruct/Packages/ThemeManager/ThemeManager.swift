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
    var themeContainer: ThemeContainer = ThemeContainer()
    
    //MARK: 方法
    //私有化init方法
    private override init()
    {
        super.init()
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
    var currentTheme: CustomTheme {
        return self.themeContainer.getCurrentTheme()
    }
    
    //所有主题对象
    var allTheme: [CustomTheme] {
        return self.themeContainer.getAllTheme()
    }
    
    //切换主题
    func changeTheme(theme: CustomTheme)
    {
        themeContainer.setCurrentTheme(newTheme: theme)
    }
    
}

/**
 * 订阅主题容器服务
 */
extension ThemeManager: ContainerServices
{
    func containerDidUpdateData(key: AnyHashable, value: Any) {
        if let k = key as? TCGetKey
        {
            //切换当前主题的服务
            if k == TCGetKey.currentTheme
            {
                
            }
        }
    }
    
    
}
