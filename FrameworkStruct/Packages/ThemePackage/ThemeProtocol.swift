//
//  ThemeProtocol.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/12/9.
//

/**
 * 主题协议，定义主题中有的内容，比如颜色，图片，字体等
 */
import Foundation

@objc protocol ThemeProtocol
{
    //MARK: 颜色
    //主题名
    var themeName: String {get}
    
    //主题色
    var mainColor: UIColor {get}
    
    //文本标题颜色
    var mainTitleColor: UIColor {get}
    
    //文本副标题颜色
    var subTitleColor: UIColor {get}
    
    //内容文本颜色（大段的文本）
    var contentTextColor: UIColor {get}
    
    //提示文本颜色
    var hintTextColor: UIColor {get}
    
    //MARK: 字体
    //主要字体
    var mainFont: UIFont {get}
    
    //次要字体
    var secondaryFont: UIFont {get}
    
    //提示性字体
    var hintFont: UIFont {get}
    
    //MARK: 图片
    //各种不同主题的图片都有相同的图片名，而后缀不一样，所以图片方法主要根据输入的图片名返回对应的图片对象
    func getImage(imgName: String) -> UIImage?
    
}
