//
//  BasicProtocol.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/11/5.
//

/**
 * 程序中的基础定义，定义全局通用的接口方法和各种基础数据
 * 一般和具体的业务逻辑无关，而是关于程序和组件本身的定义
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
 * 接口协议
 * 表示这个extension中实现的方法都是接口协议中定义的，为了扩展该类型的功能，比如`Equatable`，`Comparable`或者自定义协议等
 */
protocol InterfaceProtocol {
    
}

/**
 * 外部接口方法协议
 * 这是个空协议，只是为了表示实现这个协议的extension中的方法是给外部程序调用的
 */
protocol ExternalInterface {
    
}

/**
 * 这个空协议规定内部类型
 * 如果一个类型要定义内部类型，那么在extension中实现这个空协议
 */
protocol InternalType {
    
}

/**
 * 这个空协议定义各种常量属性
 */
protocol ConstantPropertyProtocol {
    
}

/**
 * 这个空协议规定实现代理和通知代理的方法
 * 类型的这个extension中实现了各种组件的代理方法和通知中心回调方法
 */
protocol DelegateProtocol {
    
}


//MARK: 基础常量定义

///控制器的状态管理器最大步数，可在程序运行过程中改变，那么会影响改变之后创建的控制器的状态管理器步数
var vcStatusStep: Int = 5

//状态栏内容颜色定义
enum VCStatusBarStyle {
    case dark   //深色
    case light  //浅色
}

//VC返回按钮样式
enum VCBackStyle
{
    case none   //不显示返回按钮
    case dark   //深色返回按钮
    case light  //浅色返回按钮
    case close  //关闭按钮
    
    ///获得图片，如果是none则返回nil
    func getImage() -> UIImage?
    {
        switch self {
        case .none:
            return nil
        case .dark:
            return UIImage.iBackDark
        case .light:
            return UIImage.iBackLight
        case .close:
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
            la.frame = g_getWindow().bounds
            la.zPosition = -1
            la.colors = [UIColor.cGray_5B5B7E.cgColor, UIColor.cBlack_2C2C3D.cgColor]
            return la
        case .bgImage(let img, let alpha):
            let la = CALayer()
            let cgImg = img?.cgImage
            la.frame = g_getWindow().bounds
            la.zPosition = -1
            la.contents = cgImg
            la.opacity = alpha
            return la
        }
    }
    
}
