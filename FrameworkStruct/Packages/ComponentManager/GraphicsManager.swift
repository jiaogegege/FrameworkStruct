//
//  GraphicsManager.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/1/5.
//

/**
 * 系统绘图组件管理，绘制各种图形、表格等
 */
import UIKit

class GraphicsManager: OriginManager
{
    //MARK: 属性
    //单例
    static let shared = GraphicsManager()
    
    //虚线参数，有一个默认值，外部程序可以随时修改该参数，绘制虚线的时候会使用这个参数
    lazy var dotLine: DotLineType = DotLineType.defaultType
    
    
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


//内部类型
extension GraphicsManager: InternalType
{
    ///虚线参数结构体，给一个默认值
    struct DotLineType
    {
        var phase: CGFloat
        var lengths: [CGFloat]
        
        //默认值
        static let zeroType: DotLineType = DotLineType(phase: 0, lengths: [])
        static let defaultType: DotLineType = DotLineType(phase: 4.0, lengths: [4, 7, 10])
    }
    
}


//接口方法
extension GraphicsManager: ExternalInterface
{
    ///设置是否使用虚线
    func setUseDotLine(context: CGContext, use: Bool)
    {
        /**
         绘制虚线
         @phase : 虚线起始线段的长度偏差,则第一段的长度为: lengths[0] - phase
         @lengths : 一个存放虚线间隔和绘制长度的数组
         */
        if use
        {
            context.setLineDash(phase: dotLine.phase, lengths: dotLine.lengths)
        }
        else
        {
            context.setLineDash(phase: DotLineType.zeroType.phase, lengths: DotLineType.zeroType.lengths)
        }
    }
    
    ///绘制直线
    ///参数：
    ///context：绘图上下文
    ///lineWidth：线宽
    ///lineColor：颜色
    ///startPoint：起始点
    ///endPoint：结束点
    ///useDotLine：是否使用虚线
    func drawLine(context: CGContext,
                  lineWidth: CGFloat,
                  lineColor: UIColor = .black,
                  startPoint: CGPoint,
                  endPoint: CGPoint,
                  useDotLine: Bool = false)
    {
        // 设置绘制的颜色
        lineColor.set()
        // 设置宽度
        context.setLineWidth(lineWidth)
        // 设置起始点
        context.move(to: startPoint)
        // 添加绘制路径点
        context.addLine(to: endPoint)
        //设置是否虚线
        setUseDotLine(context: context, use: useDotLine)
        // 绘制路径
        context.strokePath()
    }
    
    ///绘制多段折线
    func drawPolyline(context: CGContext,
                      lineWidth: CGFloat,
                      lineColor: UIColor = .black,
                      points: [CGPoint],
                      useDotLine: Bool = false)
    {
        // 设置绘制的颜色
        lineColor.set()
        // 设置宽度
        context.setLineWidth(lineWidth)
        /**
         绘制各点之间的线段
         
         @ between : 存放的点的数组。
         */
        context.addLines(between: points)
        //设置是否虚线
        setUseDotLine(context: context, use: useDotLine)
        // 绘制路径
        context.strokePath()
    }
    
    ///绘制两点之间的连线
    func drawStrokeLineSegments(context: CGContext,
                                lineWidth: CGFloat,
                                lineColor: UIColor = .black,
                                points: [CGPoint],
                                useDotLine: Bool = false)
    {
        // 设置绘制的颜色
        UIColor.red.set()
        // 设置宽度
        context.setLineWidth(lineWidth)
        /**
         绘制两点之间的线段
         @between: 是要绘制点的数组集合。
         注意: 如果 between 里面的点的个数是偶数，那就是每两点之间的连线。如果为奇数，在最后一个点将和（0，0）点组成一组的连线。
         */
        context.strokeLineSegments(between: points)
        //设置是否虚线
        setUseDotLine(context: context, use: useDotLine)
        // 绘制路径
        context.strokePath()
    }
    
