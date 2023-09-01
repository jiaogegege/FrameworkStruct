//
//  CalendarAdapter.swift
//  FrameworkStruct
//
//  Created by jggg on 2022/2/20.
//

/**
 * 系统日历提醒事项适配器
 * 主要对接系统日历和提醒事项相关功能
 * EventKit结构图：https://oscimg.oschina.net/oscnet/ed2d13bab02d964f8a6a7ebd49e9755fbb9.jpg
 */
import UIKit
import EventKit
import EventKitUI

class CalendarAdapter: OriginAdapter
{
    //MARK: 属性
    //单例
    static let shared = CalendarAdapter()
    
    //event数据库
    fileprivate var store: EKEventStore = EKEventStore()
    
    //默认日历名称
    fileprivate var defaultCalendarName = String.appName
    //当前日历，本app创建的日历，如果任何情况下都无法获取自定义日历，那么使用默认日历
    fileprivate var currentCalendar: EKCalendar?
    //当前提醒事项列表，本app创建的列表，如果任何情况下都无法获取自定义列表，那么使用默认列表
    fileprivate var currentReminder: EKCalendar?
    
    //是否能使用日历
    fileprivate var isCalendarGranted: Bool = false
    //是否能使用提醒事项
    fileprivate var isReminderGranted: Bool = false
    
    
    //MARK: 方法
    //私有化初始化方法
    private override init()
    {
        super.init()
        self.getAuthorizationStatus()
        self.setCurrent()
        self.addNotification()
    }
    
    override func copy() -> Any
    {
        return self
    }
    
    override func mutableCopy() -> Any
    {
        return self
    }
    
    //获取权限状态
    fileprivate func getAuthorizationStatus()
    {
        self.isCalendarGranted = EKEventStore.authorizationStatus(for: .event) == .authorized ? true : false
        self.isReminderGranted = EKEventStore.authorizationStatus(for: .reminder) == .authorized ? true : false
    }
    
    //添加通知
    fileprivate func addNotification()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(storeChanged(notification:)), name: NSNotification.Name.EKEventStoreChanged, object: nil)
    }
    
    //设置当前日历
    fileprivate func setCurrent()
    {
        if self.isCalendarGranted
        {
        self.currentCalendar = self.getCalendar(with: self.defaultCalendarName) //初始化后设置当前日历，如果没有，则为default
            if self.currentCalendar == nil
            {
                self.currentCalendar = store.defaultCalendarForNewEvents
            }
        }
        
        if self.isReminderGranted
        {
            self.currentReminder = self.getReminder(with: self.defaultCalendarName)
            //初始化后设置当前日历，如果没有，则为default
            if self.currentReminder == nil
            {
                self.currentReminder = store.defaultCalendarForNewReminders()
            }
        }
    }
    
    //申请日历权限
    //参数：type:日历或提醒事项;completion:返回申请结果
    fileprivate func authorize(type: EKEntityType, completion: @escaping (_ can: Bool) -> Void)
    {
        if type == .event
        {
            //日历权限
            store.requestAccess(to: .event) {[weak self] (isGranted, error) in
//                FSLog("Calendar Permission Granted:\(isGranted)")
                self?.isCalendarGranted = isGranted
                //如果获取到权限，那么在系统日历中创建一个以app名称为名称的新日历
                var err: Error?
                self?.createNewCalendar(name: self!.defaultCalendarName, err: &err)
                if err != nil
                {
                    FSLog("create calendar error: \(err!.localizedDescription)")
                }
                completion(isGranted)
            }
        }
        else if type == .reminder
        {
            //提醒事项权限
            store.requestAccess(to: .reminder) {[weak self] (isGranted, error) in
//                FSLog("Reminder Permission Granted:\(isGranted)")
                self?.isReminderGranted = isGranted
                //如果获取到权限，那么在提醒事项中创建一个以app名称为名称的新列表
                var err: Error?
                self?.createNewReminder(name: self!.defaultCalendarName, err: &err)
                if err != nil
                {
                    FSLog("create calendar error: \(err!.localizedDescription)")
                }
                completion(isGranted)
            }
        }
    }
    
}


//代理通知方法
extension CalendarAdapter: DelegateProtocol
{
    ///处理日历事件改变的通知
    @objc func storeChanged(notification: Notification)
    {
        
    }
}


//内部类型
extension CalendarAdapter: InternalType
{
    //日历源，目前提供icloud或者local，可以增加更多选项
    enum CACalendarSourceType {
        case icloud
        case local
        
