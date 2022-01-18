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
    static let sWaterfall = localized("waterfall")
    //确定
    static let sConfirm = localized("confirm")
    //取消
    static let sCancel = localized("cancel")
    //主题选择
    static let sThemeSelect = localized("themeSelect")
    //模态显示
    static let sModalShow = localized("modalShow")
    //约束测试
    static let sConstraintTest = localized("constraintTest")
    //从相册选择
    static let sSelectFromPhotoLibiary = localized("selectFromPhotoLibiary")
    //拍照
    static let sTakePhotoWithCamera = localized("takePhotoWithCamera")
    //青少年模式弹窗内容
    static let sTeenagerProtectContent = localized("teenagerProtectContent")
    //进入青少年模式文字
    static let sEnterTeenMode = localized("setTeenagerMode")
    //我知道了
    static let sIKnown = localized("iKnown")
    //绘制表格
    static let sDrawTable = localized("drawTable")
    

    //便利方法
    static func localized(_ originStr: String) -> String
    {
//        return NSLocalizedString(originStr, tableName: "Localizable", bundle: Bundle.main, value: originStr, comment: originStr)
        return NSLocalizedString(originStr, comment: originStr)
    }
    
}
