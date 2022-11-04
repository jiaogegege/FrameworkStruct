//
//  HomeShortcutManager.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/9/30.
//

/**
 主屏幕快捷按钮管理器
 */
import UIKit

class HomeShortcutManager: OriginManager
{
    //MARK: 属性
    //单例
    static let shared = HomeShortcutManager()
    
    //shortcut
    fileprivate(set) var shortcut: UIApplicationShortcutItem?
    
    
    //MARK: 方法
    //私有化初始化方法
    private override init()
    {
        super.init()
        
        self.addNotification()
    }
    
    override func copy() -> Any
    {
        return self
    }
    
    override func mutableCopy() -> Any
    {
        return self
    }
    
    fileprivate func addNotification()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActiveNotification(notification:)), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    ///处理shortut
    fileprivate func handleShortcut(_ shortcut: UIApplicationShortcutItem)
    {
        if let st = ShortcutType(rawValue: shortcut.type)
        {
            g_async {
                st.handle()
            }
            
            //处理完后清空
            self.shortcut = nil
        }
    }
    
}


//协议通知
extension HomeShortcutManager: DelegateProtocol
{
    //app已经获得焦点
    @objc func applicationDidBecomeActiveNotification(notification: Notification)
    {
        //处理shortcut，如果有的话
        if let shortcut = self.shortcut
        {
            self.handleShortcut(shortcut)
        }
    }
    
}


//内部类型
extension HomeShortcutManager: InternalType
{
    //快捷按钮类型，根据实际需求配置；有的可以在info.plist中配置，但是也要在这里列举出来
    enum ShortcutType: String {
        case myFavorite = "com.FrameworkStruct.test.MyFavorites"                //我的收藏, info.plist
        case changeTheme = "com.FrameworkStruct.test.ChangeTheme"               //切换主题, info.plist
        
        case icloudFile = "com.FrameworkStruct.test.iCloudFile"                 //访问icloud文件
        case playMusic = "com.FrameworkStruct.test.PlayMusic"                   //播放音乐
        
        //获得快捷按钮对象
        func getShortcut() -> UIApplicationShortcutItem
        {
            switch self {
            case .myFavorite:
                return UIApplicationShortcutItem(type: self.rawValue, localizedTitle: String.myFavorite, localizedSubtitle: nil, icon: UIApplicationShortcutIcon(type: .favorite), userInfo: nil)
            case .changeTheme:
                return UIApplicationShortcutItem(type: self.rawValue, localizedTitle: String.changeTheme, localizedSubtitle: nil, icon: UIApplicationShortcutIcon(type: .time), userInfo: nil)
            case .icloudFile:
                return UIApplicationShortcutItem(type: self.rawValue, localizedTitle: String.icloudFile, localizedSubtitle: nil, icon: UIApplicationShortcutIcon(type: .cloud), userInfo: nil)
            case .playMusic:
                return UIApplicationShortcutItem(type: self.rawValue, localizedTitle: String.playMusic, localizedSubtitle: nil, icon: UIApplicationShortcutIcon(type: .play), userInfo: nil)
            }
        }
        
        //根据shortcut执行对应的动作，根据实际需求开发，此处仅作示例
        func handle()
        {
            switch self {
            case .myFavorite:
                g_pushVC(HealthCodeViewController.getViewController())
            case .changeTheme:
                g_pushVC(ThemeSelectViewController.getViewController())
            case .icloudFile:
                g_pushVC(iCloudFileViewController.getViewController())
            case .playMusic:
                //尝试播放音乐
                MPManager.shared.wantPlayCurrent { (succeed) in
//                    FSLog("\(succeed)")
                }
            }
        }
        
        ///获得所有可动态配置的shortcuts，除去在info.plist中剩下的
        static func allCustom() -> [ShortcutType]
        {
            [icloudFile, playMusic]
        }
        
        ///获得所有在info.plist中的shortcuts
        static func allSystem() -> [ShortcutType]
        {
            [myFavorite, changeTheme]
        }
    }
}


//外部接口
extension HomeShortcutManager: ExternalInterface
{
    ///获得所有可动态配置的快捷方式
    func getAllDynamic() -> [UIApplicationShortcutItem]
    {
        ShortcutType.allCustom().map { type in
            type.getShortcut()
        }
    }
    
    ///处理shortcut
    func dispatchShortcut(_ shortcut: UIApplicationShortcutItem?)
    {
        if let sh = shortcut
        {
            self.shortcut = sh
        }
    }
    
}
