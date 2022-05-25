//
//  TimerManager.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/2/7.
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
    
    //倒计时定时器容器，key是随机字符串，value是定时器
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
    fileprivate func getInfoKey(host: AnyObject) -> String
    {
        let key = EncryptManager.shared.uuidString().subStringTo(index: 8) + " - " + currentTimeString() + ": " + g_objClassName(host)
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
    ///参数：interval：延时时间；onMain：是否在主线程；action：要执行的回调；
    func after(interval: TimeInterval, onMain: Bool = true, action: @escaping VoidClosure)
    {
        if onMain
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + interval, execute: action)
        }
        else
        {
            DispatchQueue.global().asyncAfter(deadline: .now() + interval, execute: action)
        }
    }
    
    ///NSTimer定时器
    ///参数：
    ///interval：时间间隔；
    ///repeats：是否重复，如果为false相当于延时操作；
    ///mode：定时器添加的模式；
    ///action：执行的动作；
    ///host：使用定时器的宿主，一般传self,建议使用类和对象
    func timer(interval: TimeInterval,
               repeats: Bool = true,
               mode: RunLoop.Mode = .default,
               host: AnyObject,
               action: @escaping ((Timer) -> Void)) -> Timer
    {
        let timer = Timer.init(timeInterval: interval, repeats: repeats, block: action)
        RunLoop.current.add(timer, forMode: mode)
        self.timerDict.setObject(timer, forKey: self.getInfoKey(host: host))
        return timer
    }
    
    ///GCD定时器
    ///参数：
    ///interval：秒数(内部转换成纳秒)；
    ///host：使用定时器的宿主，一般传self；
    ///onMain：是否在主线程，如果传了false，那么宿主需要在action中在主线程执行UI操作
    ///exact:是否精确计时，默认当系统休眠时定时器也停止，如果设置为true，系统休眠时定时器也在走
    func dispatchTimer(interval: TimeInterval,
                       onMain: Bool = true,
                       exact: Bool = false,
                       host: AnyObject,
                       action: @escaping VoidClosure) -> DispatchSourceTimer
    {
        let timer = DispatchSource.makeTimerSource(flags: [], queue: onMain ? DispatchQueue.main : DispatchQueue.global())
        if exact
        {
            timer.schedule(wallDeadline: .now(), repeating: .nanoseconds(Int(interval * 1000 * 1000 * 1000)))
        }
        else
        {
            timer.schedule(deadline: .now(), repeating: .nanoseconds(Int(interval * 1000 * 1000 * 1000)))
        }
        timer.setEventHandler(handler: action)
        timer.resume()
        self.timerDict.setObject(timer, forKey: self.getInfoKey(host: host))
        return timer
    }
    
    ///倒计时方法
    ///参数：
    ///interval：时间间隔，默认1s
    ///startTime:起始时间
    ///through:表示倒计时是否可以穿透0，就是变为负数，默认到0就停止，如果设为true，倒计时不会停止，除非设置action的canFinish为true
    ///exact:是否精确计时，默认当系统休眠时定时器也停止，如果设置为true，系统休眠时定时器也在走
    ///host:使用倒计时的宿主
    ///action：每次倒计时执行的动作，参数：restTime：剩余时间；canFinish：是否可以结束倒计时，输入输出参数
    ///completion:倒计时结束后执行的动作
    func countDown(interval: TimeInterval = 1.0,
                   startTime: TimeInterval,
                   through: Bool = false,
                   onMain: Bool = true,
                   exact: Bool = false,
                   host: AnyObject,
                   action: @escaping ((_ restTime: TimeInterval, _ canFinish: inout Bool) -> Void),
                   completion: ((_ endTime: TimeInterval) -> Void)? = nil)
    {
        //如果起始时间为负数，并且没有设置穿透，那么直接结束
        if startTime <= 0 && through == false
        {
            if let co = completion
            {
                co(startTime)
            }
            return
        }
        
        //准备数据
        var restTime = startTime    //剩余时间
        var canFinish = false   //是否可以结束
        let timerId = g_uuid()    //创建的定时器id
        
        let timer = self.dispatchTimer(interval: interval, onMain: onMain, exact: exact, host: host) {
            action(restTime, &canFinish)    //执行动作
            //判断是否结束倒计时
            if canFinish    //优先判断外部状态
            {
                let timer = self.countDownTimerDict[timerId]
                timer?.cancel()
                self.countDownTimerDict[timerId] = nil
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
                    let timer = self.countDownTimerDict[timerId]
                    timer?.cancel()
                    self.countDownTimerDict[timerId] = nil
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
    }
    
    ///秒表，时间不断累加，秒表停止条件必须外部提供
    ///参数：
    ///interval：时间间隔，默认1s
    ///exact:是否精确计时，默认当系统休眠时定时器也停止，如果设置为true，系统休眠时定时器也在走
    ///host:使用秒表的宿主
    ///action：每次累加时间后执行的动作，参数：totalTime：剩余时间；canFinish：是否可以结束倒计时，输入输出参数
    ///completion:秒表结束后执行的动作
    func stopWatch(interval: TimeInterval = 1.0,
                   onMain: Bool = true,
                   exact: Bool = false,
                   host: AnyObject,
                   action: @escaping ((_ totalTime: TimeInterval, _ canFinish: inout Bool) -> Void),
                   completion: ((_ endTime: TimeInterval) -> Void)? = nil)
    {
        //准备数据
        var totalTime = 0.0    //累计时间
        var canFinish = false   //是否可以结束
        let timerId = g_uuid()    //创建的定时器id
        
        let timer = self.dispatchTimer(interval: interval, onMain: onMain, exact: exact, host: host) {
            action(totalTime, &canFinish)    //执行动作
            //判断是否结束秒表
            if canFinish    //优先判断外部状态
            {
                let timer = self.countDownTimerDict[timerId]
                timer?.cancel()
                self.countDownTimerDict[timerId] = nil
                //执行完成动作
                if let co = completion
                {
                    co(totalTime)
                }
            }
            totalTime += interval    //剩余时间减少
        }
        self.countDownTimerDict[timerId] = timer
    }
    
}
