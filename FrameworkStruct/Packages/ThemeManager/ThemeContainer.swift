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

//主题容器提供的数据key
enum ThemeContainerDataKey: Int {
    case currentTheme = 0   //当前主题
    case allTheme = 1   //所有主题列表
}

class ThemeContainer: OriginContainer {
    var udAccessor = UserDefaultsAccessor.shared   //UserDefaulits存取器
    var plAccessor = PlistAccessor.shared    //plist存取器
    

    //初始化方法
    override init() {
        super.init()
        self.getCurrentTheme()
    }
    
    //尝试获取当前主题，如果没有，那么选择默认主题
    func getCurrentTheme()
    {
        if let current = udAccessor.readString(key: currentThemeKey)
        {
            let themeDict = plAccessor.read(fileName: current)
            let curThemeModel = ThemeModel.mj_object(withKeyValues: themeDict)
            self.mutate(key: ThemeContainerDataKey.currentTheme, value: CustomTheme.init(theme: curThemeModel!))
        }
        else
        {
            let themeDict = plAccessor.read(fileName: sPinkThemeFileName)
            let curThemeModel = ThemeModel.mj_object(withKeyValues: themeDict)
            self.mutate(key: ThemeContainerDataKey.currentTheme, value: CustomTheme.init(theme: curThemeModel!))
            //保存当前主题标识
            self.udAccessor.write(key: currentThemeKey, value: sPinkThemeFileName)
        }
    }
    
    //获取所有主题列表
    
}
