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

class ThemeContainer: OriginContainer {
    var udAcs = UDAccessor.shared
    var plAcs = PlistAccessor.shared
    //当前主题
    var currentTheme: CustomTheme!
    
    //初始化方法
    override init() {
        super.init()
        self.getCurrentTheme()
    }
    
    //尝试获取当前主题，如果没有，那么选择默认主题
    func getCurrentTheme()
    {
        if let current = udAcs.readString(key: currentThemeKey)
        {
            let themeDict = plAcs.read(fileName: current)
            let curThemeModel = ThemeModel.mj_object(withKeyValues: themeDict)
            self.currentTheme = CustomTheme.init(theme: curThemeModel!)
        }
        else
        {
            let themeDict = plAcs.read(fileName: sPinkThemeFileName)
            let curThemeModel = ThemeModel.mj_object(withKeyValues: themeDict)
            self.currentTheme = CustomTheme.init(theme: curThemeModel!)
            //保存当前主题
            self.udAcs.write(key: currentThemeKey, value: sPinkThemeFileName)
        }
    }
    
    //获取所有主题列表
    
}
