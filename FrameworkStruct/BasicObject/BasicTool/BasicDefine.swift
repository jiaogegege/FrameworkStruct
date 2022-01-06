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
//VC返回按钮样式
enum VCBackStyle
{
    case dark, light, close, none
}

//VC背景色样式
enum VCBackgroundStyle
{
    case none   //什么都不做
    case black  //0x000000
    case white  //0xffffff
    case lightGray  //0xf4f4f4
    case pink   //0xff709b
    case clear
    
}
