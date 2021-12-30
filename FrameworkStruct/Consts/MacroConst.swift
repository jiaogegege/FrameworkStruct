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


//MARK: 自定义通知
enum FSNotification: String
{
    //切换主题的通知
    case changeTheme
    
    
    //计算属性，获得通知字符串的名字，格式：项目名缩写+具体通知名称+通知后缀
    var name: Notification.Name {
        return Notification.Name(rawValue: "FS" + self.rawValue + "Notification")
    }

    //计算属性，如果通知有参数，那么用这个方法获得参数的key，目前只能支持一个参数key，如果有多个参数，只能手写字符串或者定义常量，或者将多个参数封装在一个对象中传递
    //返回的参数key就是类型的名字，可以是结构体名/类名/协议名
    var paramKey: String {
        switch self
        {
            case .changeTheme:
                return "ThemeProtocol"   //返回`ThemeProtocol`协议对象名字
            
        }
    }
    
}


/**
 * 宏定义和常量定义建议以`k`开头，表示常量，方便区分
 * 和常量配合使用的函数
 */
//项目名称
let kProjectName = "FrameworkStruct"

//APPID
let kAppId = "1476239189"

//appstore下载地址
let kAppStoreUrl = "https://itunes.apple.com/cn/app/id1476239189?mt=8"


//MARK: Storyboard文件名定义
//主界面
let kMainSB = "Main"
//启动界面
let kLaunchSB = "LaunchScreen"


//MARK: 正则表达式
//判断用户名的正则表达式，2-10位汉字+字母
let userNameRegex = "^[a-zA-Z\\u4E00-\\u9FA5]{2,10}$"
//国内手机号的正则表达式
let cellPhoneRegex = "^1\\d{10}$"
//一种密码的正则，8-12位大小写字母、数字、@#_
let passwordRegex = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[#@_])[0-9a-zA-Z#@_]{8,12}$"

