//
//  GuideManager.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/3/25.
//

/**
 * 处理各种新手引导的显示和隐藏，以及状态管理
 * 每一个接口方法都是一个具体的引导页显示，只需要外部UI传入需要镂空的组件即可
 */
import UIKit

class GuideManager: OriginManager
{
    //MARK: 属性
    //单例
    static let shared = GuideManager()
    
    
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
extension GuideManager: ExternalInterface
{
    ///示例代码
    ///参数：
    ///label/button/switcher都是要被镂空的组件
    func guideOrderAdd(label: UILabel,
                       button: UIButton,
                       switcher: UISwitch,
                       didShow: VoidClosure? = nil,
                       didNext: VoidClosure? = nil,
                       didSkip: VoidClosure? = nil,
                       didFinish: VoidClosure? = nil) -> FSGuideView
    {
        let v = FSGuideView()
        let h1 = FSGuideView.HollowViewType(hollowView: label, expandRule: .customPercentage(0.1, 0.1), rounded: .circle)
        let h2 = FSGuideView.HollowViewType(hollowView: button, expandRule: .symmetryPercentage(0.08), rounded: .rounded(10))
        let h3 = FSGuideView.HollowViewType(hollowView: switcher, expandRule: .fixed(10), rounded: .none)
        v.hollowViewArray = [[h1, h2], [h3]]
        let hand2 = FSGuideView.HollowDescribeInfo(component: UIImageView(image: .iGuideHand), size: CGSize(width: 38, height: 33), top: .off, left: .on(.left, 5), bottom: .on(.top, -8), right: .off)
        let hand = FSGuideView.HollowDescribeInfo(component: UIImageView(image: .iGuideHand), size: CGSize(width: 38, height: 33), top: .on(.bottom, 8), left: .off, bottom: .off, right: .on(.right, 5))
        let add = FSGuideView.HollowDescribeInfo(component: UIImageView(image: .iGuideOrderAdd), size: CGSize(width: 264, height: 34), top: .off, left: .off, bottom: .on(.bottom, 34 + 8), right: .on(.right, -50))
        let hand3 = FSGuideView.HollowDescribeInfo(component: UIImageView(image: .iGuideHand), size: CGSize(width: 38, height: 33), top: .on(.bottom, -4), left: .on(.right, 3), bottom: .off, right: .off)
        v.describeInfoArray = [[[hand2], [hand, add]], [[hand3]]]
        v.willShowCallback = { () in
            if let cb = didShow
            {
                cb()
            }
        }
        v.nextCallback = { (index) in
            if let cb = didNext
            {
                cb()
            }
        }
        v.skipCallback = { () in
            if let cb = didSkip
            {
                cb()
            }
        }
        v.finishCallback = { () in
            //此处应该保存一些标记位，比如已经显示过了引导页，那么设置为已读，下次就不显示了
            if let cb = didFinish
            {
                cb()
            }
        }
        v.updateView()
        return v
    }
    
}
