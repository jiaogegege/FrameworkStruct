//
//  UIExtension.swift
//  FrameworkStruct
//
//  Created by jggg on 2021/12/13.
//

/**
 * UI组件扩展
 */
import UIKit

//MARK: 扩展存储属性的key
/**
 * 扩展存储属性的key
 * 用于给系统组件动态添加存储属性
 */
struct UIExtensionStoragePropertyKey
{
    ///按钮点击后无法再次点击的时间间隔
    static var buttonDisableIntervalKey: String = "buttonDisableIntervalKey"
    
}


//MARK: UIViewController
/**
 * UIViewController
 */
extension UIViewController
{
    
    
    ///通用获取vc的方法，子类可覆写该方法，比如从storyboard创建VC时
    @objc class func getViewController() -> Self
    {
        Self.init()
    }
    
    ///从storyboard获得一个VC
    ///参数：storyboard：storyboard名字
    @objc static func getVC(from storyboard: String) -> Self
    {
        UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: Self.className) as! Self
    }
    
    //初始化控制器数据，比如一些状态和变量
    //如果子类覆写这个方法，需要调用父类方法
    //初始化时执行一次
    @objc func initData()
    {
        
    }
    
    //创建界面，一般用来创建界面组件，该方法应该只执行一次，多次执行会导致重复创建
    //如果子类覆写这个方法，需要调用父类方法
    //初始化时执行一次
    @objc func createUI()
    {
        
    }
    
    //配置界面，用来设置界面组件，比如frame，颜色，字体等，可多次执行
    //如果子类覆写这个方法，需要调用父类方法
    //初始化时执行一次
    @objc func configUI()
    {
        
    }
    
    //更新UI组件的布局，比如frame、约束等
    //这个方法可能被多次执行，所以不要在这里创建任何对象
    //如果子类覆写这个方法，需要调用父类方法
    //会多次执行
    @objc func layoutUI()
    {
        
    }

    //更新界面，一般是更新界面上的一些数据
    //如果子类覆写这个方法，需要调用父类方法
    //初始化时执行一次
    //可以手动调用这个方法
    @objc func updateUI()
    {
        
    }
    
    //主题更新UI
    //如果子类覆写这个方法，需要调用父类方法
    //初始化时执行一次，主题变化时执行
    //参数：theme：新的主题对象；isDark：是否暗黑主题
    @objc func themeUpdateUI(theme: ThemeProtocol, isDark: Bool = false)
    {
        
    }
    
    //添加通知
    //如果子类覆写这个方法，需要调用父类方法
    @objc func addNotification()
    {
        
    }
    
    /// iOS11之后没有automaticallyAdjustsScrollViewInsets属性，第一个参数是当下的控制器适配iOS11以下的，第二个参数表示scrollview或子类
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
    
    /**************************************** show VC Section Begin ***************************************/
    //是否可以push一个VC，取决于自身有没有navigationVC
    func canPush() -> Bool
    {
        self.navigationController != nil
    }
    
    //push一个VC，可能失败，取决于自身有没有navigationVC
    func push(_ vc: UIViewController, hideTabBar: Bool = true, animated: Bool = true)
    {
        vc.hidesBottomBarWhenPushed = hideTabBar
        self.navigationController?.pushViewController(vc, animated: animated)
    }
    
    ///pop返回上一VC或rootVC
    func pop(_ toRoot: Bool = false, animated: Bool = true)
    {
        if toRoot
        {
            self.navigationController?.popToRootViewController(animated: animated)
        }
        else
        {
            self.navigationController?.popViewController(animated: animated)
        }
    }
    
    ///pop返回多层VC，如果index大于最大VC数，则返回到rootVC
    ///参数：index：返回第几个VC，0=当前VC；1=上一个VC；2=上上个VC
    func popAt(_ index: UInt, animated: Bool = true)
    {
        if let vcs = self.navigationController?.viewControllers
        {
            if index <= 0
            {
                //当前VC什么都不做
            }
            else if index >= vcs.count - 1   //返回rootVC
            {
                self.navigationController?.popToRootViewController(animated: animated)
            }
            else    //返回某一个VC
            {
                let vc = vcs[vcs.count - 1 - Int(index)]
                self.navigationController?.popToViewController(vc, animated: animated)
            }
        }
    }
    
    ///pop返回到stack中的第一个某一种VC，没找到则什么都不做
    func popTo(_ vcType: UIViewController.Type, animated: Bool = true)
    {
        if let vcs = self.navigationController?.viewControllers
        {
            //查找第一个符合要求的vc，反向遍历
            for (_, value) in vcs.enumerated().reversed()
            {
                if type(of: value) == vcType
                {
                    self.navigationController?.popToViewController(value, animated: animated)
                    break
                }
            }
        }
    }
    
    ///modal显示一个VC
    ///参数：
    ///mode：modal模式；isModal：是否禁止手动下滑让modal的VC消失，默认不禁止
    func modal(_ vc: UIViewController, mode: UIModalPresentationStyle = .fullScreen, isModal: Bool = false, animated: Bool = true, completion: VoClo? = nil)
    {
        vc.modalPresentationStyle = mode
        vc.isModalInPresentation = isModal
        self.present(vc, animated: animated) {
            if let cb = completion
            {
                cb()
            }
        }
    }
    /**************************************** show VC Section End ***************************************/
    
}

