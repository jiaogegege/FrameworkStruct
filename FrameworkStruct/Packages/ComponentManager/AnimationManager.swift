//
//  AnimationManager.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/2/12.
//

/**
 动画管理器
 管理各种动画效果
 */
import UIKit

class AnimationManager: OriginManager
{
    //MARK: 属性
    //单例
    static let shared = AnimationManager()

    
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

//接口方法
extension AnimationManager: ExternalInterface
{
    /**************************************** 通用动画方法 Section Begin ***************************************/
    /**
     lottie动画
     返回动画的view，view的frame或者约束由调用者设置
     参数：
     name：json动画文件名
     loopMode:默认只播放一次，如果设置了loop，只有deinit的时候才会执行完成动作
     playSpeed:动画播放速度，默认1正常速度
     autoPlay：创建完成后是否自动播放动画，默认true，如果为false，需手动播放
     completion:动画播放完成后执行的动作
     */
    func lottie(name: String,
                loopMode: LottieLoopMode = .playOnce,
                playSpeed: CGFloat = 1.0,
                autoPlay: Bool = true,
                completion: (VoidClosure)? = nil) -> AnimationView
    {
        let ani = Animation.named(name)
        let v = AnimationView()
        v.contentMode = .scaleAspectFit    //等比例缩放，填满view
        v.animation = ani
        v.loopMode = loopMode
        v.animationSpeed = playSpeed
        if autoPlay
        {
            v.play { completed in
                if let comp = completion
                {
                    comp()
                }
            }
        }
        return v
    }
    
    ///pop基础属性动画
    ///参数：
    ///propertyName：需要做动画的属性，具体可用的值参考`POPAnimatableProperty.h`
    ///timingFuncName：动画变化速率，目前只支持系统的5种
    ///duration:动画持续时间
    ///fromeValue:属性动画开始的值，如果不设置则从当前值开始
    ///toValue:属性动画结束值
    ///isLoop是否无限循环动画
    ///repeatCount:动画重复次数
    ///autoReverse:是否反转动画，如果为true，动画执行到toValue后再回到fromValue，和repeatCount/isLoop配合使用
    ///host:需要做动画的view或者layer
    ///completion:动画完成后执行的动作
    func popBasic(propertyName: String,
                  fromValue: Any? = nil,
                  toValue: Any,
                  timingFuncName: CAMediaTimingFunctionName = .default,
                  duration: TimeInterval = 0.5,
                  isLoop: Bool = false,
                  repeatCount: Int = 1,
                  autoReverse: Bool = false,
                  host: AnyObject,
                  completion: VoidClosure? = nil)
    {
        let ani = POPBasicAnimation(propertyNamed: propertyName)
        ani?.timingFunction = CAMediaTimingFunction(name: timingFuncName)
        ani?.duration = duration
        if let from = fromValue
        {
            ani?.fromValue = from
        }
        ani?.toValue = toValue
        ani?.repeatCount = repeatCount
        ani?.repeatForever = isLoop
        ani?.autoreverses = autoReverse
        ani?.delegate = self
        let key = "POPBasicAnimation" + propertyName + g_uuidString()
        ani?.name = key
        host.pop_add(ani, forKey: key)
        //保存完成的回调
        if let comp = completion
        {
            ani?.completionBlock = {(anim: POPAnimation!, finished: Bool) in
                if finished
                {
                    comp()
                }
            }
        }
    }
    