        //判断传入的source是否是对应的source
        func isSource(_ source: EKSource) -> Bool
        {
            switch self {
            case .icloud:
                if source.sourceType == .calDAV && source.title == String.iCloud
                {
                    return true
                }
                return false
            case .local:
                return source.sourceType == .local ? true : false
            }
        }
    }
    
    ///本地保存事件的key，当成功创建一个事件后，事件会生成一个随机的id，将这个id保存下来，方便以后根据id读取事件
    ///key的定义根据实际需求，有几种类型的事件就创建几个key
    enum CAEventRemindKey: String {
        case eventDefault
        
        case remindDefault
        
        //保存事件id，具体保存在什么数据源中，根据实际需求取舍，可以是UserDefaults，或者数据库等
        func save(_ id: String)
        {
            //保存到数据源
        }
        
        //从数据源读取事件id
        func read() -> String
        {
            return ""
        }
    }
    
    ///事件持续时间
    enum CAEventDurationType {
        case day(Int = 1)       //持续n天
        case week(Int = 1)      //持续n周
        case month(Int = 1)     //持续n月
        case year(Int = 1)      //持续n年
        
        //获取整个事件结束时刻
        func getEndDate() -> Date
        {
            switch self {
            case .day(let duration):
                return nowAfter(Double(duration) * tSecondsInDay)
            case .week(let duration):
                return nowAfter(Double(duration) * tSecondsInWeek)
            case .month(let duration):
                let cal = Calendar.current
                var dateCom = cal.dateComponents([.year, .month, .day], from: Date())
                if let mo = dateCom.month
                {
                    dateCom.setValue(mo + 1, for: .month)
                }
                return cal.date(from: dateCom) ?? nowAfter(Double(duration) * tSecondsInMonth_30)
            case .year(let duration):
                return nowAfter(Double(duration) * tSecondsInYear)
            }
        }
    }
    
    ///事件重复规则
    enum CAEventRepeatType {
        case none                       //不重复
        case daily(Int = 1)             //每n天重复一次
        case weekly(Int = 1)            //每n周重复一次
        case monthly(Int = 1)           //每n月重复一次
        case yearly(Int = 1)            //每n年重复一次
        case twoDays                    //每2天重复一次
        case weekday(Int = 1)           //每n周工作日重复
        case weekend(Int = 1)           //每n周周末重复
        
        //获取重复规则对象，参数：结束日期
        func getRepeatRule(endDate: Date) -> EKRecurrenceRule?
        {
            let end = EKRecurrenceEnd(end: endDate)
            switch self {
            case .none:
                return nil
            case .daily(let count):
                return EKRecurrenceRule(recurrenceWith: .daily, interval: count, daysOfTheWeek: nil, daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: end)
            case .weekly(let count):
                return EKRecurrenceRule(recurrenceWith: .weekly, interval: count, daysOfTheWeek: nil, daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: end)
            case .monthly(let count):
                return EKRecurrenceRule(recurrenceWith: .monthly, interval: count, daysOfTheWeek: nil, daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: end)
            case .yearly(let count):
                return EKRecurrenceRule(recurrenceWith: .yearly, interval: count, daysOfTheWeek: nil, daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: end)
            case .twoDays:
                return EKRecurrenceRule(recurrenceWith: .daily, interval: 2, daysOfTheWeek: nil, daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: end)
            case .weekday(let count):
                return EKRecurrenceRule(recurrenceWith: .weekly, interval: count, daysOfTheWeek: [.init(.monday), .init(.tuesday), .init(.wednesday), .init(.thursday), .init(.friday)], daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: end)
            case .weekend(let count):
                return EKRecurrenceRule(recurrenceWith: .weekly, interval: count, daysOfTheWeek: [.init(.saturday), .init(.sunday)], daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: end)
            }
        }
    }
    
    ///给事件添加闹钟的类型
    enum CAEventAlarmType {
        case absolute(Date)     //添加一个绝对时间
        case relative(TimeInterval)     //添加一个相对时间，负数为提前
        
        case preFiveMinute      //提前5分钟提醒的闹钟
        case preOneMinute       //提前1分钟提醒
        case afterOneMinute     //延后1分钟
        case afterFiveMinute    //延后5分钟
        
        //获取闹钟
        func getAlarm() -> EKAlarm
        {
            switch self {
            case .absolute(let dt):
                return EKAlarm(absoluteDate: dt)
            case.relative(let inter):
                return EKAlarm(relativeOffset: inter)
            case .preFiveMinute:
                return EKAlarm(relativeOffset: -tSecondsInMinute * 5)
            case .preOneMinute:
                return EKAlarm(relativeOffset: -tSecondsInMinute)
            case .afterOneMinute:
                return EKAlarm(relativeOffset: tSecondsInMinute)
            case .afterFiveMinute:
                return EKAlarm(relativeOffset: tSecondsInMinute * 5)
            }
        }
    }
    
