//
//  FSGuideView.swift
//  FrameworkStruct
//
//  Created by jggg on 2022/3/24.
//

/**
 * 显示各种新手引导页，主要通过`GuideManager`使用，也可独立使用，主要包括以下功能：
 * - 1. 全屏半透明背景；2. 镂空显示UI上的某些组件；3.在镂空组件周围布局其他说明组件或图片；4.有多步引导，可以翻页或跳过；5.全屏可点击进入下一步，如果是最后一个则结束新手引导
 *
 */
import UIKit

class FSGuideView: UIView
{
    //MARK: 属性
    /**************************************** 接口属性 Section Begin ****************************************/
    
    ///需要镂空的组件列表，可以指定多个引导页,每一个引导页可以指定多个镂空组件
    var hollowViewArray: Array<Array<HollowViewType>>?
    ///对需要镂空的组件的描述组件，也就是在镂空组件周围添加一些帮助图片和信息，和`hollowViewArray`一一对应，并且对于一个镂空组件，可以有多个描述组件
    var describeInfoArray: Array<Array<Array<HollowDescribeInfo>>>?
    
    ///新手引导view开始显示回调
    var willShowCallback: VoClo?
    ///点击下一步回调，如果有多个引导页，那么每次点击后显示下一个引导页时会调用，显示第一个时也会调用
    ///参数:当前显示的引导页的index,从0开始
    var nextCallback: ((Int) -> Void)?
    ///点击跳过的回调
    var skipCallback: VoClo?
    ///新手引导结束，引导界面消失
    var finishCallback: VoClo?

    ///是否显示跳过按钮，多于一个引导页的时候才显示，也可随时设置显示隐藏
    var showSkip: Bool = true {
        didSet {
            skipBtn.isHidden = !showSkip
        }
    }
    
    //半透明蒙层背景色，默认黑色50%透明度
    var maskColor: UIColor = .cBlack_50Alpha
    
    /**************************************** 接口属性 Section End ****************************************/
    
    ///当前正在显示的引导页的index,未开始显示的时候是-1
    fileprivate(set) var currentIndex: Int = -1
    
    //引导页列表
    fileprivate let guideViewQueue: FSQueue<UIView> = FSQueue()
    
