//
//  OriginModel.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/11/26.
//

/**
 * 最初的数据模型
 *
 * - note：此处只是作为规范定义的示例，实际工程中可能会使用第三方框架，比如MJExtension，JSONModel等，根据实际情况使用
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


/**
 * 元数据,对数据模型的描述信息
 * - attention: 本来是定义成struct，但是在数据容器协议中无法转换为objC，因此定义成class
 */
class DataModelMeta: NSObject {
    /**
     * 数据模型在数据容器中进行传输的时候是否需要拷贝
     * 默认会拷贝；如果设置为false，数据模型在数据容器中传输时将不会拷贝，如果数据模型是类类型，则将以指针传递，数据会有被外部意外改变的风险，但是可以提高访问性能
     */
    var needCopy: Bool = true
    /**
     * 该数据是否可写入数据源
     * 如果设置为false，数据容器在进行commit的时候将会跳过该数据模型
     */
    var canCommit: Bool = true
    
    init(needCopy: Bool = true, canCommit: Bool = true)
    {
        self.needCopy = needCopy
        self.canCommit = canCommit
    }
    
}

