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
 */
//屏幕长宽
let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height


//自定义通知
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


//VC返回按钮样式
enum VCBackStyle
{
    case dark, light, close, none
}

//VC背景色样式
enum VCBackgroundStyle
{
    case black  //0x000000
    case white  //0xffffff
    case lightGray  //0xf4f4f4
    case pink   //0xff709b
    case clear
    case none   //什么都不做
}
