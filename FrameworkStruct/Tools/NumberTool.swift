//
//  NumberTool.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/12/30.
//

/**
 * 定义各种数字计算、转换相关的工具方法
 */
import Foundation

///两个Double数字是否相等，比较它们差值的误差小于系统定义的最小误差
func doubleEqual(_ a: Double, _ b: Double) -> Bool
{
    return fabs(a - b) < Double.ulpOfOne
}

///两个Float数字是否相等，比较它们差值的误差小于系统定义的最小误差
func floatEqual(_ a: Float, _ b: Float) -> Bool
{
    return fabsf(a - b) < Float.ulpOfOne
}

///求两个数值中的最大值
func maxBetween<T: Comparable>(one: T, other: T) -> T
{
    return one >= other ? one : other
}

///求两个数值中的最小值
func minBetween<T: Comparable>(one: T, other: T) -> T
{
    return one <= other ? one : other
}

///限制一个数值的取值在最大最小区间（包含）
func limitInterval<T: Comparable>(_ value: T, min: T, max: T) -> T
{
    //先判断最大最小值，防止传错
    let minV = minBetween(one: min, other: max)
    let maxV = maxBetween(one: min, other: max)
    
    var val = value
    if val > maxV
    {
        val = maxV
    }
    else if val < minV
    {
        val = minV
    }
    return val
}

///限制一个数值在0.0和1.0之间
func limitIntervalInOne(_ value: Double) -> Double
{
    return limitInterval(value, min: 0.0, max: 1.0)
}

///限制一个数值的最小值
func limitMin<T: Comparable>(_ value: T, min: T) -> T
{
    var val = value
    if val < min
    {
        val = min
    }
    return val
}

///限制一个数值的最大值
func limitMax<T: Comparable>(_ value: T, max: T) -> T
{
    var val = value
    if val > max
    {
        val = max
    }
    return val
}

///判断一个字符串是否整数
func isInteger(str: String) -> Bool
{
    var ret = false
    do {
        let regex = try NSRegularExpression(pattern: integerRegex, options: [])
        let result = regex.firstMatch(in: str, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, str.count))
        ret = result != nil ? true : false
    }
    catch {
        print("regex error:str -> \(error)")
    }
    return ret
}

///判断一个字符串是否是浮点数
func isFloat(str: String) -> Bool
{
    var ret = false
    do {
        let regex = try NSRegularExpression(pattern: floatRegex, options: [])
        let result = regex.firstMatch(in: str, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, str.count))
        ret = result != nil ? true : false
    }
    catch {
        print("regex error:str -> \(error)")
    }
    return ret
}

///判断一个字符串是否是数字，包括整数和浮点数
func isNumber(str: String) -> Bool
{
    return isInteger(str: str) || isFloat(str: str)
}

///判断一个数字是否是偶数
func isEven(_ num: Int) -> Bool
{
    if num % 2 == 0
    {
        return true
    }
    return false
}

///判断一个数字是否是奇数
func isOdd(_ num: Int) -> Bool
{
    if num % 2 == 0
    {
        return false
    }
    return true
}