//UIViewController内部类型
extension UIViewController
{
    //HookEvent
    struct HookEvent {
        static let viewWillAppear: FSHook.HookEventType = "viewWillAppear"
        static let viewDidAppear: FSHook.HookEventType = "viewDidAppear"
        static let viewWillDisappear: FSHook.HookEventType = "viewWillDisappear"
        static let viewDidDisappear: FSHook.HookEventType = "viewDidDisappear"
        static let viewDidLayoutSubviews: FSHook.HookEventType = "viewDidLayoutSubviews"
        static let dealloc: FSHook.HookEventType = "dealloc"
    }
    
}


//MARK: UIView
/**
 * UIView
 */
extension UIView
{
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
    
    ///删除所有子view
    func removeAllSubviews()
    {
        for sub in self.subviews
        {
            sub.removeFromSuperview()
        }
    }
    
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
    
    /**
     * 给一个透明view添加圆角和阴影
     * 参数：self：要添加圆角和阴影的view；cornerSide：圆角在哪一边上；needShadow：是否要添加阴影
     * 做法：基本做法是在self上添加一个和自身等大的带4边圆角的view，然后盖住对面边的圆角；阴影也是添加在等大的view上
     */
    func addRadiusAndShadow(cornerSide: UIViewSide = .all, bgColor: UIColor = .white, cornerRadius: CGFloat = 10.0, needShadow: Bool = true, shadowColor: UIColor = .black, shadowOffset: CGSize = .zero, shadowOpacity: Float = 0.5, shadowRadius: CGFloat = 5.0)
    {
        self.removeAllSubviews()
        self.backgroundColor = .clear
        let cornerView = UIView()
        cornerView.backgroundColor = bgColor
        cornerView.layer.cornerRadius = cornerRadius
        if needShadow   //添加阴影
        {
            cornerView.setLayerShadow(color: shadowColor, offset: shadowOffset, opacity: shadowOpacity, radius: shadowRadius)
        }
        self.addSubview(cornerView)
        cornerView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalToSuperview()
        }
        let coverView = UIView()
        coverView.backgroundColor = cornerSide == .all ? .clear : bgColor
        self.addSubview(coverView)
        coverView.snp.makeConstraints { make in
            switch cornerSide {
            case .left:    //放右边
                make.right.equalToSuperview()
                make.width.equalTo(cornerRadius)
                make.top.bottom.equalToSuperview()
            case .top:    //放下边
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview()
                make.height.equalTo(cornerRadius)
            case .right:    //放左边
                make.top.bottom.equalToSuperview()
                make.left.equalToSuperview()
                make.width.equalTo(cornerRadius)
            case .bottom:   //放上边
                make.left.right.equalToSuperview()
                make.top.equalToSuperview()
                make.height.equalTo(cornerRadius)
            case .all:  //如果是全部，那么不需要coverView
                make.left.top.right.bottom.equalToSuperview()
            }
        }
    }
    
}

