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
    
    //"iCloud"
    static let icloud = "iCloud"
    
    
    
    
    
    //获取对应的iPhoneX下的文件名
    func bangString() -> String
    {
        return self + String.bangSuffix
    }
    
}

//MARK: 项目中文案定义，国际化文案
extension String: ConstantPropertyProtocol
{
    //MARK: 项目中各种标题
    //app名称
    static let appName = localized("appName")
    //主页
    static let homeVC = localized("homeVC")
    //我的
    static let mineVC = localized("mineVC")
    //瀑布流
    static let waterfall = localized("waterfall")
    //主题选择
    static let themeSelect = localized("themeSelect")
    //模态显示
    static let modalShow = localized("modalShow")
    //约束测试
    static let constraintTest = localized("constraintTest")
    //绘制表格
    static let drawTable = localized("drawTable")
    //图层阴影
    static let layerShadow = localized("layerShadow")
    //动画演示
    static let animationDemo = localized("animationDemo")
    
    //MARK: 界面提示和按钮文案
    //确定
    static let confirm = localized("confirm")
    //取消
    static let cancel = localized("cancel")
    //成功
    static let success = localized("success")
    //失败
    static let failure = localized("failure")
    //我知道了
    static let iKnown = localized("iKnown")
    //从相册选择
    static let selectFromPhotoLibiary = localized("selectFromPhotoLibiary")
    //拍照
    static let takePhotoWithCamera = localized("takePhotoWithCamera")
    //新消息
    static let newMsg = localized("newMsg")
    //发送
    static let send = localized("send")
    //输入消息
    static let inputMessage = localized("inputMessage")
    
    //MARK: Toast文案
    
    //MARK: 通用错误信息
    //未知错误
    static let unknownError = localized("unknownError")
    //网络错误
    static let networkError = localized("networkError")
    //没有推送权限
    static let withoutAccessToPush = localized("withoutAccessToPush")
    //没有日历权限
    static let withoutCalendar = localized("withoutCalendar")
    //没有提醒事项权限
    static let withoutReminder = localized("withoutReminder")

    //MARK: 网络错误信息
    static let networkUnavailable = localized("networkUnavailable")
    static let networkDataParseError = localized("networkDataParseError")
    static let networkOk = localized("networkOk")
    static let networkCreated = localized("networkCreated")
    static let networkAccepted = localized("networkAccepted")
    static let networkNotFound = localized("networkNotFound")
    static let networkBadRequest = localized("networkBadRequest")
    static let networkNeedAuth = localized("networkNeedAuth")
    static let networkForbidden = localized("networkForbidden")
    static let networkTimeout = localized("networkTimeout")
    static let networkSystemError = localized("networkSystemError")
    static let networkNoService = localized("networkNoService")
    static let networkBadGetway = localized("networkBadGetway")
    static let networkServiceUnavailable = localized("networkServiceUnavailable")
    
    //MARK: 长文案
    //青少年模式弹窗内容
    static let teenagerProtectContent = localized("teenagerProtectContent")
    //进入青少年模式文字
    static let enterTeenMode = localized("setTeenagerMode")
    




    //便利方法
    static func localized(_ originStr: String) -> String
    {
//        return NSLocalizedString(originStr, tableName: "Localizable", bundle: Bundle.main, value: originStr, comment: originStr)
        return NSLocalizedString(originStr, comment: originStr)
    }
    
}
