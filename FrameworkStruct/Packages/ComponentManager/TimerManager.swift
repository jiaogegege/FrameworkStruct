//
//  TimerManager.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/2/7.
//

/**
 定时器管理
 包括NSTimer，GCD定时器，延时操作，秒表，倒计时等功能
 */
import UIKit

class TimerManager: OriginManager
{
    //MARK: 属性
    //单例
    static let shared = TimerManager()
    
    ///每创建一个定时器都加入到字典中，随时可以查看活跃的定时器信息
    fileprivate var timerDict: WeakDictionary = WeakDictionary()
    
    //倒计时和秒表定时器容器，key是随机字符串，value是定时器
    fileprivate var countDownTimerDict: Dictionary<String, DispatchSourceTimer> = [:]
    
    
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

    //获取key
    //key由3部分组成：8位随机字符串，创建定时器的时刻，host名
    fileprivate func getInfoKey(hostId: String) -> String
    {
        let key = EncryptManager.shared.uuidString().subStringTo(index: 8) + " - " + currentTimeString() + ": " + hostId
        return key
    }
    
}


//接口方法
extension TimerManager: ExternalInterface
{
    ///获取当前所有定时器和宿主信息
    var allTimerInfo: String {
        return self.timerDict.description
    }
    
    ///延时操作
    ///参数：interval：延时时间；onMain：true在主线程，false在后台线程，为nil则为当前线程；action：要执行的回调；
    func after(interval: TimeInterval, onMain: Bool? = nil, action: @escaping VoClo)
    {
        var queue = ThreadManager.shared.currentQueue()
        if let onMain = onMain
        {
            queue = onMain ? DispatchQueue.main : DispatchQueue.global()
        }
        queue.asyncAfter(deadline: .now() + interval, execute: action)
    }
    
    ///NSTimer定时器
    ///参数：
    ///interval：时间间隔；
    ///repeats：是否重复，如果为false相当于延时操作；
    ///mode：定时器添加的模式；
    ///action：执行的动作；
    ///hostId：使用定时器的宿主标志符，传一个唯一id即可，默认随机生成一个
    func timer(interval: TimeInterval,
               repeats: Bool = true,
               mode: RunLoop.Mode = .default,
               hostId: String = g_uuid(),
               action: @escaping ((Timer) -> Void)) -> Timer
    {
        let timer = Timer.init(timeInterval: interval, repeats: repeats, block: action)
        RunLoop.current.add(timer, forMode: mode)
        self.timerDict.setObject(timer, forKey: self.getInfoKey(hostId: hostId))
        return timer
    }
    
    ///GCD定时器
    ///参数：
    ///interval：秒数(内部转换成纳秒)；
    ///repeats：是否重复，如果为false相当于延时操作，只执行一次
    ///preExec: 是否预先执行一次，如果为true，那么会立即执行一次，之后每隔interval时间执行一次
    ///hostId：使用定时器的宿主标志符，传一个唯一id即可，默认随机生成一个
    ///onMain：所在线程，nil：当前线程；true：主线程；false：后台线程
    ///exact:是否精确计时，默认当系统休眠时定时器也停止，如果设置为true，系统休眠时定时器也在走
    func dispatchTimer(interval: TimeInterval,
                       repeats: Bool = true,
                       preExec: Bool = false,
                       onMain: Bool?,
                       exact: Bool = false,
                       hostId: String = g_uuid(),
                       action: @escaping ((DispatchSourceTimer?) -> Void)) -> DispatchSourceTimer
    {
        //计算所在队列
        var queue = ThreadManager.shared.currentQueue()
        if let onMain = onMain {
            queue = onMain ? DispatchQueue.main : DispatchQueue.global()
        }
        let timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
        if exact
        {
            timer.schedule(wallDeadline: .now(), repeating: .nanoseconds(Int(interval * 1000 * 1000 * 1000)))
        }
        else
        {
            timer.schedule(deadline: .now(), repeating: .nanoseconds(Int(interval * 1000 * 1000 * 1000)))
        }
        var canPerform = preExec   //是否可以执行action
        timer.setEventHandler {[weak timer] in
            if canPerform
            {
                action(timer)
                //只执行一次
                if !repeats
                {
                    timer?.cancel()
                }
            }
            else
            {
                canPerform = true
            }
        }
        timer.resume()
        self.timerDict.setObject(timer, forKey: self.getInfoKey(hostId: hostId))
        return timer
    }
    
