//
//  iCloudAdapter.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/9/22.
//


/**
 iCloud存储适配器
 主要用来在iCloud中保存和同步数据
 */
import UIKit
import CloudKit

class iCloudAdapter: OriginAdapter {
    //MARK: 属性
    //单例
    static let shared = iCloudAdapter()
    
    //key-value存储管理器
    fileprivate lazy var kvMgr: NSUbiquitousKeyValueStore = NSUbiquitousKeyValueStore.default
    
    
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


//内部类型
extension iCloudAdapter: InternalType
{
    ///iCloud存储容器id
    static let iCloudIdentifier = "iCloud.FrameworkStruct"
    
}


//接口方法
extension iCloudAdapter: ExternalInterface
{
    /**************************************** key-value存储 Section Begin ***************************************/
    func save()
    {
        
    }
    
    /**************************************** key-value存储 Section End ***************************************/
    
}
