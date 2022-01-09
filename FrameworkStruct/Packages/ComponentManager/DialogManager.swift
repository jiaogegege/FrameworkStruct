//
//  DialogManager.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/1/9.
//

/**
 * 用于各种自定义弹窗的显示和生命周期管理
 */
import UIKit

class DialogManager: OriginManager
{
    //MARK: 属性
    //单例对象
    static let shared = DialogManager()
    
    
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
