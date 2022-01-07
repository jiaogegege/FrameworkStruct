//
//  TimeTool.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/12/30.
//

/**
 * 时间日期相关常量、工具方法
 */
import Foundation

//一小时的秒数
let kSecondsInHour: TimeInterval = 3600

//一天的秒数
let kSecondsInDay: TimeInterval = 86400

//一年的秒数，非闰年
let kSecondsInYear: TimeInterval = 31536000
//一年的秒数，闰年
let kSecondsInLeapYear: TimeInterval = kSecondsInYear + kSecondsInDay


//日期字符串格式
enum DTStringFormat: String
{
    case slashYearMonthDayHourMinSecSSS = "YYYY/MM/dd HH:mm:ss.SSS"
    case slashYearMonthDayHourMinSec = "YYYY/MM/dd HH:mm:ss"
    case slashYearMonthDay = "YYYY/MM/dd"
    case dashYearMonthDayHourMinSecSSS = "YYYY-MM-dd HH:mm:ss.SSS"
    case dashYearMonthDayHourMinSec = "YYYY-MM-dd HH:mm:ss"
    case dashYearMonthDay = "YYYY-MM-dd"
    
}

//获取系统当前时间，OTC时间
func getCurrentTimeString() -> String
{
    let formatter = DateFormatter()
    formatter.dateFormat = DTStringFormat.slashYearMonthDayHourMinSecSSS.rawValue
    // GMT时间 转字符串，直接是系统当前时间
    return formatter.string(from: Date())
}

//获取系统当前时间距离1970年秒数，OTC时间
func getCurrentTimeInterval() -> TimeInterval
{
    let date = Date()
    return date.timeIntervalSince1970
}
