//
//  HigherTool.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/10/26.
//


/**
 高阶函数工具
 该文件中的所有方法和变量都以`_`开头
 */
import Foundation

///防抖动，返回一个闭包，在指定的时间内调用该闭包则不会执行fn，在超过指定的时间后则会执行一次fn
///主要用于防止多次频繁调用计算开销大的函数，比如输入文本时实时搜索，改变UI时重新布局
///参数：
///wait：等待多少时间后可以再次执行fn
///before：在等待时间之前还是之后执行fn，如果为true，那么第一次调用闭包会立即执行一次fn，之后，都要等待上一次执行fn完毕之后的wait时间之后才能再次执行fn；如果为false，那么在调用闭包之后的wait时间之后会执行一次fn，如果在wait时间之内调用闭包，则刷新等待时间
var _debounceTimer: DispatchSourceTimer?
func _debounce(wait interval: TimeInterval, before: Bool = true, fn: @escaping VoidClosure) -> VoidClosure
{
    var canPerform: Bool = before    //是否可以执行fn
    func closure() {
        //如果之前有定时器，那么取消掉
        if let ti = _debounceTimer {
            ti.cancel()
        }
        if canPerform && before
        {
            fn()
            canPerform = false
        }
        //创建定时器，重新开始计时
        _debounceTimer = TimerManager.shared.dispatchTimer(interval: interval, repeats: false, preExec: false, onMain: nil, exact: true) {[weak _debounceTimer] in
            if before == false
            {
                fn()
                canPerform = false
            }
            else
            {
                canPerform = true
            }
            _debounceTimer?.cancel()
            _debounceTimer = nil
        }
    }
    return closure
}

///返回一个闭包，当他被调用n次后将马上触发func，之后调用都会触发fn
func _after(_ n: UInt, fn: @escaping OptionalAnyReturnClosure) -> OptionalAnyReturnClosure
{
    var count: UInt = 0
    func closure() -> Any? {
        count += 1
        if count >= n
        {
            return fn()
        }
        return nil
    }
    return closure
}

///返回一个闭包，调用这个闭包的前n次都会触发fn，n次之后再也不会触发fn，每次触发都返回fn的返回值
func _before(_ n: UInt, fn: @escaping OptionalAnyReturnClosure) -> OptionalAnyReturnClosure
{
    var count: UInt = 0
    func closure() -> Any? {
        count += 1
        if count <= n
        {
            return fn()
        }
        return nil
    }
    return closure
}
