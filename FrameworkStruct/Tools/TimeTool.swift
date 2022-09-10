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


//MARK: 日期字符串格式
enum TimeStringFormat: String
{
    //常用时间格式
    case slashYearMonthDayHourMinSecSSS = "YYYY/MM/dd HH:mm:ss.SSS"
    case slashYearMonthDayHourMinSec = "YYYY/MM/dd HH:mm:ss"
    case slashMonthDayHourMinSec = "MM/dd HH:mm:ss"
    case slashYearMonthDay = "YYYY/MM/dd"
    case slashMonthDay = "MM/dd"
    case slashMonthDayShort = "M/d"
    
    case dotYearMonthDayHourMinSecSSS = "YYYY.MM.dd HH:mm:ss.SSS"
    case dotYearMonthDayHourMinSec = "YYYY.MM.dd HH:mm:ss"
    case dotMonthDayHourMinSec = "MM.dd HH:mm:ss"
    case dotYearMonthDay = "YYYY.MM.dd"
    case dotMonthDay = "MM.dd"
    case dotMonthDayShort = "M.d"
    
    case dashYearMonthDayHourMinSecSSS = "YYYY-MM-dd HH:mm:ss.SSS"
    case dashYearMonthDayHourMinSec = "YYYY-MM-dd HH:mm:ss"
    case dashMonthDayHourMinSec = "MM-dd HH:mm:ss"
    case dashYearMonthDay = "YYYY-MM-dd"
    case dashMonthDay = "MM-dd"
    case dashMonthDayShort = "M-d"
    
    case hourMinSec = "HH:mm:ss"
    case hourMinSecSSS = "HH:mm:ss.SSS"
    
    case localYearMonthDayHourMinSecSSS = "yyyy年MM月dd日 HH时mm分ss秒SSS毫秒"
    case localYearMonthDayHourMinSec = "yyyy年MM月dd日 HH时mm分ss秒"
    case localMonthDayHourMinsec = "MM月dd日 HH时mm分ss秒"
    case localYearMonthDay = "yyyy年MM月dd日"
    case localMonthDay = "MM月dd日"
    case localMonthDayShort = "M月d日"
    case localHourMinSec = "HH时mm分ss秒"
    case localHourMinSecSSS = "HH时mm分ss秒SSS毫秒"
    
    //自定义时间组件
    enum TimeComponent: String {
        case year = "YYYY"
        case yearShort = "YY"
        case month = "MM"
        case monthShort = "M"
        case day = "dd"
        case dayShort = "d"
        case hour = "HH"
        case hourShort = "H"
        case min = "mm"
        case minShort = "m"
        case sec = "ss"
        case secShort = "s"
        case sss = "SSS"            //毫秒
    }
    
    ///时间组件分隔符
    enum TimeComponentSep: String {
        case slash = "/"
        case dash = "-"
        case dot = "."
        case local          //汉字，年月日时分秒
        
        static let year = "年"
        static let month = "月"
        static let day = "日"
        static let hour = "时"
        static let min = "分"
        static let sec = "秒"
        static let sss = "毫秒"
    }
    
    ///获取DateFormatter
    func getFormatter() -> DateFormatter
    {
        let formatter = DateFormatter()
        formatter.dateFormat = self.rawValue
        return formatter
    }
    
