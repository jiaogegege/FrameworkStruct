//
//  DateTimeConst.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/12/30.
//

/**
 * 时间日期相关常量定义
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
