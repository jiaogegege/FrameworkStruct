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
 * 宏定义和常量定义建议以`g`开头，表示全局常量，方便区分
 * 和常量配合使用的函数
 */
//项目名称
let gProjectName = "FrameworkStruct"

//APPID，修改成AppStore分配的值
let gAppId = "1476239189"

//App名称
let gAppName: String = Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String

//app版本
let gAppVersion: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String

//app build版本
let gAppBuildVersion: String = Bundle.main.infoDictionary!["CFBundleVersion"] as! String

//app完整版本
let gAppFullVersion: String = gAppVersion + "." + gAppBuildVersion

//AppStore下载地址
let gAppStoreDownloadUrl = "https://itunes.apple.com/cn/app/id\(gAppId)?mt=8"

//AppStore评分地址
let gAppStoreCommentUrl = "itms-apps://itunes.apple.com/app/id\(gAppId)?action=write-review"


//MARK: Storyboard文件名定义
//启动界面
let gLaunchSB = "LaunchScreen"
//主界面
let gMainSB = "Main"
//我的界面
let gMineSB = "Mine"


//MARK: 全局通用自定义通知，其它模块中如果需要定义通知，可以扩展该类，并新增static变量
class FSNotification
{
    //原始值
    var rawValue: String
    //如果通知有参数，那么用这个属性获得参数的key，目前只能支持一个参数key，如果有多个参数，只能手写字符串或者定义常量，或者将多个参数封装在一个对象中传递
    //返回的参数key就是类型的名字，可以是结构体名/类名/协议名
    var paramKey: String?
    
    //初始化
    init(value: String, paramKey: String? = nil) {
        self.rawValue = value
        self.paramKey = paramKey
    }
    
    //计算属性，获得通知字符串的名字，格式：项目名缩写+具体通知名称+通知后缀
    var name: Notification.Name {
        return Notification.Name(rawValue: "FS_" + self.rawValue + "_Notification")
    }
    
    
    ///全局通知枚举值
    static let changeTheme = FSNotification(value: "changeTheme", paramKey: "ThemeProtocol")                        //切换主题的通知
    
}


//MARK: 全局通用错误和异常信息定义
enum FSError: Int, Error {
    case unknownError = -1                   //未知错误，如果没有其他任何匹配的错误，那么使用这个
    
    case networkError = 10001                //网络错误
    case noPushError = 10002                 //没有推送权限
    case noCalendarError = 10003             //没有日历权限
    case noReminderError = 10004             //没有提醒事项权限
    
    //error domain
    static let errorDomain: String = "FSErrorDomain"
    
    //获取错误文案
    var desc: String {
        switch self {
        case .unknownError:
            return String.unknownError
        case .networkError:
            return String.networkError
        case .noPushError:
            return String.withoutAccessToPush
        case .noCalendarError:
            return String.withoutCalendar
        case .noReminderError:
            return String.withoutReminder
        }
    }
    
    //获取NSError对象
    func getError() -> NSError
    {
        return NSError(domain: NSCocoaErrorDomain, code: self.rawValue, userInfo: [NSLocalizedDescriptionKey: self.desc, NSLocalizedFailureReasonErrorKey: self.desc])
    }
}


/**************************************** 枚举选项示例 Section Begin ****************************************/
///枚举选项定义
struct Sports: OptionSet
{
    let rawValue: UInt
    
    static let running = Sports(rawValue: 1) //里面的数字是自己定义的，但不能随意定义，必须是2的非负整数次方
    static let cycling = Sports(rawValue: 2)
    static let swimming = Sports(rawValue: 4)
    static let fencing = Sports(rawValue: 8)
    static let shooting = Sports(rawValue: 16)
    static let horseJumping = Sports(rawValue: 32)
}
//使用
//func test()
//{
//    let triathlon: Sports = [.swimming,.fencing]
//    if triathlon.contains(.shooting) {
//        print("包含shooting")
//    } else {
//        print("no包含shooting")
//    }
//    if triathlon.contains(.swimming) {
//        print("包含")
//    }
//}
/**************************************** 枚举选项示例 Section End ****************************************/
