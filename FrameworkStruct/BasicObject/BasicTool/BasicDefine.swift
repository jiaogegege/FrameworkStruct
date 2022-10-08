//
//  BasicProtocol.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/11/5.
//

/**
 * 程序中的基础定义，定义全局通用的接口方法和各种基础数据
 * 一般和具体的业务逻辑无关，而是关于程序和组件本身的定义
 * 此处定义的内容可以包含一些具体的功能逻辑，比较面对实际功能
 */
import Foundation
import UIKit

//MARK: 协议定义

/**
 * 基础协议
 */
protocol BasicProtocol
{
    
}


/**
 可归档解档协议
 */
protocol Archivable: NSCoding {
    associatedtype AnyType = Self
    
    //归档
    func archive() -> Data?
    
    //解档
    static func unarchive(_ data: Data) -> AnyType?
}

//协议基础实现
extension Archivable {
    func archive() -> Data?
    {
        ArchiverAdatper.shared.archive(self)
    }
    
    static func unarchive(_ data: Data) -> AnyType?
    {
        ArchiverAdatper.shared.unarchive(data) as? AnyType
    }
}


//MARK: 基础类型定义
///正则表达式
typealias RegexExpression = String

///谓词表达式
typealias PredicateExpression = String

///Javascript片段
typealias JavascriptExpression = String


//MARK: 基础常量定义

///控制器的状态管理器最大步数，可在程序运行过程中改变，那么会影响改变之后创建的控制器的状态管理器步数
let vcStatusStep: Int = 5

//状态栏内容颜色定义
enum VCStatusBarStyle {
    case dark   //深色
    case light  //浅色
}

//VC返回按钮样式
enum VCBackStyle
{
    case none                   //不显示返回按钮
    case dark                   //深色返回按钮，暗黑模式下白色
    case darkAlways             //深色返回按钮，暗黑模式下也是深色
    case darkThin               //深色细的返回按钮，暗黑模式下也是深色
    case lightAlways            //浅色返回按钮，暗黑模式下也是白色
    case darkClose              //深色关闭按钮，暗黑模式下白色
    
    ///获得图片，如果是none则返回nil
    func getImage() -> UIImage?
    {
        switch self {
        case .none:
            return nil
        case .dark:
            return UIImage.iBackDark
        case .darkAlways:
            return UIImage.iBackDarkAlways
        case .darkThin:
            return UIImage.iBackThinDarkAlways
        case .lightAlways:
            return UIImage.iBackLightAlways
        case .darkClose:
            return UIImage.iBackClose
        }
    }
}

//VC背景色样式，定义成枚举而非颜色常量的原因是，有可能背景是渐变色或者图像，可以在枚举中进行扩展
//这里的例子仅作参考，实际根据需求设计，如果有主题系统，背景设置为`none`跟随主题变化
enum VCBackgroundStyle
{
    case none   //什么都不做
    case black  //0x000000
    case white  //0xffffff
    case lightGray  //0xf4f4f4
    case pink   //0xff709b
    case clear  //透明背景
    case gradientDark   //一种深色的渐变色，创建一个渐变图层
    case bgImage(img: UIImage?, alpha: Float)   //背景是图片，绑定一个图片文件名参数，和透明度参数
    
    //返回颜色或者渐变图层或者图像图层
    //UIColor/CALayer
    //UIColor支持暗黑模式，如果是浅色的背景色，那么设置为一种黑色，深色的则返回深色
    func getContent() -> Any
    {
        switch self {
        case .none:
            return ThemeManager.shared.getCurrentOrDark().backgroundColor    //返回主题背景色
        case .black:
            return UIColor.black
        case .white:
            return UIColor.white
        case .lightGray:
            return UIColor.cGray_f4
        case .pink:
            return UIColor.cPink_ff709b
        case .clear:
            return UIColor.clear
        case .gradientDark:
            let la = CAGradientLayer()
            la.frame = g_window().bounds
            la.zPosition = -1
            la.colors = [UIColor.cGray_5B5B7E.cgColor, UIColor.cBlack_2C2C3D.cgColor]
            return la
        case .bgImage(let img, let alpha):
            let la = CALayer()
            let cgImg = img?.cgImage
            la.frame = g_window().bounds
            la.zPosition = -1
            la.contents = cgImg
            la.opacity = alpha
            return la
        }
    }
    
}
