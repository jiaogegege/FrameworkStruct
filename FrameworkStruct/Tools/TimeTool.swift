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

///一小时的秒数
let tSecondsInHour: TimeInterval = 3600

///一天的秒数
let tSecondsInDay: TimeInterval = 86400

///一年的秒数，非闰年
let tSecondsInYear: TimeInterval = 31536000

///一年的秒数，闰年
let tSecondsInLeapYear: TimeInterval = tSecondsInYear + tSecondsInDay


///日期字符串格式
enum TimeStringFormat: String
{
    case slashYearMonthDayHourMinSecSSS = "YYYY/MM/dd HH:mm:ss.SSS"
    case slashYearMonthDayHourMinSec = "YYYY/MM/dd HH:mm:ss"
    case slashYearMonthDay = "YYYY/MM/dd"
    case dashYearMonthDayHourMinSecSSS = "YYYY-MM-dd HH:mm:ss.SSS"
    case dashYearMonthDayHourMinSec = "YYYY-MM-dd HH:mm:ss"
    case dashYearMonthDay = "YYYY-MM-dd"
    
}

///获取系统当前时间，OTC时间，"YYYY/MM/dd HH:mm:ss.SSS"
func getCurrentTimeString() -> String
{
    let formatter = DateFormatter()
    formatter.dateFormat = TimeStringFormat.slashYearMonthDayHourMinSecSSS.rawValue
    // GMT时间 转字符串，直接是系统当前时间
    return formatter.string(from: Date())
}

///获取系统当前时间距离1970年秒数，OTC时间
func getCurrentTimeInterval() -> TimeInterval
{
    let date = Date()
    return date.timeIntervalSince1970
}

///判断某个时间有没有过期
///参数：criticalTimeStr:如果传入了过期时间，那么和传入时间比较，如果没有传入过期时间，那么和当前时间比较
///如果传入的时间都无法转换，那么返回true
func isTimePasted(timeStr: String, criticalTimeStr: String?) -> Bool
{
    let formatter = DateFormatter()
    formatter.dateFormat = TimeStringFormat.dashYearMonthDayHourMinSec.rawValue
    let date = formatter.date(from: timeStr)    //要判断的时间
    var criticalDate: Date?
    if let critical = criticalTimeStr
    {
        criticalDate = formatter.date(from: critical)
    }
    else
    {
        criticalDate = Date()
    }
    if let dd = date, let cd = criticalDate
    {
        let timeInterval = dd.timeIntervalSince1970 - cd.timeIntervalSince1970
        return timeInterval > 0 //如果大于0，那么没过期，否则过期
    }
    
    return true
}
