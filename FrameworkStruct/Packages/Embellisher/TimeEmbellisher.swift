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

class TimeEmbellisher: OriginEmbellisher
{
    //获取系统当前时间，OTC时间
    static func getCurrentTimeString() -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = DTStringFormat.slashYearMonthDayHourMinSecSSS.rawValue
        // GMT时间 转字符串，直接是系统当前时间
        return formatter.string(from: Date())
    }
    
    //获取系统当前时间距离1970年秒数，OTC时间
    static func getCurrentTimeInterval() -> TimeInterval
    {
        let date = Date()
        return date.timeIntervalSince1970
    }

}
