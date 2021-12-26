//
//  StringConst.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/11/5.
//

/**
 * 定义各种文案和字符串
 */
import Foundation

//MARK: 项目通用字符串定义
/**
 * 通用字符串建议以`s`开头，表示`string`，方便区分
 */
//项目名称
let sProjectName = "FrameworkStruct"

//APPID
let sAppId = "1476239189"













//MARK: 项目中文案定义，国际化文案
extension String
{
    //瀑布流
    static var sWaterfall = localized(originStr: "waterfall")
    //确定
    static var sConfirm = localized(originStr: "confirm")
    //取消
    static var sCancel = localized(originStr: "cancel")
    //主题选择
    static var sThemeSelect = localized(originStr: "themeSelect")
    //模态显示
    static var sModalShow = localized(originStr: "modalShow")
    //约束测试
    static var constraintTest = localized(originStr: "constraintTest")
    
    
    
    
    //便利方法
    static func localized(originStr: String) -> String
    {
        return NSLocalizedString(originStr, comment: originStr)
    }
    
}

//MARK: Storyboard文件名定义
//主界面
let sMainSB = "Main"
//启动界面
let slaunchSB = "LaunchScreen"
