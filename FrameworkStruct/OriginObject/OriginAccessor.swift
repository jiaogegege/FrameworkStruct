//
//  OriginAccessor.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/11/5.
//

/**
 * 最初的数据存取器
 */
import Foundation


/**
 * 数据存取器定义的通用接口，如果有通用的功能需要子类实现，那么定义在此处
 * 可以作为类型使用
 */
protocol AccessorProtocol
{
    /**
     * @说明：返回该数据存储器所操作的数据源相关信息
     * @返回值：返回的字典中包含以下key：type/...
     */
    func accessorInfo() -> Dictionary<String, String>
    
}


/**
 * 所有数据存取器的父类，如果有通用的功能，可以在此处实现
 * 所有子类命名都应该以`Accessor`结尾
 */
class OriginAccessor: NSObject
{
    //监控器，每一个存取器在创建的时候都要加入到监控器中
    fileprivate(set) weak var monitor: AccessorMonitor!
    
    //状态管理器
    var stMgr: StatusManager = StatusManager(capacity: originStatusStep)
    
    
    override init()
    {
        self.monitor = AccessorMonitor.shared
        super.init()
        monitor.addItem(self)
    }
}


//MARK: 实现协议
/**
 * 实现`AccessorProtocol`协议
 */
extension OriginAccessor: AccessorProtocol
{
    //返回数据源相关信息，如果是数据库存储器返回数据库的一些信息
    @objc func accessorInfo() -> Dictionary<String, String> {
        let infoDict = ["type": "none"]
        return infoDict
    }
    
}


/**
 * 实现`OriginProtocol`协议
 */
extension OriginAccessor: OriginProtocol
{
    func typeDesc() -> String
    {
        let typeStr = type(of: self)
        return typeStr.description()
    }
    
}
