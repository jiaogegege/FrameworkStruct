//
//  OriginModel.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/11/26.
//

/**
 * 最初的数据模型
 *
 * - note：此处只是作为规范的定义，实际工程中可能会使用第三方框架，比如MJExtension，JSONModel等，根据实际情况使用
 *
 */
import Foundation


/**
 * 数据模型定义的通用接口，如果有通用的功能需要子类实现，那么定义在此处
 * 可以作为类型使用
 */
protocol ModelProtocol
{
    
}


/**
 * 所有数据模型的父类，如果有通用的功能，可以在此处实现
 * 所有子类命名都应该以`Model`结尾
 */
class OriginModel: NSObject
{
    
}


//MARK: 实现协议
/**
 * 实现`ModelProtocol`协议
 */
extension OriginModel: ModelProtocol
{
    
}


/**
 * 实现`OriginProtocol`协议
 */
extension OriginModel: OriginProtocol
{
    func typeDesc() -> String
    {
        let typeStr = type(of: self)
        return typeStr.description()
    }
    
}
