//
//  OriginDocument.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/11/29.
//

/**
 * 最初的文档对象
 */
import Foundation


/**
 * 文档对象定义的通用接口，如果有通用的功能需要子类实现，那么定义在此处
 * 可以作为类型使用
 */
protocol DocumentProtocol
{
    
}


/**
 * 所有文档对象的父类，如果有通用的功能，可以在此处实现
 * 所有子类命名都应该以`Document`结尾
 */
class OriginDocument: NSObject
{

}


//MARK: 实现协议
/**
 * 实现`DocumentProtocol`协议
 */
extension OriginDocument: DocumentProtocol
{
    
}


/**
 * 实现`OriginProtocol`协议
 */
extension OriginDocument: OriginProtocol
{
    func desString() -> String
    {
        let typeStr = type(of: self)
        return typeStr.description()
    }
    
}
