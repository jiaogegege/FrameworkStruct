//
//  DeviceTool.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/12/30.
//

/**
 * 和设备、系统相关的定义和方法
 */
import Foundation

//MARK: 屏幕尺寸相关定义
//屏幕宽高，写成计算属性是因为，在ipad或有些项目中，可以分屏、转屏
var kScreenWidth: CGFloat {
    return UIScreen.main.bounds.size.width
}
var kScreenHeight: CGFloat {
    return UIScreen.main.bounds.size.height
}

//iPhone屏幕高度
let kiPhone4Height: CGFloat = 480.0
let kiPhone5Height: CGFloat = 568.0
let kiPhone8Height: CGFloat = 667.0
let kiPhone8pHeight: CGFloat = 736.0
let kiPhoneXHeight: CGFloat = 812.0

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


//iPhone屏幕宽度，iphonex和iphone8，这两个值根据设计图选择，一般设计图都是以iPhone8和iPhoneX的尺寸为主
let kiPhone8Width: CGFloat = 375.0
let kiPhoneXWidth: CGFloat = 414.0

//根据基础UI的宽度计算缩放后的宽度
//参数1:需要适配的宽度值；参数2:作为比较基准的屏幕宽度
func fitWidth(val: CGFloat ,base: CGFloat) -> CGFloat
{
    let value = val * (kScreenWidth / base)
    return value
}

//适配iPhone8设计图尺寸
func fit8(_ val: CGFloat) -> CGFloat
{
    return fitWidth(val: val, base: kiPhone8Width)
}

//适配iPhoneX设计图尺寸
func fitX(_ val: CGFloat) -> CGFloat
{
    return fitWidth(val: val, base: kiPhoneXWidth)
}

//判断是否横屏
func isLandscape() -> Bool
{
    return UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight
}

//判断是否iPad
func isIpad() -> Bool
{
    return UIDevice.current.userInterfaceIdiom == .pad
}

//判断是否iPhone或者iPod
func isIphone() -> Bool
{
    return UIDevice.current.userInterfaceIdiom == .phone
}

//判断机型：iPhone4/iPhone5/iPhone8/iPhone8p/iPhoneX及以上
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

//判断条件：屏幕高度等于812或者大于812
func isIphoneXOrMore() -> Bool
{
    return kScreenHeight >= kiPhoneXHeight
}

//屏幕小于iPhoneX
func smallerThanIphoneX() -> Bool
{
    return kScreenHeight < kiPhoneXHeight
}

//屏幕小于iPhone8P
func smallerThanIphone8P() -> Bool
{
    return kScreenHeight < kiPhone8pHeight
}

//屏幕小于iPhone8
func smallerThanIphone8() -> Bool
{
    return kScreenHeight < kiPhone8Height
}
 

//MARK: iOS系统相关定义
//iOS系统版本
let kiOSVersion = (UIDevice.current.systemVersion as NSString).floatValue

///是否可用某个版本的系统
func sysAvailable(_ ver: Float) -> Bool
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