    ///UI组件
    fileprivate var staticView: UIView!     //固定显示的内容，比如跳过按钮等
    fileprivate var containerView: UIView!  //显示引导页内容的view
    fileprivate var skipBtn: UIButton = UIButton(type: .custom)  //跳过按钮
    
    
    //MARK: 方法
    //初始化方法，参数随便传，大小永远是整个屏幕大
    override init(frame: CGRect = .zero) {
        super.init(frame: .fullScreen)
        self.createView()
        self.configView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //这里会创建bgView和containerView
    //子类可以覆写这个方法，并且要调用父类方法
    override func createView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:)))
        self.addGestureRecognizer(tap)
        
        containerView = UIView(frame: self.bounds)
        self.addSubview(containerView)
        staticView = UIView(frame: self.bounds)
        self.addSubview(staticView)
        //跳过按钮
        staticView.addSubview(skipBtn)
    }
    
    //配置view
    //子类可以覆写该方法，并且要调用父类方法
    override func configView() {
        skipBtn.frame = CGRect(x: self.width - fitX(24) - fitX(60), y: kStatusHeight + fitX(6), width: fitX(60), height: fitX(30))
        skipBtn.setTitle(.skip, for: .normal)
        skipBtn.titleLabel?.font = UIFont.systemFont(ofSize: fitX(16))
        skipBtn.addTarget(self, action: #selector(skipAction(sender:)), for: .touchUpInside)
        skipBtn.setTitleColor(.white, for: .normal)
        skipBtn.layer.borderWidth = 1.0
        skipBtn.layer.borderColor = UIColor.white.cgColor
        skipBtn.layer.cornerRadius = skipBtn.height / 2.0
    }
    
    //点击任意位置显示下一个蒙层或者退出新手引导
    @objc func tapAction(sender: UITapGestureRecognizer)
    {
        self.showGuideView()
    }
    
    //跳过按钮
    @objc func skipAction(sender: UIButton)
    {
        if let cb = skipCallback
        {
            cb()
        }
        finishGuide()
    }
    
    //创建引导页列表，返回创建是否成功，如果创建成功，那么开始显示，否则直接结束
    fileprivate func createGuideViews() -> Bool
    {
        var ret: Bool = false
        if let hollowArray = hollowViewArray
        {
            //创建每一个引导页
            for (index, hollows) in hollowArray.enumerated()
            {
                if let describeArray = describeInfoArray?[index]    //描述组件
                {
                    let guideView = self.createSingleGuideView(hollowViews: hollows, describeArray: describeArray)
                    //将创建好的引导页放入队列中
                    guideViewQueue.push(guideView)
                    ret = true
                }
            }
        }
        return ret
    }
    
    //创建一个引导页
    fileprivate func createSingleGuideView(hollowViews: Array<HollowViewType>, describeArray: Array<Array<HollowDescribeInfo>>) -> UIView
    {
        //一个引导页
        let guideView = UIView(frame: self.bounds)
        guideView.backgroundColor = maskColor
        //蒙版路径
        let path = UIBezierPath(rect: self.bounds)
        //处理每一个需要镂空的组件
        for (index, hollow) in hollowViews.enumerated()
        {
            //计算镂空组件在window上的frame
            //扩展frame
            //计算frame的贝塞尔曲线
            let (frame, hollowPath) = hollow.getFramePath()
            path.append(hollowPath)
            //添加描述组件
            guideView.addSubview(createDescribeView(frame: frame, describeViews: describeArray[index]))
        }
        let sl = CAShapeLayer()
        sl.path = path.cgPath
        guideView.layer.mask = sl
        
        return guideView
    }
    
    //添加描述组件在镂空组件周围
    //参数：frame：镂空组件的frame；describeViews：围绕在镂空组件周围的描述组件信息
    fileprivate func createDescribeView(frame: CGRect, describeViews: Array<HollowDescribeInfo>) -> UIView
    {
        let containerView = UIView(frame: self.bounds)
        for describeInfo in describeViews
        {
            let view = describeInfo.getView(frame: frame)
            containerView.addSubview(view)
        }
        return containerView
    }
    
    //显示每一个引导页
    fileprivate func showGuideView()
    {
        //先移除上一次的view
        for v in self.containerView.subviews
        {
            v.removeFromSuperview()
        }
        //显示下一个，如果有的话
        if let view = guideViewQueue.pop()
        {
            self.containerView.addSubview(view)
            currentIndex += 1
            if let cb = nextCallback
            {
                cb(currentIndex)
            }
        }
        else    //如果没有下一个引导页了，那么完成引导
        {
            self.finishGuide()
        }
    }
    
    //完成引导
    fileprivate func finishGuide()
    {
        //清理资源
        hollowViewArray = nil
        describeInfoArray = nil
        guideViewQueue.clear()
        
        if let cb = finishCallback
        {
            cb()
        }
        
        self.removeFromSuperview()
    }
    
    deinit {
        FSLog(self.className + " dealloc")
    }
    
}


//内部类型
extension FSGuideView: InternalType
{
    ///镂空组件类型
    struct HollowViewType {
        //需要被镂空的组件
        var hollowView: UIView
        //被镂空组件向外扩展规则
        var expandRule: HollowFrameExpand = .none
        //镂空组件圆角类型
        var rounded: HollowRoundedType = .circle
        
