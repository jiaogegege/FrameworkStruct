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

protocol BasicProtocol
{
    
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