    ///搜索提醒事项类型
    enum CAReminderSearchType {
        case inComplete     //未完成的
        case completed      //已完成的
        case all            //所有
    }
    
}


//接口方法
extension CalendarAdapter: ExternalInterface
{
    /**************************************** 日历操作 Section Begin ****************************************/
    ///日历授权状态
    var canUseCalendar: Bool {
        return self.isCalendarGranted
    }
    
    ///获取日历权限
    func authorizeCalendar(_ completion: @escaping (_ can: Bool) -> Void)
    {
        self.authorize(type: .event, completion: completion)
    }
    
    ///获取所有日历
    func getAllCalendars() -> Array<EKCalendar>?
    {
        guard canUseCalendar else {
            return nil
        }
        
        return store.calendars(for: .event)
    }
    
    //获取所有日历的标题
    func getAllCalendarTitles() -> [String]
    {
        let calendars = self.getAllCalendars()
        let titleArr = calendars?.map({ (calendar) -> String in
            return calendar.title
        })
        return titleArr ?? []
    }
    
    ///根据name获取calendar，如果有同名的，那么获取第一个;如果没有，返回nil
    func getCalendar(with name: String) -> EKCalendar?
    {
        if let calendars = self.getAllCalendars()
        {
            for cal in calendars
            {
                if cal.title == name
                {
                    return cal
                }
            }
        }
        return nil
    }
    
    ///添加新日历
    ///说明：一般大部分情况下建议一个app仅添加一个日历，添加日历是根据name判断重复，所以如果添加多个日历，保证name唯一并能够区分
    ///参数：
    ///name:日历名称，必须唯一，可以用作标志符，默认就是app名称
    ///sourceType:日历来源，默认icloud日历，如果没有icloud，那么使用local日历
    ///color:日历颜色，默认使用默认主题色
    ///err:错误信息，如果有的话
    func createNewCalendar(name: String,
                           sourceType: CACalendarSourceType = .icloud,
                           color: UIColor = UIColor.cAccent!,
                           err: inout Error?)
    {
        guard canUseCalendar else {
            let error = FSError.noCalendarError
            err = error
            return
        }
        //判断日历是否存在，如果已经存在，那么不再创建
        let titles = self.getAllCalendarTitles()
        if titles.contains(name)
        {
            self.currentCalendar = self.getCalendar(with: name) //如果日历已经创建，那么获取当前日历
            return
        }
        
        //获取日历源
        let calendar = EKCalendar(for: .event, eventStore: store)
        var isSet: Bool = false   //是否设置了source
        var localSource: EKSource!
        for source in store.sources
        {
            if sourceType.isSource(source)
            {
                calendar.source = source
                isSet = true
                break
            }
            if source.sourceType == .local
            {
                localSource = source
            }
        }
        //如果没有匹配的，那么默认使用local
        if !isSet
        {
            calendar.source = localSource
        }
        
        calendar.title = name
        calendar.cgColor = color.cgColor
        do {
            try store.saveCalendar(calendar, commit: true)
            self.currentCalendar = calendar //设置为当前日历
        } catch {
            err = error
        }
    }
    
    ///删除日历，不管是否删除成功，完成后都无任何操作
    func deleteCalendar(name: String = String.appName)
    {
        //先获取对应name的日历
        if let calendar = self.getCalendar(with: name)
        {
            do {
                try store.removeCalendar(calendar, commit: true)
            } catch {
                FSLog("delete calendar error: \(error.localizedDescription)")
            }
        }
    }
    
    ///向日历中添加一个事件
    ///参数：
    ///title：标题
    ///startDate：单个事件开始日期
    ///endDate:单个事件结束日期，一般在一天以内
    ///isAllDay:是否全天有效
    ///location:不知道干吗用的
    ///url：可能是事件关联的url
    ///duration:整个事件持续时间，包含重复次数，单个事件开始和结束的间长不应该超过持续时间和重复规则
    ///alarms:一组闹钟
    ///repeats:重复规则，默认不重复
    func addEvent(title: String,
                  startDate: Date,
                  endDate: Date,
                  isAllDay: Bool = false,
                  location: String? = nil,
                  notes: String? = nil,
                  url: URL? = nil,
                  duration: CAEventDurationType = .day(),
                  alarms: [CAEventAlarmType] = [],
                  repeats: CAEventRepeatType = .none) throws -> EKEvent?
    {
        guard canUseCalendar else {
            throw FSError.noCalendarError   //如果不能使用日历，那么抛出一个错误
        }
        
        let event = EKEvent(eventStore: store)
        event.calendar = self.currentCalendar
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.isAllDay = isAllDay
        event.location = location
        event.notes = notes
        event.url = url
        //如果有重复规则，那么设置
        if let rep = repeats.getRepeatRule(endDate: duration.getEndDate())
        {
            event.addRecurrenceRule(rep)
        }
        //闹钟
        event.alarms = alarms.map({ (type) -> EKAlarm in
            return type.getAlarm()
        })
        do {
            try store.save(event, span: .thisEvent)
            try store.commit()
            return event
        } catch {
            FSLog("add event error: \(error.localizedDescription)")
            return nil
        }
    }
    
