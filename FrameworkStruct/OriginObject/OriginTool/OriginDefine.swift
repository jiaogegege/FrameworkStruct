//
//  OriginDefine.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/11/5.
//

/**
 * 定义全局通用的接口
 *
 * - parameters:
 *  - <#参数1: #>
 *
 * - returns:
 *  - <#返回值#>
 *
 * - throws: <#异常说明#>
 *
 * - important: <#重要信息#>
 *
 * - warning: <#警告信息#>
 *
 * - attention: <#注意事项#>
 *
 * - note: <#提示信息#>
 *
 * - version: <#版本信息#>
 *
 */
import Foundation

//MARK: Origin协议定义
protocol OriginProtocol
{
    //任何实现该协议的类型
    associatedtype AnyType = Self
    
    /**
     * 返回类型的信息
     */
    func typeDesc() -> String
    
}


//MARK: 常量定义
///Origin对象状态管理器步数定义
let originStatusStep: Int = 10


//MARK: 闭包类型定义
//参数和返回值都为空的闭包
typealias VoidClosure = (() -> Void)

//返回NSError的闭包
typealias ErrorClosure = ((NSError) -> Void)
