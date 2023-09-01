//
//  BluetoothAdapter.swift
//  FrameworkStruct
//
//  Created by jggg on 2022/2/20.
//

/**
 * 蓝牙适配器
 * 1. 对于简单的蓝牙功能，可以直接和系统蓝牙进行对接
 * 2. 对于复杂的蓝牙框架和SDK，可以和封装的自定义蓝牙模块对接
 */
import UIKit

class BluetoothAdapter: OriginAdapter, SingletonProtocol
{
    typealias Singleton = BluetoothAdapter
    
    //单例
    static let shared = BluetoothAdapter()
    
    
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