    ///获取自定义时间字符串的formatter
    static func getCustomFormatter(sepType: TimeComponentSep = .slash,
                                   year: TimeComponent? = nil,
                                   month: TimeComponent? = nil,
                                   day: TimeComponent? = nil,
                                   hour: TimeComponent? = nil,
                                   min: TimeComponent? = nil,
                                   sec: TimeComponent? = nil,
                                   sss: TimeComponent? = nil) -> DateFormatter
    {
        var timeStr: String = ""
        //年
        if let year = year {
            timeStr += year.rawValue
            //是否要分隔符
            if sepType == .local
            {
                timeStr += TimeComponentSep.year
            }
            else
            {
                //如果有月/日，那么追加分隔符
                if month != nil || day != nil
                {
                    timeStr += sepType.rawValue
                }
            }
            //没有月/日，有时/分/秒/毫秒，追加空格
            if month == nil && day == nil
            {
                if hour != nil || min != nil || sec != nil || sss != nil
                {
                    timeStr += String.sSpace
                }
            }
        }
        //月
        if let month = month {
            timeStr += month.rawValue
            //是否要分隔符
            if sepType == .local
            {
                timeStr += TimeComponentSep.month
            }
            else
            {
                //如果有日，那么追加分隔符
                if day != nil
                {
                    timeStr += sepType.rawValue
                }
            }
            //没有日，有时/分/秒/毫秒，追加空格
            if day == nil
            {
                if hour != nil || min != nil || sec != nil || sss != nil
                {
                    timeStr += String.sSpace
                }
            }
        }
        //日
        if let day = day {
            timeStr += day.rawValue
            //是否要分隔符
            if sepType == .local
            {
                timeStr += TimeComponentSep.day
            }
            //如果有时/分/秒/毫秒，追加空格
            if hour != nil || min != nil || sec != nil || sss != nil
            {
                timeStr += String.sSpace
            }
        }
        //时
        if let hour = hour {
            timeStr += hour.rawValue
            //是否要分隔符
            if sepType == .local
            {
                timeStr += TimeComponentSep.hour
            }
            else
            {
                //如果有分/秒/毫秒，追加分隔符
                if min != nil || sec != nil || sss != nil
                {
                    timeStr += String.sColon
                }
            }
        }
        //分
        if let min = min {
            timeStr += min.rawValue
            //是否要分隔符
            if sepType == .local
            {
                timeStr += TimeComponentSep.min
            }
            else
            {
                //如果有秒/毫秒，追加分隔符
                if sec != nil || sss != nil
                {
                    timeStr += String.sColon
                }
            }
        }
        //秒
        if let sec = sec {
            timeStr += sec.rawValue
            //是否要分隔符
            if sepType == .local
            {
                timeStr += TimeComponentSep.sec
            }
        }
        //毫秒
        if let sss = sss {
            //是否要分隔符
            if sepType != .local
            {
                timeStr += String.sDot
            }
            timeStr += sss.rawValue
            //是否要分隔符
            if sepType == .local
            {
                timeStr += TimeComponentSep.sss
            }
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = timeStr
        return formatter
    }
}


//MARK: 常用时间方法
///获取系统当前时间，OTC时间，"YYYY/MM/dd HH:mm:ss.SSS"
func currentTimeString(format: TimeStringFormat = .slashYearMonthDayHourMinSecSSS) -> String
{
    let formatter = format.getFormatter()
    // GMT时间 转字符串，直接是系统当前时间
    return formatter.string(from: Date())
}

///获取一个时间的字符串形式，时间组件可自定义，默认当前时间
func getTimeString(date: Date = Date(),
                   sepType: TimeStringFormat.TimeComponentSep = .slash,
                   year: TimeStringFormat.TimeComponent? = .year,
                   month: TimeStringFormat.TimeComponent? = .month,
                   day: TimeStringFormat.TimeComponent? = .day,
                   hour: TimeStringFormat.TimeComponent? = .hour,
                   min: TimeStringFormat.TimeComponent? = .min,
                   sec: TimeStringFormat.TimeComponent? = .sec,
                   sss: TimeStringFormat.TimeComponent? = nil) -> String
{
    let formatter = TimeStringFormat.getCustomFormatter(sepType: sepType, year: year, month: month, day: day, hour: hour, min: min, sec: sec, sss: sss)
    return formatter.string(from: date)
}

///获取系统当前时间距离1970年秒数，OTC时间
func currentTimeInterval() -> TimeInterval
{
    Date().timeIntervalSince1970
}

///判断某个时间有没有过期
///参数：criticalTimeStr:如果传入了过期时间，那么和传入时间比较；如果没有传入过期时间，那么和当前时间比较
///如果传入的时间都无法转换，那么返回true
func isTimePasted(_ timeStr: String, criticalTimeStr: String?, format: TimeStringFormat = .dashYearMonthDayHourMinSec) -> Bool
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

///在某个日期的基础上加上或减去几天返回新的日期
func dateByAdd(days: Int, baseDate: Date) -> Date
{
    let interval = TimeInterval(days) * tSecondsInDay
    let newDate = baseDate.addingTimeInterval(interval)
    return newDate
}

///当前时间往后一定时间，传入负值则往前
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
