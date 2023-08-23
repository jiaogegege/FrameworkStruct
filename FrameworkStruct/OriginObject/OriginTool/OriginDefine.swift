//
//  OriginDefine.swift
//  FrameworkStruct
//
//  Created by  jggg on 2021/11/5.
//

/**
 * 定义全局通用的接口，此处定义的内容都比较宏观，并不涉及具体的实现，大多为通用接口协议和类型的定义
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

/**
 弃用方法的两种形式
 @available(*, deprecated, message: "Don't use this anymore")
 @available(iOS, introduced: 1.0, deprecated: 1.0, message: "Don't use this anymore")
 */


import Foundation

//MARK: 协议定义

/**
 * Origin协议
 */
protocol OriginProtocol {
    //任何实现该协议的类型
    associatedtype AnyType = Self
    
    /**
     * 返回类型的信息
     */
    func typeDesc() -> String
    
}

/**
 * 单例协议
 */
protocol SingletonProtocol {
    //任何实现该协议的类型
    associatedtype AnyType = Self
    
    static var shared: AnyType { get }
    
}

/**
 * 独一无二特性协议
 */
protocol UniqueProtocol {
    //对象的唯一id
    var uniqueId: String { get }
    
}

/**
 * 接口协议
 * 表示这个extension中实现的方法都是其他接口协议中定义的，为了扩展该类型的功能，比如`Equatable`，`Comparable`或者自定义协议等
 * 建议只在最终子类中使用该修饰性协议
 */
protocol InterfaceProtocol {
    
}

/**
 * 子类方法协议
 * 表示这个extension中的方法可以被子类和其他文件中的该类的extension调用，这个extension中的方法都是internal的，但是不应该被其他对象调用（因为swift没有`protected`，所以有这个空协议）
 */
protocol ProtectAvailable {
    
}

/**
 * 这个空协议规定实现代理和通知代理的方法
 * 类型的这个extension中实现了各种组件的代理方法和通知中心回调方法
 * 建议只在最终子类中使用该修饰性协议
 */
protocol DelegateProtocol {
    
}

/**
 * 这个空协议规定内部类型
 * 如果一个类型要定义内部类型，那么在extension中实现这个空协议
 * 建议只在最终子类中使用该修饰性协议
 */
protocol InternalType {
    
}

/**
 * 这个空协议定义各种常量属性
 * 建议只在最终子类中使用该修饰性协议
 */
protocol ConstantProtocol {
    
}

/**
 * 外部接口方法协议
 * 这是个空协议，只是为了表示实现这个协议的extension中的方法是给外部程序调用的
 * 建议只在最终子类中使用该修饰性协议
 */
protocol ExternalInterface {
    
}


//MARK: 常量定义
///Origin对象状态管理器步数定义
let originStatusStep: Int = 10


//MARK: 闭包类型定义
//参数和返回值都为空的闭包
typealias VoClo = (() -> Void)

//参数为泛型，返回为空的闭包
typealias GnClo<T> = ((T) -> Void)

//参数为可选泛型，返回为空的闭包
typealias OpGnClo<T> = ((T?) -> Void)

//2个参数为泛型，返回为空的闭包
typealias Gn2Clo<T1, T2> = ((T1, T2) -> Void)

//2个参数为可选泛型，返回为空的闭包
typealias OpGn2Clo<T1, T2> = ((T1?, T2?) -> Void)

//返回值为泛型的闭包
typealias RtGnClo<R> = (() -> R)

//返回值为可选泛型的闭包
typealias OpRtGnClo<R> = (() -> R?)

//1个参数为泛型，返回值为泛型的闭包
typealias GnRtClo<T, R> = ((T) -> R)

//参数为Any的闭包
typealias AnyClo = ((Any) -> Void)

//参数为可选Any的闭包
typealias OpAnyClo = ((Any?) -> Void)

//返回值为Any的闭包
typealias AnyRtClo = (() -> Any)

//返回值为可选Any的闭包
typealias OpAnyRtClo = (() -> Any?)

//参数为Bool的闭包
typealias BoClo = ((Bool) -> Void)

//参数为可选Bool的闭包
typealias OpBoClo = ((Bool?) -> Void)

//参数为Data的闭包
typealias DataClo = ((Data) -> Void)

//参数为可选Data的闭包
typealias OpDataClo = ((Data?) -> Void)

//参数为String的闭包
typealias StrClo = ((String) -> Void)

//参数为可选String的闭包
typealias OpStrClo = ((String?) -> Void)

//参数为Error的闭包
typealias ErrClo = ((Error) -> Void)

//参数为可选Error的闭包
typealias OpErrClo = ((Error?) -> Void)

//参数为NSError的闭包
typealias NSErrClo = ((NSError) -> Void)

//参数为可选NSError的闭包
typealias OpNSErrClo = ((NSError?) -> Void)

//参数为Exception的闭包
typealias ExpClo = ((FSException) -> Void)

//参数为可选Exception的闭包
typealias OpExpClo = ((FSException?) -> Void)