    ///绘制曲线
    ///参数：
    ///controlPoint1：单点控制曲线
    ///controlPoint2：如果这个参数有值，那么使用两点控制曲线；就是样条曲线的两种控制方法
    func drawCurve(context:CGContext,
                   lineWidth: CGFloat,
                   lineColor: UIColor = .black,
                   startPoint: CGPoint,
                   endPoint: CGPoint,
                   controlPoint1: CGPoint,
                   controlPoint2: CGPoint? = nil,
                   useDotLine: Bool = false)
    {
        // 设置绘制的颜色
        lineColor.set()
        // 设置宽度
        context.setLineWidth(lineWidth)
        // 设置起始点
        context.move(to: startPoint)
        if let controlPoint2 = controlPoint2    //两点控制曲线
        {
            /**
             两点控制曲线
             to : 曲线的结束点
             control1 : 曲线控制点一。
             control2 : 曲线控制点二
             */
            context.addCurve(to: endPoint, control1: controlPoint1, control2: controlPoint2)
        }
        else    //单点控制曲线
        {
            /**
             单点控制曲线
             to : 曲线的结束点
             control: 曲线的控制点
             */
            context.addQuadCurve(to: endPoint, control: controlPoint1)
        }
        //设置是否虚线
        setUseDotLine(context: context, use: useDotLine)
        // 绘制路径
        context.strokePath()
    }
    
    ///绘制矩形
    ///isFill:是否是填充模式，false：线框模式；true：填充模式
    func drawRect(context:CGContext,
                  rect: CGRect,
                  lineWidth: CGFloat,
                  lineColor: UIColor = .black,
                  fillColor: UIColor = .black,
                  useDotLine: Bool = false,
                  isFill: Bool = false)
    {
        // 设置绘制的颜色
        context.setStrokeColor(lineColor.cgColor)
        //设置填充颜色
        context.setFillColor(fillColor.cgColor)
        // 设置宽度
        context.setLineWidth(lineWidth)
        /**
         设置绘制四边形的大小，通过控制长和宽绘制长方形和正方形
         
         @ x : 四边形的起点X轴的位置。
         @ y : 四边形的起点Y轴的位置。
         @ width : 绘制四边形的宽度。
         @ height : 绘制四边形的高度。
         
         注意： width = height 绘制的是正方形
         */
        context.addRect(rect)
        //设置是否虚线
        setUseDotLine(context: context, use: useDotLine)
        // 绘制路径
        isFill ? context.fillPath() : context.strokePath()
    }
    