    ///倒计时方法
    ///参数：
    ///interval：时间间隔，默认1s
    ///startTime:起始时间
    ///through:表示倒计时是否可以穿透0，就是变为负数，默认到0就停止，如果设为true，倒计时不会停止，除非设置action的canFinish为true
    ///onMain：所在线程，nil：当前线程；true：主线程；false：后台线程
    ///exact:是否精确计时，默认当系统休眠时定时器也停止，如果设置为true，系统休眠时定时器也在走
    ///hostId：使用定时器的宿主标志符，传一个唯一id即可，默认随机生成一个
    ///action：每次倒计时执行的动作，参数：restTime：剩余时间；canFinish：是否可以结束倒计时，输入输出参数
    ///completion:倒计时结束后执行的动作
    ///返回值：
    ///如果倒计时创建成功，那么返回标记该倒计时的唯一标识符，如果没有创建成功返回nil
    func countDown(interval: TimeInterval = 1.0,
                   startTime: TimeInterval,
                   through: Bool = false,
                   onMain: Bool?,
                   exact: Bool = false,
                   hostId: String = g_uuid(),
                   action: @escaping ((_ restTime: TimeInterval, _ canFinish: inout Bool) -> Void),
                   completion: ((_ endTime: TimeInterval) -> Void)? = nil) -> String?
    {
        //如果起始时间为负数，并且没有设置穿透，那么直接结束
        if startTime <= 0 && through == false
        {
            if let co = completion
            {
                co(startTime)
            }
            return nil
        }
        
        //准备数据
        var restTime = startTime    //剩余时间
        var canFinish = false   //是否可以结束
        let timerId = g_uuid()    //创建的定时器id
        
        let timer = self.dispatchTimer(interval: interval, onMain: onMain, exact: exact, hostId: hostId) { [unowned self] timer in
            action(restTime, &canFinish)    //执行动作
            //判断是否结束倒计时
            if canFinish    //优先判断外部状态
            {
                self.cancel(timerId)
                //执行完成动作
                if let co = completion
                {
                    co(restTime)
                }
            }
            else    //如果外部没有设置结束，那么判断内部状态
            {
                if through == false && restTime <= 0.0
                {
                    self.cancel(timerId)
                    //执行完成动作
                    if let co = completion
                    {
                        co(restTime)
                    }
                }
            }
            restTime -= interval    //剩余时间减少
        }
        self.countDownTimerDict[timerId] = timer
        
        return timerId
    }
    
    ///秒表，时间不断累加，秒表停止条件必须外部提供
    ///参数：
    ///interval：时间间隔，默认1s
    ///onMain：所在线程，nil：当前线程；true：主线程；false：后台线程
    ///exact:是否精确计时，默认当系统休眠时定时器也停止，如果设置为true，系统休眠时定时器也在走
    ///hostId:使用秒表的宿主
    ///action：每次累加时间后执行的动作，参数：totalTime：剩余时间；canFinish：是否可以结束倒计时，输入输出参数
    ///completion:秒表结束后执行的动作
    ///返回值：
    ///如果倒计时创建成功，那么返回标记该倒计时的唯一标识符
    func stopWatch(interval: TimeInterval = 1.0,
                   onMain: Bool?,
                   exact: Bool = false,
                   hostId: String = g_uuid(),
                   action: @escaping ((_ totalTime: TimeInterval, _ canFinish: inout Bool) -> Void),
                   completion: ((_ endTime: TimeInterval) -> Void)? = nil) -> String
    {
        //准备数据
        var totalTime = 0.0    //累计时间
        var canFinish = false   //是否可以结束
        let timerId = g_uuid()    //创建的定时器id
        
        let timer = self.dispatchTimer(interval: interval, onMain: onMain, exact: exact, hostId: hostId) { [unowned self] timer in
            action(totalTime, &canFinish)    //执行动作
            //判断是否结束秒表
            if canFinish    //优先判断外部状态
            {
                self.cancel(timerId)
                //执行完成动作
                if let co = completion
                {
                    co(totalTime)
                }
            }
            totalTime += interval    //剩余时间减少
        }
        self.countDownTimerDict[timerId] = timer
        
        return timerId
    }
    
    ///提前停止某个倒计时或秒表
    ///参数：id：定时器id
    func cancel(_ id: String)
    {
        let timer = self.countDownTimerDict[id]
        timer?.cancel()
        self.countDownTimerDict[id] = nil
    }
    
}
