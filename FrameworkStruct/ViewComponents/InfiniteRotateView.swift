//
//  InfiniteRotateView.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/10/27.
//

/**
 无限旋转动画view
 主要用于播放歌曲等，初始化时可以传入一个底图，不断更新中间小图，提供开始动画和暂停动画功能
 */
import UIKit

class InfiniteRotateView: UIView
{
    //MARK: 属性
    //底图
    var bgImage: UIImage?
    //中间图
    var contentImage: UIImage?
    //中间图片和底图直径的比值，应该是个0-1之间的数
    var ratio: CGFloat = 0.63 {
        willSet {
            let wid: CGFloat = frame.size.width <= frame.size.height ? frame.size.width : frame.size.height
            let conWid: CGFloat = wid * newValue
            contentImgView.frame = CGRect(x: (wid - conWid) / 2.0, y: (wid - conWid) / 2.0, width: conWid, height: conWid)
            contentImgView.layer.cornerRadius = contentImgView.width / 2.0
        }
    }
    //点击回调
    var clickCallback: VoidClosure?
    
    //旋转动画时长，请在开始动画前设置
    var animationTime: TimeInterval = 36.0
    
    //动画起始值
    fileprivate(set) var animationFromValue: Double = 0.0
    //动画终点值
    fileprivate(set) var animationToValue: Double = Double.pi * 2.0
    fileprivate var animationId: String?       //专辑图片旋转动画id
    fileprivate var animationTimer: DispatchSourceTimer?     //专辑图片旋转动画定时器
    
    //UI组件
    fileprivate var bgImgView: UIImageView!
    fileprivate var contentImgView: UIImageView!
    fileprivate var clickBtn: UIButton!
    
    //MARK: 方法
    //长宽最好设置成相等，如果不等，那么将以短边为准
    init(frame: CGRect, bgImage: UIImage?, contentImage: UIImage?) {
        self.bgImage = bgImage
        self.contentImage = contentImage
        super.init(frame: frame)
        createView()
        configView()
        updateView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createView() {
        //调整frame，以短边为准
        let wid: CGFloat = frame.size.width <= frame.size.height ? frame.size.width : frame.size.height
        self.width = wid
        self.height = wid
        
        bgImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: wid, height: wid))
        addSubview(bgImgView)
        
        let conWid: CGFloat = wid * ratio
        contentImgView = UIImageView(frame: CGRect(x: (wid - conWid) / 2.0, y: (wid - conWid) / 2.0, width: conWid, height: conWid))
        addSubview(contentImgView)
        
        clickBtn = UIButton(type: .custom)
        clickBtn.frame = self.bounds
        clickBtn.addTarget(self, action: #selector(clickAction(sender:)), for: .touchUpInside)
        addSubview(clickBtn)
    }
    
    override func configView() {
        contentImgView.layer.cornerRadius = contentImgView.width / 2.0
        contentImgView.clipsToBounds = true
    }
    
    override func updateView() {
        if let bgImage = bgImage {
            bgImgView.image = bgImage
        }
        if let contentImage = contentImage {
            contentImgView.image = GraphicsManager.shared.drawImage(contentImage, in: CGRect(x: 0, y: 0, width: contentImgView.width * 3, height: contentImgView.width * 3))
        }
    }
    
    //按钮点击事件
    @objc func clickAction(sender: UIButton)
    {
        if let cb = clickCallback
        {
            cb()
        }
    }
    
    //开启动画定时器
    fileprivate func startAnimationTimer()
    {
        let sliceValue = Self.oneRoundRadian / (animationTime / 0.1)
        let originValue = animationFromValue      //记录动画开始时的位置
        animationTimer = TimerManager.shared.dispatchTimer(interval: 0.1, onMain: true, exact: true, hostId: self.className, action: {[weak self] in
            self?.animationFromValue += sliceValue
            self?.animationToValue += sliceValue
            if self?.animationFromValue ?? 0.0 > Self.oneRoundRadian + originValue
            {
                self?.animationFromValue -= Self.oneRoundRadian
                self?.animationToValue -= Self.oneRoundRadian
            }
        })
    }

}


extension InfiniteRotateView: InternalType
{
    //旋转一圈的弧度
    static let oneRoundRadian = Double.pi * 2.0
    
}


extension InfiniteRotateView: ExternalInterface
{
    //开启动画
    func startAnimation()
    {
        stopAnimation()
        startAnimationTimer()
        animationId = AnimationManager.shared.popBasic(propertyName: kPOPLayerRotation, fromValue: animationFromValue, toValue: animationToValue, timingFuncName: .linear, duration: animationTime, isLoop: true, host: contentImgView.layer, startBlock: {
            
        }, reachToBlock: {
            
        })
    }
    
    //停止动画
    func stopAnimation()
    {
        animationTimer?.cancel()
        animationTimer = nil
        if animationFromValue > Self.oneRoundRadian
        {
            animationFromValue -= Self.oneRoundRadian
            animationToValue -= Self.oneRoundRadian
        }
        if let id = animationId
        {
            contentImgView.layer.pop_removeAnimation(forKey: id)
        }
    }
    
}