    ///pop弹性动画
    ///bounciness:有效弹性，值会被转换为相应的动力学常数。较高的值会增加弹簧移动范围，从而产生更多的振荡和弹性。定义为[0,20]范围内的值。 默认为4
    ///speed：有效速度，较高的值会增加弹簧的阻尼能力，从而导致更快的初始速度和更快的弹跳速度。定义为[0,20]范围内的值。默认为12
    ///dynamicsTension：动力学中使用的张力。可以在弹跳和速度上使用，以便更精细地调整动画效果。相当于拉力，越大弹动的频率越高，大于0
    ///dynamicsFriction：动力学中使用的摩擦力。可以在弹跳和速度上使用，以便更精细地调整动画效果。大于0
    ///dynamicsMass：动力学中使用的质量。可以在弹跳和速度上使用，以便更精细地调整动画效果。越大弹动越迟缓，大于0
    func popSpring(propertyName: String,
                   fromValue: Any? = nil,
                   toValue: Any,
                   bounciness: CGFloat = 4.0,
                   speed: CGFloat = 12.0,
                   dynamicsTension: CGFloat = 100.0,
                   dynamicsMass: CGFloat = 0.5,
                   dynamicsFriction: CGFloat = 3.0,
                   isLoop: Bool = false,
                   repeatCount: Int = 1,
                   autoReverse: Bool = false,
                   host: AnyObject,
                   completion: VoidClosure? = nil)
    {
        let ani = POPSpringAnimation(propertyNamed: propertyName)
        if let from = fromValue
        {
            ani?.fromValue = from
        }
        ani?.toValue = toValue
        ani?.springBounciness = bounciness
        ani?.springSpeed = speed
        ani?.dynamicsTension = dynamicsTension
        ani?.dynamicsMass = dynamicsMass
        ani?.dynamicsFriction = dynamicsFriction
        ani?.repeatCount = repeatCount
        ani?.repeatForever = isLoop
        ani?.autoreverses = autoReverse
        ani?.delegate = self
        let key = "POPSpringAnimation" + propertyName + g_uuidString()
        ani?.name = key
        host.pop_add(ani, forKey: key)
        //保存完成的回调
        if let comp = completion
        {
            ani?.completionBlock = {(anim: POPAnimation!, finished: Bool) in
                if finished
                {
                    comp()
                }
            }
        }
    }
    
    ///pop衰减动画
    ///velocity：动画的初始速度，也就是变化速率
    ///deceleration：衰减因子，范围[0,1]，默认值为0.998（G重力加速度）
    func popDecay(propertyName: String,
                  fromValue: Any? = nil,
                  velocity: Any,
                  deceleration: CGFloat = 0.998,
                  isLoop: Bool = false,
                  repeatCount: Int = 1,
                  autoReverse: Bool = false,
                  host: AnyObject,
                  completion: VoidClosure? = nil)
    {
        let ani = POPDecayAnimation(propertyNamed: propertyName)
        if let from = fromValue
        {
            ani?.fromValue = from
        }
        ani?.velocity = velocity
        ani?.deceleration = deceleration
        ani?.repeatCount = repeatCount
        ani?.repeatForever = isLoop
        ani?.autoreverses = autoReverse
        ani?.delegate = self
        let key = "POPSpringAnimation" + propertyName + g_uuidString()
        ani?.name = key
        host.pop_add(ani, forKey: key)
        //保存完成的回调
        if let comp = completion
        {
            ani?.completionBlock = {(anim: POPAnimation!, finished: Bool) in
                if finished
                {
                    comp()
                }
            }
        }
    }
    /**************************************** 通用动画方法 Section End ***************************************/
    
    /**************************************** 特定动画方法 Section Begin ***************************************/
    
    
    /**************************************** 特定动画方法 Section End ***************************************/
    
}

//代理方法
extension AnimationManager: DelegateProtocol, POPAnimationDelegate
{
    /**************************************** pop动画代理 Section Begin ***************************************/
    func pop_animationDidStart(_ anim: POPAnimation!) {
        
    }
    
    func pop_animationDidReach(toValue anim: POPAnimation!) {
        
    }
    
    func pop_animationDidStop(_ anim: POPAnimation!, finished: Bool) {
        
    }
    
    func pop_animationDidApply(_ anim: POPAnimation!) {
        
    }
    /**************************************** pop动画代理 Section End ***************************************/
    
}
