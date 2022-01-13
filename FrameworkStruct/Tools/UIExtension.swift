//
//  UIExtension.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2021/12/13.
//

/**
 * UI组件扩展
 */
import UIKit

/**
 * 扩展存储属性的key
 */
struct UIExtensionPropertyKey
{
    //按钮点击后无法再次点击的时间间隔
    static var buttonDisableIntervalKey: String = "btnDisableIntervalKey"
    
}

/**
 * UIViewController
 */
extension UIViewController
{
    // iOS11之后没有automaticallyAdjustsScrollViewInsets属性，第一个参数是当下的控制器适配iOS11 一下的，第二个参数表示scrollview或子类
    func adjustsScrollViewInsetNever(scrollView: UIScrollView)
    {
        if #available(iOS 11.0, *)
        {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        else
        {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
}


/**
 * UIView
 */
extension UIView
{
    /**
     * 切圆角
     * - Parameters:
     *  - conrners 需要切圆角的角
     *  - radius 圆角弧度
     */
    func addCorner(conrners: UIRectCorner , radius: CGFloat)
    {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: conrners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
}


/**
 * UIButton
 */
extension UIButton
{
    //设置button点击后在一定时间内不可再次点击，默认0
    var disableInterval: TimeInterval {
        set {
            objc_setAssociatedObject(self, &UIExtensionPropertyKey.buttonDisableIntervalKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            if let interval = objc_getAssociatedObject(self, &UIExtensionPropertyKey.buttonDisableIntervalKey) as? TimeInterval {
                return interval
            }
            return 0.0
        }
    }
    
    //手动设置button不可再次点击，不可点击的时长取参数和属性之间的较大值
    func clickDisable(interval: TimeInterval = 0.0)
    {
        self.isEnabled = false
        let intv = maxBetween(one: interval, other: self.disableInterval)
        DispatchQueue.main.asyncAfter(deadline: .now() + intv) {
            self.isEnabled = true
        }
    }
    
    //重写button方法，拦截响应事件并执行不可点击的时间间隔
    open override func sendAction(_ action: UIAction) {
        if #available(iOS 14.0, *) {
            super.sendAction(action)
        } else {
            // Fallback on earlier versions
        }
        self.clickDisable()
    }
    
    open override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        super.sendAction(action, to: target, for: event)
        self.clickDisable()
    }
    
}


/**
 * UIColor
 */
extension UIColor
{
    //16进制颜色字符串转UIColor
    //colorStr:支持“#123456”、 “0X123456”、 “123456”三种格式
    static func colorWithHex(colorStr: String , alpha: CGFloat = 1) -> UIColor
    {
        //删除字符串中的空格
        var cString = colorStr.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        // String should be 6 or 8 characters
        if (cString.count < 6)
        {
            return UIColor.clear
        }
        // strip 0X if it appears
        //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
        if (cString.hasPrefix("0X"))
        {
            cString = String(cString[cString.index(cString.startIndex, offsetBy: 2)...])
        }
        //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
        if (cString.hasPrefix("#"))
        {
            cString = String(cString[cString.index(cString.startIndex, offsetBy: 1)...])
        }
        if (cString.count != 6)
        {
            return UIColor.clear
        }
        
        // Separate into r, g, b substrings
        //r
        let rString = String(cString[cString.startIndex..<cString.index(cString.startIndex, offsetBy: 2)])
        //g
        let gString = String(cString[cString.index(cString.startIndex, offsetBy: 2)..<cString.index(cString.startIndex, offsetBy: 4)])
        //b
        let bString = String(cString[cString.index(cString.startIndex, offsetBy: 4)..<cString.index(cString.startIndex, offsetBy: 6)])
        
        // Scan values
        var r: UInt64 = 0, g: UInt64 = 0, b: UInt64 = 0
        Scanner(string: rString).scanHexInt64(&r)
        Scanner(string: gString).scanHexInt64(&g)
        Scanner(string: bString).scanHexInt64(&b)
        return UIColor.colorWithRGBA(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: alpha)
    }
    
    //16进制颜色转换成UIColor
    static func colorFromHex(value : Int , alpha : CGFloat = 1) -> UIColor
    {
        let red = CGFloat((value & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((value & 0xFF00) >> 8) / 255.0
        let blue = CGFloat(value & 0xFF) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    //红绿蓝255值转换成UIColor，RGBA都有默认值，默认纯白色
    static func colorWithRGBA(red: CGFloat = 255.0, green: CGFloat = 255.0, blue: CGFloat = 255.0, alpha: CGFloat = 1.0) -> UIColor
    {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }
    
}