    ///搜索日历事件
    func queryEvent(startDate: Date, endDate: Date) -> [EKEvent]
    {
        var cals: [EKCalendar] = []
        if let cur = self.currentCalendar
        {
            cals.append(cur)
        }
        let predicate = store.predicateForEvents(withStart: startDate, end: endDate, calendars: cals.count > 0 ? cals : nil)
        let eventArr = store.events(matching: predicate)
        return eventArr
    }

    ///删除事件，会删除所有关联的未来事件
    ///参数：
    ///startDate：搜索开始时间，默认当前时间
    ///endDate:搜索结束时间，默认一年以后
    func deleteEvent(startDate: Date = Date(), endDate: Date = nowAfter(tSecondsInYear))
    {
        var cals: [EKCalendar] = []
        if let cur = self.currentCalendar
        {
            cals.append(cur)
        }
        let predicate = store.predicateForEvents(withStart: startDate, end: endDate, calendars: cals.count > 0 ? cals : nil)
        let eventArr = store.events(matching: predicate)
        for eve in eventArr
        {
            try? store.remove(eve, span: .futureEvents)
        }
    }
    
    /**************************************** 日历操作 Section End ****************************************/
    
    /**************************************** 提醒事项操作 Section Begin ****************************************/
    ///提醒事项授权状态
    var canUseReminder: Bool {
        return self.isReminderGranted
    }
    
    ///获取提醒事项权限
    func authorizeReminder(_ completion: @escaping (_ can: Bool) -> Void)
    {
        self.authorize(type: .reminder, completion: completion)
    }
    
    ///获取所有提醒事项列表
    func getAllReminders() -> Array<EKCalendar>?
    {
        guard canUseReminder else {
            return nil
        }
        
        return store.calendars(for: .reminder)
    }
    
    //获取所有提醒事项列表的标题
    func getAllReminderTitles() -> [String]
    {
        let reminders = self.getAllReminders()
        let titleArr = reminders?.map({ (reminder) -> String in
            return reminder.title
        })
        return titleArr ?? []
    }
    
    ///根据name获取reminder，如果有同名的，那么获取第一个;如果没有，返回nil
    func getReminder(with name: String) -> EKCalendar?
    {
        if let reminders = self.getAllReminders()
        {
            for rmd in reminders
            {
                if rmd.title == name
                {
                    return rmd
                }
            }
        }
        return nil
    }
    
    ///添加新提醒事项列表
    ///说明：一般大部分情况下建议一个app仅添加一个提醒事项列表，添加提醒事项列表是根据name判断重复，所以如果添加多个提醒事项列表，保证name唯一并能够区分
    ///参数：
    ///name:提醒事项列表名称，必须唯一，可以用作标志符，默认就是app名称
    ///sourceType:提醒事项列表来源，默认icloud提醒事项列表，如果没有icloud，那么使用local提醒事项列表
    ///color:日历颜色，默认使用默认主题色
    ///err:错误信息，如果有的话
    func createNewReminder(name: String,
                           sourceType: CACalendarSourceType = .icloud,
                           color: UIColor = UIColor.cAccent!,
                           err: inout Error?)
    {
        guard canUseReminder else {
            let error = FSError.noReminderError
            err = error
            return
        }
        //判断提醒事项列表是否存在，如果已经存在，那么不再创建
        let titles = self.getAllReminderTitles()
        if titles.contains(name)
        {
            self.currentReminder = self.getReminder(with: name) //如果提醒事项列表已经创建，那么获取当前提醒事项列表
            return
        }
        
        //获取提醒事项列表源
        let reminder = EKCalendar(for: .reminder, eventStore: store)
        var isSet: Bool = false   //是否设置了source
        var localSource: EKSource!
        for source in store.sources
        {
            if sourceType.isSource(source)
            {
                reminder.source = source
                isSet = true
                break
            }
            if source.sourceType == .local
            {
                localSource = source
            }
        }
        //如果没有匹配的，那么默认使用local
        if !isSet
        {
            reminder.source = localSource
        }
        
        reminder.title = name
        reminder.cgColor = color.cgColor
        do {
            try store.saveCalendar(reminder, commit: true)
            self.currentReminder = reminder //设置为当前提醒事项列表
        } catch {
            err = error
        }
    }
    
