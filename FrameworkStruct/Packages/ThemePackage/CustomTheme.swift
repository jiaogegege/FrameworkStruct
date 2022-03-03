//
//  CustomTheme.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/12/9.
//

/**
 * 主题对象，对应不同的主题
 */
import UIKit

class CustomTheme: ThemeProtocol
{
    //主题数据模型
    var theme: ThemeModel
    
    //初始化方法
    required init(theme: ThemeModel)
    {
        self.theme = theme
    }
    
    //MARK: 主题属性
    //主题名
    var themeName: String {
        return theme.name
    }
    
    //主色调
    var mainColor: UIColor {
        return UIColor.colorWithHex(colorStr: theme.mainColor)
    }
    //标题主色调
    var mainTitleColor: UIColor {
        return UIColor.colorWithHex(colorStr: theme.mainTitleColor)
    }
    //副标题
    var subTitleColor: UIColor {
        return UIColor.colorWithHex(colorStr: theme.subTitleColor)
    }
    //文本内容
    var contentTextColor: UIColor {
        return UIColor.colorWithHex(colorStr: theme.contentTextColor)
    }
    //提示文本
    var hintTextColor: UIColor {
        return UIColor.colorWithHex(colorStr: theme.hintTextColor)
    }
    //背景色
    var backgroundColor: UIColor {
        return UIColor.colorWithHex(colorStr: theme.backgroundColor)
    }
    //内容背景色
    var contentBackgroundColor: UIColor {
        return UIColor.colorWithHex(colorStr: theme.contentBackgroundColor)
    }
    //主字体
    var mainFont: UIFont {
        return UIFont.init(name: theme.mainFont, size: CGFloat(theme.mainFontSize.floatValue)) ?? UIFont.systemFont(ofSize: CGFloat(theme.mainFontSize.floatValue))
    }
    
    var secondaryFont: UIFont {
        return UIFont.init(name: theme.secondaryFont, size: CGFloat(theme.secondaryFontSize.floatValue)) ?? UIFont.systemFont(ofSize: CGFloat(theme.secondaryFontSize.floatValue))
    }
    
    var hintFont: UIFont {
        return UIFont.init(name: theme.hintFont, size: CGFloat(theme.hintFontSize.floatValue)) ?? UIFont.systemFont(ofSize: CGFloat(theme.hintFontSize.floatValue))
    }
    
    //获取图片，不同主题的图片后缀不同
    func getImage(imgName: String) -> UIImage? {
        let imgStr = imgName + self.theme.imageSuffix
        return UIImage(named: imgStr)
    }
    
   ///返回主题的名字
    func descString() -> String
    {
        return self.theme.name
    }
    
    ///是否暗黑主题
    func isDarkTheme() -> Bool
    {
        if self.theme.id == sDarkThemeId
        {
            return true
        }
        return false
    }
    

}
