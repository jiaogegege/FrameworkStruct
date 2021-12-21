//
//  ToastManager.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2021/12/19.
//

/**
 * toast管理器
 * 使用SVProgressHUD、MBProgressHUD或其他Toast组件
 */
import UIKit

class ToastManager: OriginManager
{
    //MARK: 属性
    //单例对象
    static let shared = ToastManager()
    
    
    //MARK: 方法
    //私有化init方法
    private override init()
    {
        super.init()
    }
    
    //重写复制方法
    override func copy() -> Any
    {
        return self
    }
        
    //重写复制方法
    override func mutableCopy() -> Any
    {
        return self
    }
    
}
