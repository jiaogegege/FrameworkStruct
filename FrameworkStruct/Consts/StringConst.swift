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

//MARK: 对String的扩展，包括一些实用方法和常量定义
extension String
{
    //iPhoneX资源文件后缀
    static let bangSuffix = "_bang"
    
    
    //获取对应的iPhoneX下的文件名
    func bangString() -> String
    {
        return self + String.bangSuffix
    }
    
}

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
    static var sConstraintTest = localized(originStr: "constraintTest")
    

    //便利方法
    static func localized(originStr: String) -> String
    {
        return NSLocalizedString(originStr, comment: originStr)
    }
    
}
