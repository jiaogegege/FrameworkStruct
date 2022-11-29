//
//  DeviceTool.swift
//  FrameworkStruct
//
//  Created by  jggg on 2021/12/30.
//

/**
 * 和设备、系统相关的定义和方法
 */
import Foundation

//MARK: 设备相关定义
///设备唯一标志符
var kDeviceIdentifier: String? {
    return UIDevice.current.identifierForVendor?.uuidString
}

///手机别名： 用户定义的名称
let kPhoneName:String = UIDevice.current.name

///设备模型:iPhone/iPod touch
let kDeviceModel: String = UIDevice.current.model

///操作系统名称
let kSystemName:String = UIDevice.current.systemName

///操作系统版本
let kSystemVersion: String = UIDevice.current.systemVersion

///获取设备型号
var kDeviceModelName: String {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
        guard let value = element.value as? Int8, value != 0 else { return identifier }
        return identifier + String(UnicodeScalar(UInt8(value)))
    }

    switch identifier {
    case "iPod1,1":  return "iPod Touch 1"
    case "iPod2,1":  return "iPod Touch 2"
    case "iPod3,1":  return "iPod Touch 3"
    case "iPod4,1":  return "iPod Touch 4"
    case "iPod5,1":  return "iPod Touch (5 Gen)"
    case "iPod7,1":   return "iPod Touch 6"
    case "iPod9,1":   return "iPod Touch 7"

    case "iPhone3,1", "iPhone3,2", "iPhone3,3":  return "iPhone 4"
    case "iPhone4,1":  return "iPhone 4s"
    case "iPhone5,1":   return "iPhone 5"
    case  "iPhone5,2":  return "iPhone 5 (GSM+CDMA)"
    case "iPhone5,3":  return "iPhone 5c (GSM)"
    case "iPhone5,4":  return "iPhone 5c (GSM+CDMA)"
    case "iPhone6,1":  return "iPhone 5s (GSM)"
    case "iPhone6,2":  return "iPhone 5s (GSM+CDMA)"
    case "iPhone7,2":  return "iPhone 6"
    case "iPhone7,1":  return "iPhone 6 Plus"
    case "iPhone8,1":  return "iPhone 6s"
    case "iPhone8,2":  return "iPhone 6s Plus"
    case "iPhone8,4":  return "iPhone SE"
    case "iPhone9,1":   return "国行、日版、港行iPhone 7"
    case "iPhone9,2":  return "港行、国行iPhone 7 Plus"
    case "iPhone9,3":  return "美版、台版iPhone 7"
    case "iPhone9,4":  return "美版、台版iPhone 7 Plus"
    case "iPhone10,1","iPhone10,4":   return "iPhone 8"
    case "iPhone10,2","iPhone10,5":   return "iPhone 8 Plus"
    case "iPhone10,3","iPhone10,6":   return "iPhone X"
    case "iPhone11,2":   return "iPhone XS"
    case "iPhone11,4", "iPhone11,6":   return "iPhone XS Max"
    case "iPhone11,8":   return "iPhone XR"
    case "iPhone12,1":   return "iPhone 11"
    case "iPhone12,3":   return "iPhone 11 Pro"
    case "iPhone12,5":   return "iPhone 11 Pro Max"
    case "iPhone12,8":   return "iPhone SE 2"
    case "iPhone13,1":   return "iPhone 12 mini"
    case "iPhone13,2":   return "iPhone 12"
    case "iPhone13,3":   return "iPhone 12 Pro"
    case "iPhone13,4":   return "iPhone 12 Pro Max"
    case "iPhone14,2":   return "iPhone 13 Pro"
    case "iPhone14,3":   return "iPhone 13 Pro Max"
    case "iPhone14,4":   return "iPhone 13 mini"
    case "iPhone14,5":   return "iPhone 13"
    case "iPhone14,6":   return "iPhone SE 3"
    case "iPhone14,7":   return "iPhone 14"
    case "iPhone14,8":   return "iPhone 14 Plus"
    case "iPhone15,2":   return "iPhone 14 Pro"
    case "iPhone15,3":   return "iPhone 14 Pro Max"

    case "iPad1,1":   return "iPad"
    case "iPad1,2":   return "iPad 3G"
    case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":   return "iPad 2"
    case "iPad2,5", "iPad2,6", "iPad2,7":  return "iPad Mini"
    case "iPad3,1", "iPad3,2", "iPad3,3":  return "iPad 3"
    case "iPad3,4", "iPad3,5", "iPad3,6":   return "iPad 4"
    case "iPad4,1", "iPad4,2", "iPad4,3":   return "iPad Air"
    case "iPad4,4", "iPad4,5", "iPad4,6":  return "iPad Mini 2"
    case "iPad4,7", "iPad4,8", "iPad4,9":  return "iPad Mini 3"
    case "iPad5,1", "iPad5,2":  return "iPad Mini 4"
    case "iPad5,3", "iPad5,4":   return "iPad Air 2"
    case "iPad6,3", "iPad6,4":  return "iPad Pro 9.7"
    case "iPad6,7", "iPad6,8":  return "iPad Pro 12.9"
    case "iPad6,11", "iPad6,12":  return "iPad 5"
    case "iPad7,1", "iPad7,2":  return "iPad Pro 12.9 2nd"
    case "iPad7,3", "iPad7,4":  return "iPad Pro 10.5"
    case "iPad7,5", "iPad7,6":  return "iPad 6"
    case "iPad7,11", "iPad7,12":  return "iPad 7"
    case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":  return "iPad Pro 11"
    case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":  return "iPad Pro 12.9 3rd"
    case "iPad8,9", "iPad8,10":  return "iPad Pro 11 2nd"
    case "iPad8,11", "iPad8,12":  return "iPad Pro 12.9 4th"
    case "iPad11,1":  return "iPad Mini 5"
    case "iPad11,3", "iPad11,4":  return "iPad Air 3"
    case "iPad11,6", "iPad11,7":  return "iPad 8"
    case "iPad13,1", "iPad13,2":  return "iPad Air 4"
    case "iPad13,16", "iPad13,17":  return "iPad Air 5"
    case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7":  return "iPad Pro 11 3rd"
    case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11":  return "iPad Pro 12.9 5th"
    case "iPad14,1", "iPad14,2":  return "iPad Mini 6"
        
    case "AppleTV2,1":  return "Apple TV 2"
    case "AppleTV3,1","AppleTV3,2":  return "Apple TV 3"
    case "AppleTV5,3":   return "Apple TV 4"
        
    case "i386", "x86_64":   return "Simulator"
        
    default:  return identifier
    }
}


