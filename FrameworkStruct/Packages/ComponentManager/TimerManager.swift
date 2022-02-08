//
//  TimerManager.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/2/7.
//

/**
 定时器管理
 */
import UIKit

class TimerManager: OriginManager
{
    //MARK: 属性
    //单例
    static let shared = TimerManager()
    
    ///每创建一个定时器都加入到字典中，随时可以查看活跃的定时器信息
    var timerDict: WeakDictionary = WeakDictionary()
    
    
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
        let key = EncryptManager.shared.uuidString().subStringTo(index: 7) + " - " + getCurrentTimeString() + ": " + getObjClassName(host)
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
    ///host：使用定时器的宿主，一般传self
    func timer(interval: TimeInterval, repeats: Bool = true, mode: RunLoop.Mode = .default, host: AnyObject, action: @escaping ((Timer) -> Void)) -> Timer
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
    func dispatchTimer(interval: TimeInterval, onMain: Bool = true, host: AnyObject, action: @escaping VoidClosure) -> DispatchSourceTimer
    {
        let timer = DispatchSource.makeTimerSource(flags: [], queue: onMain ? DispatchQueue.main : DispatchQueue.global())
        timer.schedule(deadline: .now(), repeating: .nanoseconds(Int(interval * 1000 * 1000 * 1000)))
        timer.setEventHandler(handler: action)
        timer.resume()
        self.timerDict.setObject(timer, forKey: self.getInfoKey(host: host))
        return timer
    }
    
    ///固定倒计时方法
    func countDown()
    {
        
    }
    
}
