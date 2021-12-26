//
//  MacroConst.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/11/3.
//

/**
 * 定义各种常量和变量
 * 定义各种宏表达式
 */
import Foundation
import UIKit


/**
 * 宏定义和常量定义建议以`k`开头，表示常量，方便区分
 * 和常量配合使用的函数
 */
//屏幕长宽
let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height

//状态栏高度
let kStatusHeight: CGFloat = kScreenHeight >= 812.0 ? 44.0 : 20.0
//包含导航栏的安全高度
let kTopHeight: CGFloat = kScreenHeight >= 812.0 ? 88.0 : 64.0
//底部安全高度
let kBottomHeight: CGFloat = kScreenHeight >= 812.0 ? 34.0 : 0.0
//适配iPhoneX横屏时，左边刘海高度
let kLandscapeLeft: CGFloat = kScreenWidth >= 812.0 ? 34.0 : 0.0
//适配iPhoneX横屏时，底部白条高度
let kLandscapeBottom: CGFloat = kScreenWidth >= 812.0 ? 20.0 : 0.0
//iPhoneX和iPhone8状态栏高度差
let kBangGapToNormalHeight: CGFloat = kStatusHeight - 20.0

//iPhone屏幕宽度，iphonex和iphone，这两个值根据设计图选择，一般设计图都是以iPhone8和iPhoneX的尺寸为主
let kiPhoneXWidth: CGFloat = 414.0
let kiPhoneWidth: CGFloat = 375.0

//适配iPhone8设计图尺寸
func fit8(_ val: CGFloat) -> CGFloat
{
    return Utility.fitWidth(val: val, base: kiPhoneWidth)
}

//适配iPhoneX设计图尺寸
func fitX(_ val: CGFloat) -> CGFloat
{
    return Utility.fitWidth(val: val, base: kiPhoneXWidth)
}


//MARK: 自定义通知
enum FSNotification: String
{
    //切换主题的通知
    case changeTheme = "changeTheme"
    
    
    //如果通知有参数，那么用这个方法获得参数的key，目前只能支持一个参数key，如果有多个参数，只能手写字符串或者定义常量，或者将多个参数封装在一个对象中传递
    func paramKey() -> String
    {
        switch self
        {
            case .changeTheme:
                return "themeKey"   //后跟`ThemeProtocol`对象
        
        }
    }
    
}