//MARK: 屏幕尺寸相关定义
///屏幕宽高，写成计算属性是因为，在ipad或有些项目中，可以分屏、转屏
var kScreenWidth: CGFloat {
    return UIScreen.main.bounds.size.width
}
var kScreenHeight: CGFloat {
    return UIScreen.main.bounds.size.height
}

///全屏大小尺寸
extension CGRect
{
    static var fullScreen: CGRect {
        CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
    }
}

///全屏大小尺寸
extension CGSize
{
    static var fullScreen: CGSize {
        CGSize(width: kScreenWidth, height: kScreenHeight)
    }
}

///iPhone屏幕高度
let kiPhone4Height: CGFloat = 480.0
let kiPhone5Height: CGFloat = 568.0
let kiPhone8Height: CGFloat = 667.0
let kiPhone8pHeight: CGFloat = 736.0
let kiPhoneXHeight: CGFloat = 812.0

///灵动岛安全高度(状态栏)
let kDynamicSafeTop: CGFloat = 51.0
///灵动岛安全底部
let kDynamicSafeBottom: CGFloat = 31.0

///状态栏高度，包含刘海和灵动岛
var kStatusHeight: CGFloat {
    if #available(iOS 13.0, *)
    {
//        return g_window().windowScene?.statusBarManager?.statusBarFrame.size.height ?? (kScreenHeight >= 812.0 ? 44.0 : 20.0)
        /* 适配灵动岛状态栏高度 */
        return g_window().safeAreaInsets.top
    }
    else
    {
        return UIApplication.shared.statusBarFrame.size.height
    }
}
///包含导航栏的安全高度
let kSafeTopHeight: CGFloat = kStatusHeight + 44.0
///底部安全高度
let kSafeBottomHeight: CGFloat = kScreenHeight >= 812.0 ? 34.0 : 0.0
///适配iPhoneX横屏时，左边刘海高度
let kLandscapeLeft: CGFloat = kScreenWidth >= 812.0 ? 34.0 : 0.0
///适配iPhoneX横屏时，底部白条高度
let kLandscapeBottom: CGFloat = kScreenWidth >= 812.0 ? 20.0 : 0.0
///iPhoneX和iPhone8状态栏高度差
let kGapBetweenBangToNormalStatusHeight: CGFloat = kStatusHeight - 20.0