//UIView内部类型
extension UIView
{
    //边的位置：left/top/right/bottom/all
    enum UIViewSide {
    case left, top, right, bottom, all
    }
    
}


//MARK: UILabel
/**
 * UILabel
 */
extension UILabel {
    
    /// UILabel根据文字的需要的高度
    public var requiredHeight: CGFloat {
        let label = UILabel(frame: CGRect(
            x: 0,
            y: 0,
            width: frame.width,
            height: CGFloat.greatestFiniteMagnitude)
        )
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = text
        if let attr = attributedText {
            label.attributedText = attr
        }
        label.sizeToFit()
        return label.frame.height
    }
    
    /// UILabel根据文字实际的行数，不太准，谨慎使用
    public var realLines: Int {
        return Int(requiredHeight / font.lineHeight)
    }
    
    ///设置行高
    func setText(_ text: String, lineSpace: CGFloat)
    {
        guard lineSpace > 0.01 else {
            return
        }
        let parah = NSMutableParagraphStyle()
        parah.lineSpacing = lineSpace
        parah.lineBreakMode = self.lineBreakMode
        parah.alignment = self.textAlignment
        let attrStr = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: parah])
        self.attributedText = attrStr
    }
    
}


//MARK: UIButton
/**
 * UIButton
 */
extension UIButton
{
    /**************************************** 图标和文本位置调整 Section Begin ***************************************/
    ///将图片设置在文字的右侧
    func imageRightTextLeft()
    {
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: (self.width / 2.0 + (self.titleLabel?.width ?? 0) / 2.0), bottom: 0, right: 0)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(self.imageView?.intrinsicContentSize.width ?? 0), bottom: 0, right: 0)
    }
    
    ///图标和文字都居中
    func imageCenterTextCenter()
    {
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(self.imageView?.width ?? 0), bottom: 0, right: 0)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -(self.titleLabel?.intrinsicContentSize.width ?? 0))
    }
    
    ///图标在上，文字在下，水平居中；offset：文本和图标的间距
    func imageTopTextBottom(_ offset: CGFloat = 0)
    {
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(self.imageView?.width ?? 0), bottom: -(self.imageView?.height ?? 0) - offset / 2.0, right: 0)
        self.imageEdgeInsets = UIEdgeInsets(top: -(self.titleLabel?.intrinsicContentSize.height ?? 0) - offset / 2.0, left: 0, bottom: 0, right: -(self.titleLabel?.intrinsicContentSize.width ?? 0))
    }
    
    ///文本左对齐，图标右对齐
    func textLeftAlignImageRightAlign()
    {
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(self.imageView?.width ?? 0) - self.width + (self.titleLabel?.intrinsicContentSize.width ?? 0), bottom: 0, right: 0)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -(self.titleLabel?.width ?? 0) - self.width + (self.imageView?.width ?? 0))
    }
    
    /**************************************** 图标和文本位置调整 Section End ***************************************/
    
    /**************************************** UIButton点击后延时不可点击 Section Begin ***************************************/
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
        let intv = maxBetween(interval, self.disableInterval)
        g_after(intv) {
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
    /**************************************** UIButton点击后延时不可点击 Section End ***************************************/
    
}


//MARK: UITableView
/**
 * UITableView
 */
extension UITableView
{
    ///在此处刷新tableview可禁用动画效果，包括自动估高的抖动
    class func refreshWithoutAnimation(_ tableView: UITableView, _ action: VoClo)
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
        if self.numberOfRows(inSection: 0) > 0
        {
            self.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
        }
        self.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
        self.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    ///滚动到底部
    func scrollToBottom()
    {
        let section = self.numberOfSections - 1
        let row = self.numberOfRows(inSection: section) - 1
        self.scrollToRow(at: IndexPath(row: row, section: section), at: .bottom, animated: true)
    }
    
