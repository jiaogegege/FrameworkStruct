//
//  PriceEmbellisher.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/8/15.
//

/**
 价格修饰器，主要对价格进行不行样式的格式化
 */
import UIKit

class PriceEmbellisher: OriginEmbellisher {
    //MARK: 属性
    //单例
    static let shared = PriceEmbellisher()
    
    
    //MARK: 方法
    //私有化初始化方法
    private override init()
    {
        super.init()
    }
    
    override func copy() -> Any
    {
        return self
    }
    
    override func mutableCopy() -> Any
    {
        return self
    }

}


//外部接口
extension PriceEmbellisher: ExternalInterface
{
    
}
