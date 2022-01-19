//
//  OriginProtocol.swift
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

protocol OriginProtocol
{
    //任何实现该协议的类型
    associatedtype AnyType = Self
    
    /**
     * 返回类型的信息
     */
    func desString() -> String
    
}
