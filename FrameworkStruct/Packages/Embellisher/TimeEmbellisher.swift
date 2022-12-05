//
//  TimeEmbellisher.swift
//  FrameworkStruct
//
//  Created by  jggg on 2021/11/5.
//

/**
 * 时间修饰器
 * 1. 各种时间格式转换
 * 
 */
import UIKit

class TimeEmbellisher: OriginEmbellisher
{
    //MARK: 属性
    //单例
    static let shared = TimeEmbellisher()
    
    
    //MARK: 方法
    //私有化初始化方法
    private override init()
    {
        super.init()
    }
    
    override func copy() -> Any
    {
        return self
    }
    
    override func mutableCopy() -> Any
    {
        return self
    }

}


//内部类型
extension TimeEmbellisher: InternalType
{
    ///日期组件类型
    enum TEDateComponentType {
        case year, month, day, hour, minute, second
    }
    
    ///时间段
    enum TETimePeriod {
        case beforeDawn     //凌晨0-5
        case morning        //早晨5-8
        case forenoon       //上午8-11
        case noon           //中午11-13
        case afternoon      //下午13-16
        case evenfall       //傍晚16-19
        case evening        //晚上19-24
        
        //根据时间返回时间段
        static func getPeriod(_ date: Date) -> TETimePeriod
        {
            let dateComp = TimeEmbellisher.shared.dateComponents(from: date)
            var period: Self = .beforeDawn
            if let hour = dateComp.hour {
                switch hour {
                case 0..<5:
                    period = .beforeDawn
                case 5..<8:
                    period = .morning
                case 8..<11:
                    period = .forenoon
                case 11..<13:
                    period = .noon
                case 13..<16:
                    period = .afternoon
                case 16..<19:
                    period = evenfall
                case 19...24:
                    period = .evening
                default:
                    period = .beforeDawn
                }
            }
            return period
        }
    }
    
}


//接口方法
extension TimeEmbellisher: ExternalInterface
{
    ///将一个时间字符串转成Date
    ///参数：format：时间字符串格式
    func date(from str: String, format: TimeStringFormat = .slashYearMonthDayHourMinSec) -> Date?
    {
        format.getFormatter().date(from: str)
    }
    
    ///格式化年/月/日(时/分/秒)字符串为日期
    ///参数：aDate：一个日期；isShort：是否短格式，如果true，只有年月日，否则`年月日时分秒`
    func date(from localStr: String, isShort: Bool = false) -> Date?
    {
        let formatter = isShort ? TimeStringFormat.localYearMonthDay.getFormatter() : TimeStringFormat.localYearMonthDayHourMinSec.getFormatter()
        return formatter.date(from: localStr)
    }
    
    ///从一个时间戳获得Date
    func date(from timeStamp: TimeInterval) -> Date
    {
        Date(timeIntervalSince1970: timeStamp)
    }
    
    ///将一个Date转成时间字符串
    func string(from aDate: Date, format: TimeStringFormat = .slashYearMonthDayHourMinSec) -> String
    {
        format.getFormatter().string(from: aDate)
    }
    
    ///从一个时间戳获得日期字符串
    func string(from timeStamp: TimeInterval, format: TimeStringFormat = .slashYearMonthDayHourMinSec) -> String
    {
        string(from: date(from: timeStamp), format: format)
    }
    
    ///格式化日期为年/月/日(时/分/秒)形式
    ///参数：aDate：一个日期；isShort：是否短格式，如果true，只有年月日，否则`年月日时分秒`
    func localString(from aDate: Date, isShort: Bool = false) -> String
    {
        let formatter = isShort ? TimeStringFormat.localYearMonthDay.getFormatter() : TimeStringFormat.localYearMonthDayHourMinSec.getFormatter()
        return formatter.string(from: aDate)
    }
    
    ///从一个日期中单独获取年份/月份/日/等参数，默认返回`年月日时分秒`
    ///参数：aDate：一个日期；components：需要获取的日期组件
    func dateComponents(from aDate: Date, components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]) -> DateComponents
    {
        Calendar.current.dateComponents(components, from: aDate)
    }
    
    ///将秒数转换为分秒字符串
    ///参数：short：是否短格式，如果为false，那么不足两位的部分补0；如果为true，那么分钟位按实际计算结果显示
    func convertSecondsToMinute(_ seconds: Int, short: Bool = false) -> String
    {
        let minute = seconds / Int(tSecondsInMinute)
        let second = seconds % Int(tSecondsInMinute)
        return String(format: (short ? "%d:%02d" : "%02d:%02d"), minute, second)
    }
    
    ///将秒数转换为时分秒字符串
    func convertSecondsToHour(_ seconds: Int) -> String
    {
        let hour = seconds / Int(tSecondsInHour)
        let minute = seconds % Int(tSecondsInHour) / Int(tSecondsInMinute)
        let second = seconds % Int(tSecondsInMinute)
        return String(format: "%d:%02d:%02d", hour, minute, second)
    }
    
    ///得到一个日期并修改指定的日期组件，可修改项：年月日时分秒毫秒
    ///默认以当前日期为基准
    func dateByComponent(_ aDate: Date = Date(), year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil, nanosecond: Int? = nil) -> Date?
    {
        let calendar = Calendar.current
        var components: DateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: aDate)
        if let year = year {
            components.year = year
        }
        if let month = month {
            components.month = month
        }
        if let day = day {
            components.day = day
        }
        if let hour = hour {
            components.hour = hour
        }
        if let minute = minute {
            components.minute = minute
        }
        if let second = second {
            components.second = second
        }
        if let nanosecond = nanosecond {
            components.nanosecond = nanosecond
        }
        let newDate = calendar.date(from: components)
        return newDate
    }
    
    ///得到一个日期当天0点的日期，就是当天的0时0分0秒
    func dateByZeroTime(_ aDate: Date) -> Date?
    {
        dateByComponent(aDate, year: nil, month: nil, day: nil, hour: 0, minute: 0, second: 0, nanosecond: 0)
    }
    
    ///获取具体的时间的时间段描述
    func getPeriod(_ date: Date) -> TETimePeriod
    {
        TETimePeriod.getPeriod(date)
    }
    
    
    
}
