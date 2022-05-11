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
    
    //userdefaults
    fileprivate var ud: UserDefaultsAccessor = UserDefaultsAccessor.shared
    
    //主题容器
    fileprivate var themeContainer: ThemeContainer = ThemeContainer()
    
    //当前主题，主要用于缓存，防止多次从容器中读取
    fileprivate var currentTheme: CustomTheme? = nil
    
    //暗黑主题
    fileprivate var darkTheme: CustomTheme!
    
    //MARK: 方法
    //私有化init方法
    private override init()
    {
        super.init()
        //读取一些状态
        self.stMgr.setStatus(ud.readBool(key: .followDarkMode), forKey: TMStatusKey.followDarkMode)
        
        //设置app是否跟随系统暗黑模式
        g_window().overrideUserInterfaceStyle = isFollowDarkMode ? .unspecified : .light
        
        //订阅当前主题更新服务
        self.themeContainer.subscribe(key: TCDataKey.currentTheme, delegate: self)

        //获取暗黑主题
        self.darkTheme = self.themeContainer.getDarkTheme()
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
 * 订阅主题容器服务
 */
extension ThemeManager: DelegateProtocol, ContainerServices
{
    func containerDidUpdateData(key: AnyHashable, value: Any)
    {
        if let k = key as? TCDataKey
        {
            //切换当前主题的服务
            if k == TCDataKey.currentTheme
            {
                self.currentTheme = (value as! CustomTheme)
                //发出切换主题的通知
                NotificationCenter.default.post(name: FSNotification.changeTheme.name, object: nil, userInfo: [FSNotification.changeTheme.paramKey: self.currentTheme!])
            }
        }
    }
    
    func containerDidClearData(key: AnyHashable) {
        if let k = key as? TCDataKey
        {
            if k == TCDataKey.currentTheme
            {
                //当前主题被清空?不太可能发生,至少有一个当前主题
            }
        }
    }
    
}


//内部类型
extension ThemeManager: InternalType
{
    //状态类型
    enum TMStatusKey: SMKeyType {
        case followDarkMode             //是否跟随系统暗黑模式
    }
    
}


//外部接口
extension ThemeManager: ExternalInterface
{
    ///获取当前主题或者暗黑主题，如果设置了跟随系统暗黑模式，那么在暗黑模式下返回暗黑主题
    func getCurrentOrDark() -> ThemeProtocol
    {
        if self.isFollowDarkMode && UITraitCollection.current.userInterfaceStyle == .dark
        {
            return self.getDarkTheme()
        }
        else
        {
            return self.getCurrentTheme()
        }
    }
    
    //当前主题对象
    //follow:是否跟随系统暗黑模式变化
    func getCurrentTheme() -> ThemeProtocol
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
    
    //暗黑主题
    func getDarkTheme() -> ThemeProtocol
    {
        return self.darkTheme
    }
    
    //所有主题对象
    var allTheme: [ThemeProtocol] {
        return self.themeContainer.getAllTheme()
    }
    
    //切换主题
    func changeTheme(theme: ThemeProtocol)
    {
        let newTheme = theme as! CustomTheme
        //选择了不同的主题才切换
        if self.currentTheme?.theme.id != newTheme.theme.id
        {
            self.themeContainer.setCurrentTheme(newTheme: newTheme)
        }
    }
    
    ///设置是否跟随系统暗黑模式
    func setFollowDarkMode(follow: Bool)
    {
        //修改状态
        self.stMgr.setStatus(follow, forKey: TMStatusKey.followDarkMode)
        //设置全局窗口样式
        g_window().overrideUserInterfaceStyle = follow ? .unspecified : .light
        //更新到本地
        ud.write(key: .followDarkMode, value: follow)
    }
    
    ///判断是否跟随暗黑模式
    var isFollowDarkMode: Bool {
        return stMgr.status(forKey: TMStatusKey.followDarkMode) as! Bool
    }
    
    ///判断主题是否是暗黑主题
    func isDarkTheme(_ theme: ThemeProtocol) -> Bool
    {
        if let th = theme as? CustomTheme
        {
            return th.isDarkTheme()
        }
        return false
    }
    
}
