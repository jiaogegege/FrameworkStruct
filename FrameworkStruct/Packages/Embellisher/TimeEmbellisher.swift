//
//  TimeEmbellisher.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/11/5.
//

/**
 * 时间修饰器
 * 1. 各种时间格式转换
 * 2. 定时器相关功能
 */
import UIKit

//日期字符串格式
enum TETimeFormat: String {
    case slashYearMonthDayHourMinSecSSS = "YYYY/MM/dd HH:mm:ss.SSS"
    case slashYearMonthDayHourMinSec = "YYYY/MM/dd HH:mm:ss"
    case slashYearMonthDay = "YYYY/MM/dd"
    case dashYearMonthDayHourMinSecSSS = "YYYY-MM-dd HH:mm:ss.SSS"
    case dashYearMonthDayHourMinSec = "YYYY-MM-dd HH:mm:ss"
    case dashYearMonthDay = "YYYY-MM-dd"
    
}

class TimeEmbellisher: OriginEmbellisher
{
    //获取系统当前时间
    static func getCurrentTime() -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/dd HH:mm:ss.SSS"// 自定义时间格式
        // GMT时间 转字符串，直接是系统当前时间
        return formatter.string(from: Date())
    }

}