        //获取镂空组件的frame和frame区域的path，并计算扩展规则、圆角规则
        func getFramePath() -> (CGRect, UIBezierPath)
        {
            //计算镂空组件在window上的frame
            var frame = hollowView.convert(hollowView.bounds, to: g_window())
            //扩展frame
            frame = expandRule.getNewFrame(frame: frame)
            //计算frame的贝塞尔曲线
            let hollowPath = UIBezierPath(roundedRect: frame, cornerRadius: rounded.getRounded(frame: frame))
            return (frame, hollowPath.reversing())
        }
    }
    
    ///用于描述相对于被镂空组件的说明组件或图片的信息
    ///包括组件类型，组件或图片内容，相对于镂空组件的位置等
    struct HollowDescribeInfo {
        //用于显示说明信息的组件，一般是图片
        var component: UIView
        //组件大小
        var size: CGSize
        //组件距离目标镂空的位置，一般启用其中的两个即可，例如：左上/右下/左下/右上
        //top和bottom对应top/bottom；left和right对应left/right。
        //如果在top中指定了left或right，那么默认取0；如果在left中指定了top或bottom，那么默认取0；其他同样
        //如果既指定了top，又指定了bottom，那么以top为准；如果指定了left和right，那么以left为准
        var top: HollowDescribeInfoPosition
        var left: HollowDescribeInfoPosition
        var bottom: HollowDescribeInfoPosition
        var right: HollowDescribeInfoPosition
        
        //根据参数计算出一个准确frame的view，参数：frame：镂空组件的frame
        func getView(frame: CGRect) -> UIView
        {
            //初始化默认值，和镂空组件摆在同样的位置
            var x: CGFloat = frame.origin.x
            var y: CGFloat = frame.origin.y
            let width: CGFloat = size.width
            let height: CGFloat = size.height
            //先计算x，和left和right有关
            switch left {
            case .on(let side, let value):
                switch side {
                case .left:
                    x = frame.origin.x + value
                case .right:
                    x = frame.origin.x + frame.size.width + value
                default:
                    break
                }
            case .off:  //如果没有指定left，那么检查right
                switch right {
                case .on(let side, let value):
                    switch side {
                    case .left:
                        x = frame.origin.x - width + value
                    case .right:
                        x = frame.origin.x + frame.size.width - width + value
                    default:
                        break
                    }
                default:
                    break
                }
            }
            //计算y，和top和bottom有关
            switch top {
            case .on(let side, let value):
                switch side {
                case .top:
                    y = frame.origin.y + value
                case .bottom:
                    y = frame.origin.y + frame.size.height + value
                default:
                    break
                }
            case .off:
                switch bottom {
                case .on(let side, let value):
                    switch side {
                    case .top:
                        y = frame.origin.y - height + value
                    case .bottom:
                        y = frame.origin.y + frame.size.height - height + value
                    default:
                        break
                    }
                default:
                    break
                }
            }
            //x/y计算完成后，赋值给view
            component.frame = CGRect(x: x, y: y, width: width, height: height)
            return component
        }
    }

    ///组件是否启用某个位置标记
    enum HollowDescribeInfoPosition: Equatable {
        //不启用这个位置
        case off
        //启用这个位置并绑定数据，0:镂空目标的边，1:距离（根据UIView坐标确定正负，比如x：正数往右，负数往左；y：正数往下，负数往上）；
        //举例：on(left, 10)
        //自然语言描述为:组件的某边距离目标镂空的左边10px
        case on(UIViewSide, CGFloat)
        
        static func == (lhs: Self, rhs: Self) -> Bool
        {
            switch (lhs, rhs) {
            case (.off, .off):
                return true
            case (.on(_, _), .on(_, _)):
                return true
            default:
                return false
            }
        }
    }
    
