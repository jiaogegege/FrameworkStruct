//
//  DatasContainer.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/2/15.
//

/**
 * 集中的数据容器
 * 对于小规模的数据，可以将项目中使用的所有数据模型都放在这个容器中；对于大型项目，数据模型很多，可以根据模块划分创建多个数据容器，然后综合到这个集中的数据容器中，当然也可以独立访问，根据实际情况取舍
 */
import UIKit

class DatasContainer: OriginContainer
{
    //MARK: 属性
    //单例
    static let shared = DatasContainer()
    
    
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

//接口方法
extension DatasContainer: ExternalInterface
{
    
}