    ///滚动到指定cell
    ///position：滚动到tableview的位置，默认在tableview的中间位置
    func scrollTo(row: Int, section: Int, position: UITableView.ScrollPosition = .middle, animated: Bool = true)
    {
        let indexPath = IndexPath(row: row, section: section)
        self.selectRow(at: indexPath, animated: animated, scrollPosition: .middle)
        g_after(animated ? 1 : 0) {
            self.deselectRow(at: indexPath, animated: animated)
        }
    }
    
    ///判断某个indexPath是否显示在屏幕中
    func isVisible(row: Int, secton: Int) -> Bool
    {
        var visible = false
        if let shows = self.indexPathsForVisibleRows
        {
            for item in shows
            {
                if item.row == row && item.section == secton
                {
                    visible = true
                    break
                }
            }
        }
        return visible
    }
    
    ///判断某个cell是否显示在屏幕上
    func isVisibleCell(_ cell: UITableViewCell) -> Bool
    {
        var visible = false
        let cells = self.visibleCells
        for cel in cells
        {
            if cel.isEqual(cell)
            {
                visible = true
                break
            }
        }
        return visible
    }
    
}

///UITableView内部类型
extension UITableView
{
    ///UITableView的section、row的位置标记
    ///用来替代indexPath的section和row的数字写法，改成枚举绑定数字，绑定的值就是那一行在tableview中的位置
    ///绑定的值由业务逻辑决定，需要使用者手动绑定；如果指定的那一行不存在，那么绑定值为-1或其它负数
    enum IndexPathTag
    {
        case sectionTag(Int)    //绑定section标记
        case rowTag(Int)    //绑定row标记
        case indexTag(section: Int, row: Int)     //绑定index标记(section, row)
        
        ///计算属性
        ///返回绑定的section或row在tableview中的位置
        ///不需要的值，返回-1，取值的时候，只取需要的值
        var position: (section: Int, row: Int) {
            switch self {
            case .sectionTag(let section):
                return (section, -1)
            case .rowTag(let row):
                return (-1, row)
            case .indexTag(let section, let row):
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
            case .indexTag(let section, let row):
                return (section > -1 && row > -1) ? 1 : 0
            }
        }
        
        ///传入一个枚举类型数组，返回应该显示的section或者row的总数
        ///参数:`itemArray`：总是同一种类型的，比如都是`sectionTag`
        static func totalCount(_ itemArray: Array<IndexPathTag>) -> Int
        {
            return itemArray.reduce(0) { count, indexPath in
                count + indexPath.positionCount
            }
        }
    }
    
}


//MARK: UITableViewCell
/**
 * UITableViewCell
 */
extension UITableViewCell
{
    ///cell类唯一标志符
    class var reuseId: String {
        Self.className
    }
    
}


//MARK: UICollectionView
/**
 * UICollectionView
 */