    ///绘制圆角矩形
    ///rounded:圆角半径，圆角就是1/4个圆形
    func drawRoundedRect(context:CGContext,
                         rect: CGRect,
                         lineWidth: CGFloat,
                         lineColor: UIColor = .black,
                         fillColor: UIColor = .black,
                         rounded: CGFloat,
                         useDotLine: Bool = false,
                         isFill: Bool = false)
    {
        // 设置绘制的颜色
        context.setStrokeColor(lineColor.cgColor)
        //设置填充颜色
        context.setFillColor(fillColor.cgColor)
        // 设置宽度
        context.setLineWidth(lineWidth)
        //添加路径
        context.move(to: CGPoint(x: rect.origin.x + rounded, y: rect.origin.y))
        context.addArc(tangent1End: CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y), tangent2End: CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y + rect.size.height), radius: rounded)
        context.addArc(tangent1End: CGPoint(x: rect.origin.x + rect.size.width , y: rect.origin.y + rect.size.height), tangent2End: CGPoint(x: rect.origin.x, y: rect.origin.y + rect.size.height), radius: rounded)
        context.addArc(tangent1End: CGPoint(x: rect.origin.x, y: rect.origin.y + rect.size.height), tangent2End: CGPoint(x: rect.origin.x, y: rect.origin.y), radius: rounded)
        context.addArc(tangent1End: CGPoint(x: rect.origin.x, y: rect.origin.y), tangent2End: CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y), radius: rounded)
        //设置是否虚线
        setUseDotLine(context: context, use: useDotLine)
        // 绘制路径
        isFill ? context.fillPath() : context.strokePath()
    }
    
    ///以圆心和半径来绘制圆弧
    ///参数：
    ///start：开始弧度：-2pi~2pi
    ///end：结束弧度：-2pi~2pi
    ///clockwise：是否顺时针
    func drawArc(context:CGContext,
                 lineWidth: CGFloat,
                 lineColor: UIColor = .black,
                 fillColor: UIColor = .black,
                 center: CGPoint,
                 radius: CGFloat,
                 start: CGFloat,
                 end: CGFloat,
                 clockwise: Bool = true,
                 useDotLine: Bool = false,
                 isFill: Bool = false)
    {
        // 设置绘制的颜色
        context.setStrokeColor(lineColor.cgColor)
        //设置填充颜色
        context.setFillColor(fillColor.cgColor)
        // 设置宽度
        context.setLineWidth(lineWidth)
        /**
         绘制圆弧
         
         @center : 圆弧的中心点。
         @radius : 圆弧的半径。
         @startAngle : 圆弧开始的角度。
         @endAngle : 圆弧结束的角度。
         @clockwise: 绘制圆弧的方向。true为顺时针，false为逆时针。
         */
        context.addArc(center: center, radius: radius, startAngle: start, endAngle: end, clockwise: !clockwise)
        //设置是否虚线
        setUseDotLine(context: context, use: useDotLine)
        // 绘制路径
        isFill ? context.fillPath() : context.strokePath()
    }
    
    ///根据圆弧的起终点和半径绘制圆弧，基本原理：连接start和point1和point2，形成一个夹角，圆弧和夹角两边相切；如果start距离圆弧和第一条边的切点有距离，那么用直线连接
    func drawArc(context:CGContext,
                 lineWidth: CGFloat,
                 lineColor: UIColor = .black,
                 start: CGPoint,
                 point1: CGPoint,
                 point2: CGPoint,
                 radius: CGFloat,
                 useDotLine: Bool = false)
    {
        // 设置绘制的颜色
        lineColor.set()
        // 设置宽度
        context.setLineWidth(lineWidth)
        // 移动起始点
        context.move(to: start)
        /**
         有两个切点和半径绘制圆弧
         
         @tangent1End : 切点一。
         @tangent2End : 切点二。
         @radius : 圆弧的半径。
         */
        context.addArc(tangent1End: point1, tangent2End: point2, radius: radius)
        //设置是否虚线
        setUseDotLine(context: context, use: useDotLine)
        // 绘制路径
        context.strokePath()
    }
    
    ///绘制椭圆
    ///rect:椭圆的外接矩形
    ///useDotLine:是否使用虚线绘制
    ///isFill：是否是填充模式
    func drawEllipse(context: CGContext,
                     rect: CGRect,
                     lineWidth: CGFloat,
                     lineColor: UIColor = .black,
                     fillColor: UIColor = .black,
                     useDotLine: Bool = false,
                     isFill: Bool = false)
    {
        // 设置绘制的颜色
        context.setStrokeColor(lineColor.cgColor)
        //设置填充颜色
        context.setFillColor(fillColor.cgColor)
        context.setLineWidth(lineWidth)
        /*
         rect是椭圆的外接矩形
         */
        context.addEllipse(in: rect)
        //设置是否虚线
        setUseDotLine(context: context, use: useDotLine)
        // 必和路径
        isFill ? context.fillPath() : context.strokePath()
    }
    
    ///裁剪多个可绘制区域
    func clipRects(context: CGContext)
    {
        
    }
    
    ///设置多个填充区域
    func fillRects(context: CGContext)
    {
        
    }
    
    ///绘制图像
    func drawImage(context: CGContext)
    {
        
    }
    
    ///绘制文字
    ///参数：
    ///position：在画布中的位置，左上角；areaSize：绘制区域大小,如果不指定，那么文字为一行，并且无长度限制
    func drawText(context: CGContext, text: String, font: UIFont, color: UIColor, position: CGPoint, areaSize: CGSize?)
    {
        let attrs = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color]
        if let areaSize = areaSize
        {
            (text as NSString).draw(in: CGRect(origin: position, size: areaSize), withAttributes: attrs)
        }
        else
        {
            (text as NSString).draw(at: position, withAttributes: attrs)
        }
    }
    
    ///绘制属性文字
    ///参数：
    ///position：在画布中的位置，左上角；areaSize：绘制区域大小,如果不指定，那么文字为一行，并且无长度限制
    func drawAttrText(context: CGContext, attrStr: NSAttributedString, position: CGPoint, areaSize: CGSize?)
    {
        if let areaSize = areaSize
        {
            attrStr.draw(in: CGRect(origin: position, size: areaSize))
        }
        else
        {
            attrStr.draw(at: position)
        }
    }
    
    ///绘制一个简单表格
    func drawSimpleTableView(frame: CGRect, data: Array<Array<String>>) -> SimpleTableView
    {
        let tbView = SimpleTableView(frame: frame)
        tbView.dataArray = data
        tbView.updateView()
        return tbView
    }
    
}
