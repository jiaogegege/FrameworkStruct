//
//  NumberTool.swift
//  FrameworkStruct
//
//  Created by  jggg on 2021/12/30.
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


///限制取值范围的属性包装器
@propertyWrapper struct LimitNumRange<T: Comparable>
{
    private var value: T
    private var min: T
    private var max: T
    
    var wrappedValue: T {
        get {
            value
        }
        set {
            value = limitIn(newValue, min: min, max: max)
        }
    }
    
    init(wrappedValue: T, min: T, max: T) {
        assert(min <= wrappedValue && max >= wrappedValue, "\(wrappedValue) is not between \(min) - \(max)")
        self.value = wrappedValue
        self.min = min
        self.max = max
    }
}

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
func numberIn<T: Comparable>(_ val: T, lhs: T, rhs: T) -> Bool
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
    one >= other ? one : other
}

///求一个数组中的最大值
func maxIn<T: Comparable>(_ arr: [T]) -> T?
{
    guard arr.count > 0 else {
        return nil
    }
    
    var max: T = arr.first!
    for ele in arr
    {
        if ele > max
        {
            max = ele
        }
    }
    return max
}

///求两个数值中的最小值
func minBetween<T: Comparable>(_ one: T, _ other: T) -> T
{
    one <= other ? one : other
}

///求一个数组中的最小值
func minIn<T: Comparable>(_ arr: [T]) -> T?
{
    guard arr.count > 0 else {
        return nil
    }
    
    var min: T = arr.first!
    for ele in arr
    {
        if ele < min
        {
            min = ele
        }
    }
    return min
}

///限制一个数值的取值在最大最小区间（包含）
func limitIn<T: Comparable>(_ value: T, min: T, max: T) -> T
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
func limitInOne(_ value: Double) -> Double
{
    return limitIn(value, min: 0.0, max: 1.0)
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

///产生一个[0, +∞)或(-∞, 0]之间的随机整数，不包含`border`
///如果边界是负数，必定返回负数；正数同理
///reset：重置随机数种子
func randomInt(_ border: Int, reset: Bool = false) -> Int
{
    if reset
    {
        arc4random_stir()   //使随机数更随机
    }
    let ret = arc4random_uniform(UInt32(abs(border)))   //0~max-1的整数
    return border < 0 ? -Int(ret) : Int(ret)
}

///产生一个[min, max]之间的随机正整数，范围为0～+∞
///reset：重置随机数种子
func randomIn(_ min: UInt, _ max: UInt, reset: Bool = false) -> UInt
{
    //先转换到以[0, max - min + 1)为边界
    let range: (UInt, UInt) = (0, maxBetween(min, max) - minBetween(min, max) + 1)
    //计算随机数
    if reset
    {
        arc4random_stir()   //使随机数更随机
    }
    let rand: UInt = UInt(arc4random_uniform(UInt32(range.1)))
    //获取设定的范围内的值
    return rand + minBetween(min, max)
}

///产生一个[0,1]之间的随机小数
///precision：精度，保留几位小数，默认2位小数
///reset：重置随机数种子
func randomInOne(_ precision: UInt = 2, reset: Bool = false) -> Double
{
    //计算精度
    let base: UInt = UInt(pow(10, Double(precision)))
    if reset
    {
        arc4random_stir()   //使随机数更随机
    }
    //0～base的整数
    let random: Double = Double(arc4random_uniform(UInt32(base) + 1))
    //计算小数
    return (random / Double(base))
}
