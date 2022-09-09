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

//MARK: 类型定义
///整数区间类型
typealias IntRangeType = (Int, Int)
///浮点数区间类型
typealias FloatRangeType = (Float, Float)
typealias DoubleRangeType = (Double, Double)


///数字枚举器
///输入一个数字区间，按照设定的步长枚举出一个数列
///注意：目前只支持从小到大枚举,step为正数
struct NumberEnumerator<T: Numeric & Comparable> {
    fileprivate(set) var min: T     //最小值
    fileprivate(set) var max: T     //最大值
    fileprivate(set) var step: T    //枚举的步长
    fileprivate(set) var current: T //当前值
    
    init(range: (T, T), step: T) {
        min = minBetween(range.0, range.1)
        max = maxBetween(range.0, range.1)
        self.step = step
        current = min - step     //先把当前值设置为一个较小的值
    }
    
    ///每一次调用返回一个数值，根据步长不断累加，如果最后一个数值也返回过了，下次调用返回nil，根据nil判断是否结束
    mutating func next() -> T?
    {
        if current < min   //第一次返回min
        {
            current = min
        }
        else if current + step <= max
        {
            current += step
        }
        else    //如果超过最大值，那么返回nil
        {
            current += step
            return nil
        }
        return current
    }
    
    ///根据位置来获取枚举项，从0开始，超过最大值返回nil
    func enumAt(_ index: Int) -> T?
    {
        let val = min + T(exactly: index)! * step
        if val <= max
        {
            return val
        }
        return nil
    }
    
    ///是否全部枚举完毕
    var isOver: Bool {
        return current >= max
    }
    
    ///重置到初始状态
    mutating func reset()
    {
        current = min - step
    }
    
}


//MARK: 实用方法
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

///判断某个数字是否在一个区间范围内(包含)
func numberInInterval<T: Comparable>(_ val: T, lhs: T, rhs: T) -> Bool
{
    //计算最小最大范围
    let min = minBetween(lhs, rhs)
    let max = maxBetween(lhs, rhs)
    //大于等于最小值，小于等于最大值
    if val >= min && val <= max
    {
        return true
    }
    return false
}

///求两个数值中的最大值
func maxBetween<T: Comparable>(_ one: T, _ other: T) -> T
{
    return one >= other ? one : other
}

///求两个数值中的最小值
func minBetween<T: Comparable>(_ one: T, _ other: T) -> T
{
    return one <= other ? one : other
}

///限制一个数值的取值在最大最小区间（包含）
func limitInterval<T: Comparable>(_ value: T, min: T, max: T) -> T
{
    //先判断最大最小值，防止传错
    let minV = minBetween(min, max)
    let maxV = maxBetween(min, max)
    
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

///产生一个[0, +∞)或(-∞, 0]之间的随机整数
///如果边界是负数，必定返回负数；正数同理
func randomInt(_ border: Int) -> Int
{
    let ret = arc4random_uniform(UInt32(abs(border)))   //0~max-1的整数
    return border < 0 ? -Int(ret) : Int(ret)
}

///产生一个[0,1]之间的随机小数
func randomOne() -> Float
{
    //0～100的整数
    let random: Float = Float(arc4random_uniform(101))
    return random / 100.0
}