extension UICollectionView
{
    ///滚动到顶部
    func scrollToTop()
    {
        if self.numberOfItems(inSection: 0) > 0
        {
            self.scrollToItem(at: IndexPath(item: 0, section: 0), at: .bottom, animated: true)
        }
        self.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
        self.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    ///滚动到底部
    func scrollToBottom()
    {
        let section = self.numberOfSections - 1
        let row = self.numberOfItems(inSection: section) - 1
        self.scrollToItem(at: IndexPath(row: row, section: section), at: .bottom, animated: true)
    }
    
}


//MARK: UICollectionViewCell
/**
 * UICollectionViewCell
 */
extension UICollectionViewCell
{
    ///cell类唯一标志符
    class var reuseId: String {
        Self.className
    }
    
}


//MARK: UIColor
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
    class func colorWithHex(_ colorStr: String , alpha: CGFloat = 1) -> UIColor
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
        if (cString.hasPrefix(String.sSharp))
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
    class func colorFromHex(_ value : Int , alpha : CGFloat = 1) -> UIColor
    {
        let red = CGFloat((value & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((value & 0xFF00) >> 8) / 255.0
        let blue = CGFloat(value & 0xFF) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    ///红绿蓝255值转换成UIColor，RGBA都有默认值，默认纯白色
    class func colorWithRGBA(red: CGFloat = 255.0, green: CGFloat = 255.0, blue: CGFloat = 255.0, alpha: CGFloat = 1.0) -> UIColor
    {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }
    
    ///暗黑模式支持
    ///keepBright：在黑暗模式下，如果计算出的颜色是暗色，是否保持亮色，一般用于标题等醒目元素
    ///keepDark:在黑暗模式下，如果计算出的颜色是亮色，是否保持暗色，一般用于背景等不醒目元素
    ///level：颜色级别，更深的黑色或浅一点的黑色；更亮的白色或暗一点的白色
    func switchDarkMode(keepBright: Bool = false, keepDark: Bool = false, level: DarkModeLevel = .deepen) -> UIColor
    {
        return UIColor.init { trait in
            if trait.userInterfaceStyle == .dark    //暗黑模式，返回一个设计好的颜色值，这个值根据UI设计和具体的颜色变化
            {
                let light = level.getColor(dark: false)
                let dark = level.getColor(dark: true)
                //获取颜色的明度
                let brightness = UnsafeMutablePointer<CGFloat>.allocate(capacity: 0)
                self.getHue(nil, saturation: nil, brightness: brightness, alpha: nil)
                if brightness.pointee > 0.5 //如果颜色的明度高于0.5，那么设置为一种黑色
                {
                    brightness.deallocate()
                    return keepBright ? light : dark
                }
                else    //如果颜色明度低于0.5，那么设置为一种白色
                {
                    brightness.deallocate()
                    return keepDark ? dark : light
                }
            }
            else    //浅色模式，返回自身颜色值
            {
                return self
            }
        }
    }
    
}

//UIColor内部类型
extension UIColor
{
    //暗黑模式级别
    enum DarkModeLevel {
        case deepest                    //最底层的黑色或最顶层的白色
        case deepen                     //中间层的黑色或中间层的白色
        case dodge                      //较亮的黑色或较暗的白色
        
        //获取颜色，dark：是否是黑色，否则就是白色
        func getColor(dark: Bool) -> UIColor
        {
            switch self {
            case .deepest:
                return dark ? ThemeManager.shared.getDarkTheme().backgroundColor : ThemeManager.shared.getDarkTheme().mainTitleColor
            case .deepen:
                return dark ? ThemeManager.shared.getDarkTheme().backgroundColor : ThemeManager.shared.getDarkTheme().mainTitleColor
            case .dodge:
                return dark ? ThemeManager.shared.getDarkTheme().contentBackgroundColor : ThemeManager.shared.getDarkTheme().subTitleColor
            }
        }
    }
    
}


//MARK: UIImage
/**
 * UIImage
 */
extension UIImage
{
    ///根据颜色生成纯色图片
    ///参数：color：传入的颜色；size：生成纯色图片的尺寸，默认屏幕大小
    class func createImageWithColor(_ color: UIColor, size: CGSize = .fullScreen) -> UIImage
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
    func imageByZip(_ zipLength: CGFloat = 100.0) -> UIImage
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
    
    ///拉伸图片，重复图片中心1*1像素，一般用于内容单纯的小图拉伸为大图填满某个区域
    ///参数：size：指定被拉伸区域距离左边和顶部的距离，单位px
    func stretch(_ size: CGSize = .zero) -> UIImage
    {
        if size == .zero    //拉伸中间1px
        {
            return self.stretchableImage(withLeftCapWidth: Int(self.size.width * 0.5), topCapHeight: Int(self.size.height * 0.5))
        }
        else    //左边和顶部距离根据参数指定
        {
            let left: Int = Int(size.width)
            let top: Int = Int(size.height)
            return self.stretchableImage(withLeftCapWidth: left, topCapHeight: top)
        }
    }
    
    ///将图片编码为base64字符串
    ///imageType：图片类型，目前支持png和jpg
    func base64(_ imageType: FileTypeName = .png) -> String?
    {
        guard let data = imageType == .png ? self.pngData() : self.jpegData(compressionQuality: 1) else {
            return nil
        }
        let str = data.base64EncodedString()
//        let baseStr = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.init(charactersIn: ":/?#[]@!$&’()*+,;="))
        return str
    }
    
    ///将base64图片转化为UIImage
    class func fromBase64(_ str: String) -> UIImage?
    {
        guard let data = Data(base64Encoded: str) else {
            return nil
        }
        return UIImage(data: data)
    }
    
    ///保存到相册
    func saveToAlbum()
    {
        UIImageWriteToSavedPhotosAlbum(self, nil, nil, nil)
    }
    
    ///截取一个给定区域内的图片
    func getImageInRect(_ rect: CGRect) -> UIImage?
    {
        let sourceImageRef = self.cgImage
        let newImageRef = sourceImageRef?.cropping(to: rect)
        if let newImageRef = newImageRef
        {
            return UIImage(cgImage: newImageRef)
        }
        
        return nil
    }
    
    ///提取图片主色调并返回颜色，此处提取的是颜色最亮的色调，并非像素点最多的颜色
    ///type：想要提取的颜色种类
    func getMainHue(_ type: PaletteTargetMode = [], callback: @escaping ((UIColor?) -> Void))
    {
        self.getPaletteImageColor(with: type) { recommendColor, allColors, error in
            guard error == nil else {
                FSLog(error!.localizedDescription)
                callback(nil)
                return
            }
            
            if let rmdStr = recommendColor?.imageColorString {
                callback(UIColor.colorWithHex(rmdStr))
            }
            else
            {
                callback(nil)
            }
        }
    }
    
    ///提取图片的主色调，像素点最多的颜色
    func getSubjectColor(_ completion: @escaping ((UIColor?) -> Void))
    {
        DispatchQueue.global().async {
            if self.cgImage == nil
            {
                DispatchQueue.main.async {
                    return completion(nil)
                }
            }
            
            let bitmapInfo = CGBitmapInfo(rawValue: 0).rawValue | CGImageAlphaInfo.premultipliedLast.rawValue
            //第一步，缩小图片，加快计算
            let thumbSize = CGSize(width: 50, height: 50)
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            guard let context = CGContext(data: nil, width: Int(thumbSize.width), height: Int(thumbSize.height), bitsPerComponent: 8, bytesPerRow: Int(thumbSize.width) * 4, space: colorSpace, bitmapInfo: bitmapInfo) else { return completion(nil) }
            let drawRect = CGRect(x: 0, y: 0, width: thumbSize.width, height: thumbSize.height)
            context.draw(self.cgImage!, in: drawRect)
            //第二步，取每个点的像素值
            if context.data == nil { return completion(nil) }
            let countedSet = NSCountedSet(capacity: Int(thumbSize.width * thumbSize.height))
            for x in 0..<Int(thumbSize.width)
            {
                for y in 0..<Int(thumbSize.width)
                {
                    let offset = 4 * x * y
                    let red = context.data!.load(fromByteOffset: offset, as: UInt8.self)
                    let green = context.data!.load(fromByteOffset: offset + 1, as: UInt8.self)
                    let blue = context.data!.load(fromByteOffset: offset + 2, as: UInt8.self)
                    let alpha = context.data!.load(fromByteOffset: offset + 3, as: UInt8.self)
                    //过滤透明/基本白色/基本黑色
                    if alpha > 0 && (red < 250 && green < 250 && blue < 250) && (red > 5 && green > 5 && blue > 5)
                    {
                        let array = [red, green, blue, alpha]
                        countedSet.add(array)
                    }
                }
            }
            //第三步，找出出现次数最多的颜色
            let enumerator = countedSet.objectEnumerator()
            var maxColor: [Int] = []
            var maxCount = 0
            while let curColor = enumerator.nextObject() as? [Int], !curColor.isEmpty
            {
                let tmpCount = countedSet.count(for: curColor)
                if tmpCount < maxCount { continue }
                maxCount = tmpCount
                maxColor = curColor
            }
            let color = UIColor(red: CGFloat(maxColor[0]) / 255.0, green: CGFloat(maxColor[1]) / 255.0, blue: CGFloat(maxColor[2]) / 255.0, alpha: CGFloat(maxColor[3]) / 255.0)
            DispatchQueue.main.async {
                return completion(color)
            }
        }
    }
    
}
