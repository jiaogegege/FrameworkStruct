//
//  UnitTool.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/3/16.
//

/**
 * 物理量和单位换算
 */
import Foundation

//MARK: 温度
///摄氏度to开尔文
func C2K(_ c: Double) -> Double
{
    return c + 273.15
}

///开尔文to摄氏度
func K2C(_ k: Double) -> Double
{
    return k - 273.15
}

///摄氏度to华氏度
func C2F(_ c: Double) -> Double
{
    return 32.0 + c * 1.8
}

///华氏度to摄氏度
func F2C(_ f: Double) -> Double
{
    return (f - 32.0) / 1.8
}

//MARK: 长度
///米to英尺
func m2feet(_ m: Double) -> Double
{
    return m / 0.3048
}

///英尺to米
func feet2m(_ feet: Double) -> Double
{
    return feet * 0.3048
}

///英寸to厘米
func inch2cm(_ inch: Double) -> Double
{
    return inch * 2.54
}

///厘米to英寸
func cm2inch(_ cm: Double) -> Double
{
    return cm / 2.54
}

///码to米
func yard2m(_ yard: Double) -> Double
{
    return yard * 0.9144
}

///米to码
func m2yard(_ m: Double) -> Double
{
    return m / 0.9144
}

///英里to千米
func mile2km(_ mile: Double) -> Double
{
    return mile * 1.609344
}

///千米to英里
func km2mile(_ km: Double) -> Double
{
    return km / 1.609344
}

///海里to千米
func nmi2km(_ nmi: Double) -> Double
{
    return nmi * 1.852
}

///千米to海里
func km2nmi(_ km: Double) -> Double
{
    return km / 1.852
}

//MARK: 重量
///磅to千克
func pound2kg(_ pound: Double) -> Double
{
    return pound * 0.45359237
}

///千克to磅
func kg2pound(_ kg: Double) -> Double
{
    return kg / 0.45359237
}


//MARK: 压强
///汞柱高度to千帕
func mmHg2kPa(_ mmHg: Double) -> Double
{
    return mmHg / 7.5006168
}

///千帕to汞柱高度
func kPa2mmHg(_ kPa: Double) -> Double
{
    return kPa * 7.5006168
}


//MARK: 热量
///卡路里to焦耳
func cal2J(_ cal: Double) -> Double
{
    return cal * 4.184
}

///焦耳to卡路里
func J2cal(_ J: Double) -> Double
{
    return J / 4.184
}
