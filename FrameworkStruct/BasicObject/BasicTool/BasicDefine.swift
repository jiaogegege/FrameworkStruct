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
 * 这个空协议规定实现代理和通知代理的方法
 * 类型的这个extension中实现了各种组件的代理方法和通知中心回调方法
 */
protocol DelegateProtocol {
    
}


//MARK: 基础常量定义

//状态栏内容颜色定义
enum VCStatusBarStyle {
    case dark   //深色
    case light  //浅色
}

//VC返回按钮样式
enum VCBackStyle
{
    case dark   //深色返回按钮
    case light  //浅色返回按钮
    case close  //关闭按钮
    case none   //不显示返回按钮
    
}

//VC背景色样式，定义成枚举而非颜色常量的原因是，有可能背景是渐变色或者图像，可以在枚举中进行扩展
enum VCBackgroundStyle
{
    case none   //什么都不做
    case black  //0x000000
    case white  //0xffffff
    case lightGray  //0xf4f4f4
    case pink   //0xff709b
    case clear  //透明背景
    case gradientDark   //一种深色的渐变色，创建一个渐变图层
    case bgImage(img: UIImage?, alpha: CGFloat)   //背景是图片，绑定一个图片文件名参数，和透明度参数
    
    //返回颜色或者渐变图层或者图像图层或者nil
    //nil/UIColor/CALayer
    func getContent() -> Any
    {
        switch self {
        case .none:
            return UIColor.white    //暂时none返回白色背景
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
            la.frame = Utility.getWindow().bounds
            la.zPosition = -1
            la.colors = [UIColor.cGray_5B5B7E.cgColor, UIColor.cBlack_2C2C3D.cgColor]
            return la
        case .bgImage(let img, let alpha):
            let la = CALayer()
            let cgImg = img?.cgImage
            la.frame = Utility.getWindow().bounds
            la.zPosition = -1
            la.contents = cgImg
            la.opacity = Float(alpha)
            return la
        }
    }
    
}
