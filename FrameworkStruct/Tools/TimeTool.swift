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

///一分钟的秒数
let tSecondsInMinute: TimeInterval = 60

///一小时的秒数
let tSecondsInHour: TimeInterval = 3600

///一天的秒数
let tSecondsInDay: TimeInterval = 86400

///一周的秒数
let tSecondsInWeek: TimeInterval = 604800

///28天的秒数
let tSecondsInMonth_28: TimeInterval = 2419200
///29天的秒数
let tSecondsInMonth_29: TimeInterval = 2505600
///30天的秒数
let tSecondsInMonth_30: TimeInterval = 2592000
///31天的秒数
let tSecondsInMonth_31: TimeInterval = 2678400

///一年的秒数，非闰年
let tSecondsInYear: TimeInterval = 31536000

///一年的秒数，闰年
let tSecondsInLeapYear: TimeInterval = 31622400


///日期字符串格式
enum TimeStringFormat: String
{
    case slashYearMonthDayHourMinSecSSS = "YYYY/MM/dd HH:mm:ss.SSS"
    case slashYearMonthDayHourMinSec = "YYYY/MM/dd HH:mm:ss"
    case slashYearMonthDay = "YYYY/MM/dd"
    case slashMonthDay = "MM/dd"
    case slashMonthDayShort = "M/d"
    case dashYearMonthDayHourMinSecSSS = "YYYY-MM-dd HH:mm:ss.SSS"
    case dashYearMonthDayHourMinSec = "YYYY-MM-dd HH:mm:ss"
    case dashMonthDayHourMinSec = "MM-dd HH:mm:ss"
    case dashYearMonthDay = "YYYY-MM-dd"
    case dashMonthDay = "MM-dd"
    case dashMonthDayShort = "M-d"
    case localYearMonthDayHourMinuteSecond = "yyyy年MM月dd日 HH时mm分ss秒"
    case localMonthDayHourMinsec = "MM月dd日 HH时mm分ss秒"
    case localYearMonthDay = "yyyy年MM月dd日"
    case localMonthDay = "MM月dd日"
    case localMonthDayShort = "M月d日"
    
    ///获取DateFormatter
    func getFormatter() -> DateFormatter
    {
        let formatter = DateFormatter()
        formatter.dateFormat = self.rawValue
        return formatter
    }
}

///获取系统当前时间，OTC时间，"YYYY/MM/dd HH:mm:ss.SSS"
func currentTimeString(format: TimeStringFormat = .slashYearMonthDayHourMinSecSSS) -> String
{
    let formatter = format.getFormatter()
    // GMT时间 转字符串，直接是系统当前时间
    return formatter.string(from: Date())
}

///获取系统当前时间距离1970年秒数，OTC时间
func currentTimeInterval() -> TimeInterval
{
    let date = Date()
    return date.timeIntervalSince1970
}

///判断某个时间有没有过期
///参数：criticalTimeStr:如果传入了过期时间，那么和传入时间比较；如果没有传入过期时间，那么和当前时间比较
///如果传入的时间都无法转换，那么返回true
func isTimePasted(timeStr: String, criticalTimeStr: String?, format: TimeStringFormat = .dashYearMonthDayHourMinSec) -> Bool
{
    let formatter = format.getFormatter()
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

///在某个时间基础上增加一定秒数
func dateByAdd(_ interal: TimeInterval, baseDate: Date) -> Date
{
    return baseDate.addingTimeInterval(interal)
}

///在某个日期的基础上加上几天返回新的日期
func dateByAdd(days: Int, baseDate: Date) -> Date
{
    let interval = TimeInterval(days) * tSecondsInDay
    let newDate = baseDate.addingTimeInterval(interval)
    return newDate
}

///当前时间往后一定时间
func nowAfter(_ interval: TimeInterval) -> Date
{
    return dateByAdd(interval, baseDate: Date())
}

///两个日期之间间隔的天数，计算结果取整数部分
func daysBetween(aDate: Date, another: Date)-> Int
{
    let interval = another.timeIntervalSince1970 - aDate.timeIntervalSince1970
    let days = abs(Int(interval / tSecondsInDay))
    return days
}
