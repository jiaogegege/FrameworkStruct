//
//  ScrollAnimationView.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/10/29.
//

/**
 让传入其中的子视图上下或者左右来回滚动，比如长文本在固定区域内左右来回滚动
 */
import UIKit

class ScrollAnimationView: UIView
{
    //MARK: 属性
    //外部传入的view，根据view的frame做动画
    var slotView: UIView?
    
    //滚动方向
    var scrollDirection: ScrollDirection = .auto
    //根据计算当前实际的滚动方向
    fileprivate(set) var realScrollDirection: ScrollDirection = .auto
    //滚动距离，为0则不滚动
    fileprivate(set) var scrollDistance: CGFloat = 0.0
    
    fileprivate var animationTime: TimeInterval = 0.0   //动画时长
    fileprivate var animationId: String?       //动画id
    fileprivate var animationTimer: DispatchSourceTimer?     //动画定时器
    
    fileprivate var containerView: UIView!      //容器
    fileprivate var scrollView: UIView!         //要做滚动动画的view
    
    //MARK: 方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        createView()
        configView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createView() {
        containerView = UIView(frame: self.bounds)
        addSubview(containerView)
        
        scrollView = UIView(frame: containerView.bounds)
        containerView.addSubview(scrollView)
    }
    
    override func configView() {
        containerView.clipsToBounds = true
    }
    
    //计算实际的滚动方向和滚动距离
    fileprivate func calc()
    {
        if let _ = slotView {
            //计算差值
            let swidth = scrollView.width - self.width
            let sheight = scrollView.height - self.height
            switch scrollDirection {
            case .auto:
                //取最大值
                if swidth > 0 || sheight > 0
                {
                    realScrollDirection = swidth >= sheight ? .horizontal : .vertical
                    scrollDistance = swidth >= sheight ? swidth : sheight
                }
                else    //如果没有大于0的，那么设置为0，即不滚动
                {
                    realScrollDirection = .auto
                    scrollDistance = 0.0
                }
            case .horizontal:
                realScrollDirection = .horizontal
                scrollDistance = swidth
            case .vertical:
                realScrollDirection = .vertical
                scrollDistance = sheight
            }
        }
    }
    
    //做动画
    fileprivate func startAnimation()
    {
        stopAnimation()
        if scrollDistance > 0
        {
            //计算动画时长，10px 1s
            animationTime = TimeInterval((scrollDistance + 5.0) / 10.0 * 1)
            let fromValue = CGRect(x: realScrollDirection == .horizontal ? 5 : 0, y: realScrollDirection == .vertical ? 5 : 0, width: scrollView.width, height: scrollView.height)
            let toValue = CGRect(x: realScrollDirection == .horizontal ? -scrollDistance - 5 : 0, y: realScrollDirection == .vertical ? -scrollDistance - 5 : 0, width: scrollView.width, height: scrollView.height)
            animationId = AnimationManager.shared.popBasic(propertyName: kPOPViewFrame, fromValue: fromValue, toValue: toValue, timingFuncName: .linear, duration: animationTime, isLoop: true, repeatCount: 1, autoReverse: true, host: scrollView, startBlock: {
                
            }, reachToBlock: {
                
            }, completion: { (finished) in
                
            })
        }
    }
    
    //停止动画
    fileprivate func stopAnimation()
    {
        if let id = animationId
        {
            scrollView.pop_removeAnimation(forKey: id)
        }
        scrollView.x = 0
        scrollView.y = 0
    }
    
}


extension ScrollAnimationView: InternalType
{
    //滚动方向
    enum ScrollDirection {
        case auto               //根据slotView的尺寸自动计算，按照超出的长边滚动
        case horizontal         //水平滚动，不管竖直方向
        case vertical           //竖直滚动，不管水平方向
    }
}


extension ScrollAnimationView: ExternalInterface
{
    override func updateView() {
        if let slotView = slotView
        {
            //先删除之前的子view
            scrollView.removeAllSubviews()
            slotView.x = 0  //position重置到原点
            slotView.y = 0
            scrollView.width = slotView.width
            scrollView.height = slotView.height
            scrollView.addSubview(slotView)
            //计算滚动方向和距离
            calc()
            //尝试做动画
            startAnimation()
        }
    }
    
}
