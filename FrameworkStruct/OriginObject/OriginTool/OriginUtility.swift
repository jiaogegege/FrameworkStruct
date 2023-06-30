//
//  OriginUtility.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/10/22.
//

/**
 Origin常用方法
 */
import Foundation

//MARK: 常用方法
//对变量加锁，用于多线程访问
func synchronized(_ obj: Any, closure: VoClo)
{
    objc_sync_enter(obj)
    closure()
    objc_sync_exit(obj)
}