    ///镂空组件frame向外扩展规则
    enum HollowFrameExpand {
        case none       //不扩展
        case fixed(CGFloat)         //固定扩展范围，上下左右扩展同一个值
        case symmetry(CGFloat, CGFloat)     //对称扩展，分别指定左右和上下的扩展范围，左右和上下将会扩展相同的大小
        case custom(CGFloat, CGFloat, CGFloat, CGFloat)     //自定义扩展范围，可以分别指定左右上下
        case symmetryPercentage(Float)    //对称百分比扩展，左右和上下分别扩展width和height的一个百分比值
        case customPercentage(Float, Float)     //自定义百分比扩展，分别指定左右和上下扩展自width和height的百分比值
        case independentPercentage(Float, Float, Float, Float)  //独立百分比扩展，左右上下分别指定扩展自width和height的百分比值
        
        ///根据传入的frame计算扩展后的frame
        func getNewFrame(frame: CGRect) -> CGRect
        {
            var newFrame: CGRect
            switch self {
            case .none:
                newFrame = frame
            case .fixed(let exp):
                newFrame = CGRect(x: frame.origin.x - exp, y: frame.origin.y - exp, width: frame.size.width + exp * 2.0, height: frame.size.height + exp * 2.0)
            case .symmetry(let lr, let tb):
                newFrame = CGRect(x: frame.origin.x - lr, y: frame.origin.y - tb, width: frame.size.width + lr * 2.0, height: frame.size.height + tb * 2.0)
            case .custom(let left, let right, let top, let bottom):
                newFrame = CGRect(x: frame.origin.x - left, y: frame.origin.y - top, width: frame.size.width + left + right, height: frame.size.height + top + bottom)
            case .symmetryPercentage(let ratio):
                let xP = frame.size.width * CGFloat(ratio)
                let yP = frame.size.height * CGFloat(ratio)
                newFrame = CGRect(x: frame.origin.x - xP, y: frame.origin.y - yP, width: frame.size.width + xP * 2.0, height: frame.size.height + yP * 2.0)
            case .customPercentage(let lr, let tb):
                let xP = frame.size.width * CGFloat(lr)
                let yP = frame.size.height * CGFloat(tb)
                newFrame = CGRect(x: frame.origin.x - xP, y: frame.origin.y - yP, width: frame.size.width + xP * 2.0, height: frame.size.height + yP * 2.0)
            case .independentPercentage(let left, let right, let top, let bottom):
                let lP = frame.size.width * CGFloat(left)
                let rP = frame.size.width * CGFloat(right)
                let tP = frame.size.height * CGFloat(top)
                let bP = frame.size.height * CGFloat(bottom)
                newFrame = CGRect(x: frame.origin.x - lP, y: frame.origin.y - tP, width: frame.size.width + lP + rP, height: frame.size.height + tP + bP)
            }
            return newFrame
        }
    }
    
    ///镂空组件圆角类型
    enum HollowRoundedType {
        case none                   //直角
        case circle                 //短边将会是一个半圆
        case rounded(CGFloat)       //自定义圆角大小
        
        ///获取圆角大小
        func getRounded(frame: CGRect) -> CGFloat
        {
            switch self {
            case .none:
                return 0.0
            case .circle:
                let min = minBetween(frame.size.width, frame.size.height)
                return min / 2.0
            case .rounded(let num):
                let maxRounded = minBetween(frame.size.width, frame.size.height) / 2.0
                return num > maxRounded ? maxRounded : num
            }
        }
    }
    
}


//外部接口
extension FSGuideView: ExternalInterface
{
    //设置完属性后，需要调用该方法才会显示引导页
    override func updateView() {
        if self.createGuideViews()
        {
            g_window().addSubview(self)
            //控制跳过按钮显示隐藏，如果只有一个引导页不显示，否则根据设置值显示
            skipBtn.isHidden = guideViewQueue.count() > 1 ? (showSkip ? false : true) : true
            if let cb = willShowCallback
            {
                cb()
            }
            //开始显示引导页
            self.showGuideView()
        }
        else    //如果没有创建任何引导页，那么直接完成显示
        {
            self.finishGuide()
        }
    }
    
}