    ///删除提醒事项列表，不管是否删除成功，完成后都无任何操作
    func deleteReminder(name: String = String.appName)
    {
        //先获取对应name的提醒事项列表
        if let reminder = self.getReminder(with: name)
        {
            do {
                try store.removeCalendar(reminder, commit: true)
            } catch {
                FSLog("delete reminder error: \(error.localizedDescription)")
            }
        }
    }
    
    ///向提醒事项列表中添加一个事件
    ///参数：
    ///title：标题
    ///startDate：单个事件开始日期
    ///dueDate:单个事件发生时间，一般在一天以内
    ///location:不知道干吗用的
    ///url：可能是事件关联的url
    ///duration:整个事件持续时间，包含重复次数，单个事件开始和结束的间长不应该超过持续时间和重复规则
    ///alarms:一组闹钟
    ///repeats:重复规则，默认不重复
    func addRemind(title: String,
                  startDate: Date,
                  dueDate: Date,
                  location: String? = nil,
                  notes: String? = nil,
                  url: URL? = nil,
                  duration: CAEventDurationType = .day(),
                  alarms: [CAEventAlarmType] = [],
                  repeats: CAEventRepeatType = .none) throws -> EKReminder?
    {
        guard canUseReminder else {
            throw FSError.noReminderError   //如果不能使用提醒事项列表，那么抛出一个错误
        }
        
        let remind = EKReminder(eventStore: store)
        var sysCalendar = Calendar.current
        sysCalendar.timeZone = TimeZone.current
        let flags: Set<Calendar.Component> = [.era, .year, .month, .day, .hour, .minute, .second, .weekday]
        let start = sysCalendar.dateComponents(flags, from: startDate)
        let due = sysCalendar.dateComponents(flags, from: dueDate)
        remind.calendar = self.currentReminder
        remind.title = title
        remind.startDateComponents = start
        remind.dueDateComponents = due
        remind.location = location
        remind.notes = notes
        remind.url = url
        //如果有重复规则，那么设置
        if let rep = repeats.getRepeatRule(endDate: duration.getEndDate())
        {
            remind.addRecurrenceRule(rep)
        }
        //闹钟
        remind.alarms = alarms.map({ (type) -> EKAlarm in
            return type.getAlarm()
        })
        do {
            try store.save(remind, commit: true)
            return remind
        } catch {
            FSLog("add remind error: \(error.localizedDescription)")
            return nil
        }
    }
    
    ///查询提醒事项
    ///startDate:开始时间
    ///endDate:搜索结束时间，默认一年以后
    ///searchType:搜索类型：未完成/已完成/所有
    ///completion：完成回调，返回提醒列表
    func queryRemind(startDate: Date?,
                     endDate: Date?,
                     searchType: CAReminderSearchType,
                     completion: @escaping OpGnClo<[EKReminder]>)
    {
        var cals: [EKCalendar] = []
        if let cur = self.currentReminder
        {
            cals.append(cur)
        }
        var predicate: NSPredicate
        switch searchType {
        case .all:
            predicate = store.predicateForReminders(in: cals)
        case .inComplete:
            predicate = store.predicateForIncompleteReminders(withDueDateStarting: startDate, ending: endDate, calendars: cals)
        case .completed:
            predicate = store.predicateForCompletedReminders(withCompletionDateStarting: startDate, ending: endDate, calendars: cals)
        }
        store.fetchReminders(matching: predicate) {(reminds) in
            completion(reminds)
        }
    }

    ///删除提醒事项
    ///参数：
    ///startDate：搜索开始时间，默认当前时间
    ///endDate:搜索结束时间，默认一年以后
    ///searchType:搜索类型：未完成/已完成/所有
    func deleteRemind(startDate: Date = Date(),
                      endDate: Date = nowAfter(tSecondsInYear),
                      searchType: CAReminderSearchType = .all)
    {
        self.queryRemind(startDate: startDate, endDate: endDate, searchType: searchType) {[self] (reminds) in
            if let arr = reminds
            {
                for remind in arr
                {
                    try? store.remove(remind, commit: false)
                }
                try? store.commit()
            }
        }
    }
    
    /**************************************** 提醒事项操作 Section End ****************************************/
    
}