///iPhone屏幕宽度，iphonex和iphone8，这两个值根据设计图选择，一般设计图都是以iPhone8和iPhoneX的尺寸为主
let kiPhone8Width: CGFloat = 375.0
let kiPhoneXWidth: CGFloat = 414.0

///根据基础UI的宽度计算缩放后的宽度
///参数1:需要适配的宽度值；参数2:作为比较基准的屏幕宽度
func fitWidth(val: CGFloat, base: CGFloat) -> CGFloat
{
    return val * (kScreenWidth / base)
}

///适配iPhone8设计图尺寸
func fit8(_ val: CGFloat) -> CGFloat
{
    return fitWidth(val: val, base: kiPhone8Width)
}

///适配iPhoneX设计图尺寸
func fitX(_ val: CGFloat) -> CGFloat
{
    return fitWidth(val: val, base: kiPhoneXWidth)
}

///判断是否是灵动岛机型
func isDynamicIsland() -> Bool
{
    return kStatusHeight >= kDynamicSafeTop
}

///判断是否iPad
func isIpad() -> Bool
{
    return UIDevice.current.userInterfaceIdiom == .pad
}

///判断是否iPhone或者iPod
func isIphone() -> Bool
{
    return UIDevice.current.userInterfaceIdiom == .phone
}

///判断机型：iPhone4/iPhone5/iPhone8/iPhone8p/iPhoneX及以上
func isIphone4() -> Bool
{
    return doubleEqual(Double(kScreenHeight), Double(kiPhone4Height))
}

func isIphone5() -> Bool
{
    return doubleEqual(Double(kScreenHeight), Double(kiPhone5Height))
}

func isIphone8() -> Bool
{
    return doubleEqual(Double(kScreenHeight), Double(kiPhone8Height))
}

func isIphone8P() -> Bool
{
    return doubleEqual(Double(kScreenHeight), Double(kiPhone8pHeight))
}

///判断条件：屏幕高度等于812或者大于812
func isIphoneXOrMore() -> Bool
{
    return kScreenHeight >= kiPhoneXHeight
}

///屏幕小于iPhoneX
func smallerThanIphoneX() -> Bool
{
    return kScreenHeight < kiPhoneXHeight
}

///屏幕小于iPhone8P
func smallerThanIphone8P() -> Bool
{
    return kScreenHeight < kiPhone8pHeight
}

///屏幕小于iPhone8
func smallerThanIphone8() -> Bool
{
    return kScreenHeight < kiPhone8Height
}
 

//MARK: iOS系统相关定义
///iOS系统版本
let kiOSVersion: Float = (kSystemVersion as NSString).floatValue

///是否可用某个版本的系统
func iOSAvailable(_ ver: Float) -> Bool
{
    if kiOSVersion >= ver
    {
        return true
    }
    else
    {
        return false
    }
}
