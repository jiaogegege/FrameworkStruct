//
//  StringConst.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/11/5.
//

/**
 * 定义各种文案和字符串
 * 仅定义纯粹的字符串，而不定义含有特殊意义的字符串
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
    
    
    //MARK: 工程中通用错误信息文案
    
    
    
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
    static var sWaterfall = localized("waterfall")
    //确定
    static var sConfirm = localized("confirm")
    //取消
    static var sCancel = localized("cancel")
    //主题选择
    static var sThemeSelect = localized("themeSelect")
    //模态显示
    static var sModalShow = localized("modalShow")
    //约束测试
    static var sConstraintTest = localized("constraintTest")
    //从相册选择
    static var sSelectFromPhotoLibiary = localized("selectFromPhotoLibiary")
    //拍照
    static var sTakePhotoWithCamera = localized("takePhotoWithCamera")

    

    //便利方法
    static func localized(_ originStr: String) -> String
    {
//        return NSLocalizedString(originStr, tableName: "Localizable", bundle: Bundle.main, value: originStr, comment: originStr)
        return NSLocalizedString(originStr, comment: originStr)
    }
    
}
