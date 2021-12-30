//
//  NumberConst.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/12/30.
//

/**
 * 定义各种数字相关的常量和计算方法
 */
import Foundation

//两个Double数字是否相等，比较它们差值的误差小于系统定义的最小误差
func doubleEqual(_ a: Double, _ b: Double) -> Bool
{
    return fabs(a - b) < Double.ulpOfOne
}

//两个Float数字是否相等，比较它们差值的误差小于系统定义的最小误差
func floatEqual(_ a: Float, _ b: Float) -> Bool
{
    return fabsf(a - b) < Float.ulpOfOne
}
