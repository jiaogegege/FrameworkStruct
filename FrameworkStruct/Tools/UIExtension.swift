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
 * 用于给系统组件动态添加存储属性
 */
struct UIExtensionStoragePropertyKey
{
    ///按钮点击后无法再次点击的时间间隔
    static var buttonDisableIntervalKey: String = "buttonDisableIntervalKey"
    
}


/**
 * UIViewController
 */
extension UIViewController
{
    /// iOS11之后没有automaticallyAdjustsScrollViewInsets属性，第一个参数是当下的控制器适配iOS11 一下的，第二个参数表示scrollview或子类
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
    
    /**
     * view设置图层阴影
     */
    func setLayerShadow(color: UIColor = .black, offset: CGSize = .zero, opacity: Float = 0.5, radius: CGFloat = 5.0)
    {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    
    /**
     * view添加路径阴影，首先要设置view的frame
     */
    func addPathShadow(color: UIColor = .black, offset: CGSize = .zero, opacity: Float = 0.5, radius: CGFloat = 5.0)
    {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        //计算path的rect，根据传入的offset
        let rect = CGRect(x: offset.width, y: offset.height, width: self.width, height: self.height)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: self.layer.cornerRadius)
        self.layer.shadowPath = path.cgPath
    }
    
    ///创建view，用于子类实现
    @objc func createView()
    {
        
    }
    
    ///配置view，用于子类实现
    @objc func configView()
    {
        
    }
    
    ///更新view上的数据，用于子类实现
    @objc func updateView()
    {
        
    }
    
}


/**
 * UIButton
 */
extension UIButton
{
    ///设置button点击后在一定时间内不可再次点击，默认0
    var disableInterval: TimeInterval {
        set {
            objc_setAssociatedObject(self, &UIExtensionStoragePropertyKey.buttonDisableIntervalKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            if let interval = objc_getAssociatedObject(self, &UIExtensionStoragePropertyKey.buttonDisableIntervalKey) as? TimeInterval {
                return interval
            }
            return 0.0
        }
    }
    
    ///手动设置button不可再次点击，不可点击的时长取参数和属性之间的较大值
    func clickDisable(interval: TimeInterval = 0.0)
    {
        self.isEnabled = false
        let intv = maxBetween(one: interval, other: self.disableInterval)
        DispatchQueue.main.asyncAfter(deadline: .now() + intv) {
            self.isEnabled = true
        }
    }
    
    ///重写button方法，拦截响应事件并执行不可点击的时间间隔
    open override func sendAction(_ action: UIAction) {
        if #available(iOS 14.0, *) {
            super.sendAction(action)
        } else {
            // Fallback on earlier versions
        }
        if self.disableInterval > 0.0
        {
            self.clickDisable()
        }
    }
    
    ///重写button方法，拦截响应事件并执行不可点击的时间间隔
    open override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        super.sendAction(action, to: target, for: event)
        if self.disableInterval > 0.0
        {
            self.clickDisable()
        }
    }
    
}


/**
 * UITableView
 */
extension UITableView
{
    ///在此处刷新tableview可禁用动画效果，包括自动估高的抖动
    class func refreshWithoutAnimation(tableView: UITableView, _ action: VoidClosure)
    {
        UIView.performWithoutAnimation {
            tableView.beginUpdates()
            //在此处刷新tableview可禁用动画效果，包括自动估高的抖动
            action()
            tableView.endUpdates()
        }
    }
    
    ///滚动到顶部
    func scrollToTop()
    {
        self.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
    }
    
    ///滚动到底部
    func scrollToBottom()
    {
        let section = self.numberOfSections - 1
        let row = self.numberOfRows(inSection: section) - 1
        self.scrollToRow(at: IndexPath(row: row, section: section), at: .bottom, animated: true)
    }
    
}

///UITableView内部类型
extension UITableView: InternalType
{
    ///UITableView的section、row标记
    ///用来替代indexPath的section和row的数字写法，改成枚举绑定数字，绑定的值就是那一行在tableview中的位置
    ///绑定的值由业务逻辑决定，需要使用者手动绑定；如果指定的那一行不存在，那么绑定值为-1或其他负数
    enum UITableViewIndexPathTag
    {
        case sectionTag(Int)    //绑定section标记
        case rowTag(Int)    //绑定row标记
        case indexPathTag(section: Int, row: Int)     //绑定indexPath标记(section, row)
        
        ///返回绑定的section或row在tableview中的位置
        ///不需要的值，返回-1，取值的时候，只取需要的值
        var position: (section: Int, row: Int) {
            switch self {
            case .sectionTag(let section):
                return (section, -1)
            case .rowTag(let row):
                return (-1, row)
            case .indexPathTag(let section, let row):
                return (section, row)
            }
        }
        
        ///计算属性
        ///返回这个标记在列表中占据的位置数量，1是占据一位，0是不占位置
        ///该属性主要用来方便外部程序计算section和row的总数
        var positionCount: Int {
            switch self {
            case .sectionTag(let section):  //如果不是-1，那么section占据1位，如果是-1，那么不占位置
                return section > -1 ? 1 : 0
            case .rowTag(let row):
                return row > -1 ? 1 : 0
            case .indexPathTag(let section, let row):
                return (section > -1 && row > -1) ? 1 : 0
            }
        }

    }
    
}


/**
 * UIColor
 */
extension UIColor
{
    ///随机色
    class func randomRGB(alpha: CGFloat = 1.0) -> UIColor
    {
        return UIColor.init(red: CGFloat(arc4random() % 256) / 255.0, green: CGFloat(arc4random() % 256) / 255.0, blue: CGFloat(arc4random() % 256) / 255.0, alpha: alpha)
    }
    
    ///16进制颜色字符串转UIColor
    ///colorStr:支持“#123456”、 “0X123456”、 “123456”三种格式
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
    
    ///16进制颜色转换成UIColor
    static func colorFromHex(value : Int , alpha : CGFloat = 1) -> UIColor
    {
        let red = CGFloat((value & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((value & 0xFF00) >> 8) / 255.0
        let blue = CGFloat(value & 0xFF) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    ///红绿蓝255值转换成UIColor，RGBA都有默认值，默认纯白色
    static func colorWithRGBA(red: CGFloat = 255.0, green: CGFloat = 255.0, blue: CGFloat = 255.0, alpha: CGFloat = 1.0) -> UIColor
    {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }
    
}


/**
 * UIImage
 */
extension UIImage
{
    ///根据颜色生成纯色图片
    ///参数：color：传入的颜色；size：生成纯色图片的尺寸，默认屏幕大小
    class func createImageWithColor(color: UIColor, size: CGSize = CGSize(width: kScreenWidth, height: kScreenHeight)) -> UIImage
    {
        let rect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    ///压缩图片，等比例缩放
    ///参数：zipLength：图片压缩后宽度和高度的最大长度，限制较大的值，另一边按比例缩放
    func imageByZip(zipLength: CGFloat = 100.0) -> UIImage
    {
        if self.size.width <= zipLength
        {
            return self
        }
        var btWidth: CGFloat = 0.0
        var btHeight: CGFloat = 0.0
        if self.size.width > self.size.height   //如果宽>高，那么限制宽度为参数值
        {
            btWidth = zipLength
            btHeight = self.size.height / self.size.width * zipLength
        }
        else
        {
            btHeight = zipLength
            btWidth = self.size.width / self.size.height * zipLength
        }
        let targetSize = CGSize(width: btWidth, height: btHeight)
        UIGraphicsBeginImageContext(targetSize)
        self.draw(in: CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: targetSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self //如果压缩不成功，那么返回原始图片
    }
    
}
