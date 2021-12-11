//
//  OriginProtocol.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/11/5.
//

/**
 * 定义全局通用的接口
 *
 * - important:
 *
 * - warning:
 *
 * - attention:
 *
 * - note:
 *
 * - version:
 *
 * - parameters:
 *
 * - returns:
 *
 * - throws:
 *
 */
import Foundation

protocol OriginProtocol
{
    //任何实现该协议的类型
    associatedtype AnyType = Self
    
    /**
     * 返回类型的信息
     */
    func desString() -> String
    
}
