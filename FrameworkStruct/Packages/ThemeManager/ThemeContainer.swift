//
//  ThemeContainer.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/12/9.
//

/**
 * 主题数据容器，主要存储以下内容：
 * 1. 主题对象列表
 * 2. 各主题属性内容的缓存
 * 
 */
import UIKit

//主题容器提供的可获取的数据key
enum TCGetKey: Int {
    case currentTheme = 1000   //当前主题
    case allTheme = 1001   //所有主题列表
}


/**
 * 主题容器
 */
class ThemeContainer: OriginContainer
{
    //MARK: 属性
    var udAccessor = UserDefaultsAccessor.shared   //UserDefaulits存取器
    var plAccessor = PlistAccessor.shared    //plist存取器
    

    //MARK: 方法
    //初始化方法
    override init()
    {
        super.init()
        self.initCurrentTheme()
    }
    
    //初始化当前主题，尝试获取当前主题，如果没有，那么选择默认主题
    fileprivate func initCurrentTheme()
    {
        if let current = udAccessor.readString(key: currentThemeKey)
        {
            let themeDict = plAccessor.read(fileName: current)
            let curThemeModel = ThemeModel.mj_object(withKeyValues: themeDict)
            self.mutate(key: TCGetKey.currentTheme, value: CustomTheme.init(theme: curThemeModel!))
        }
        else
        {
            //默认选择粉红色主题
            let themeDict = plAccessor.read(fileName: sPinkThemeFileName)
            let curThemeModel = ThemeModel.mj_object(withKeyValues: themeDict)
            self.mutate(key: TCGetKey.currentTheme, value: CustomTheme.init(theme: curThemeModel!))
            //保存当前主题标识
            self.udAccessor.write(key: currentThemeKey, value: sPinkThemeFileName)
        }
    }
    
    //初始化一个主题对象
    //参数：themeName：主题配置文件名
    fileprivate func initCustomTheme(themeName: String) -> CustomTheme?
    {
        var theme: CustomTheme? = nil
        let themeConfig = plAccessor.read(fileName: themeName)
        let themeModel = ThemeModel.mj_object(withKeyValues: themeConfig)
        theme = CustomTheme.init(theme: themeModel!)
        return theme
    }
    
    //保存当前主题到UserDefaults
    override func commit(key: AnyHashable, value: Any)
    {
        if let k = key as? TCGetKey
        {
            if k == TCGetKey.currentTheme
            {
                udAccessor.write(key: currentThemeKey, value: value)
            }
        }
    }
    

}

/**
 * 提供给外部的交互接口
 */
extension ThemeContainer
{
    //获取当前主题
    func getCurrentTheme() -> CustomTheme
    {
        let theme = self.get(key: TCGetKey.currentTheme) as! CustomTheme
        return theme
    }
    
    //设置新的当前主题
    func setCurrentTheme(newTheme: CustomTheme)
    {
        self.mutate(key: TCGetKey.currentTheme, value: newTheme)
        self.commit(key: TCGetKey.currentTheme, value: newTheme.theme.fileName)
    }
    
    //获取所有主题列表
    func getAllTheme() -> [CustomTheme]
    {
        let themeArr = self.get(key: TCGetKey.allTheme)
        if let themeArray = themeArr as? [CustomTheme], themeArray.count > 0
        {
            return themeArray
        }
        else
        {
            let themeConfigArr = [sPinkThemeFileName, sRedThemeFileName, sBlueThemeFileName]
            var themeArray = [CustomTheme]()
            //遍历配置文件，创建主题对象
            for item in themeConfigArr
            {
                if let theme = self.initCustomTheme(themeName: item)
                {
                    themeArray.append(theme)
                }
            }
            //添加到数据容器
            self.mutate(key: TCGetKey.allTheme, value: themeArray)
            //返回容器中的数组数据
            return self.get(key: TCGetKey.allTheme) as! [CustomTheme]
        }
    }
    
    
}
