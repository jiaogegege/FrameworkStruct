//
//  iCloudAdapter.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/9/22.
//


/**
 iCloud存储适配器
 主要用来在iCloud中保存和同步数据
 
 配置方法：
 在开发者中心的AppIDs页面勾选iCloud，并配置添加Containers，identifier建议填写项目的bundleID，可配置多个；创建profile并下载安装；在Xcode的Capabilities中添加iCloud并勾选需要的服务，再勾选Containers
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
    ///iCloud存储容器id，根据实际配置修改
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
