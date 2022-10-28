//
//  DrawingCanvasView.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/4/2.
//

/**
 * 绘图用画布
 */
import UIKit

class DrawingCanvasView: UIView {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        if let ctx = UIGraphicsGetCurrentContext()
        {
            GraphicsManager.shared.drawLine(context: ctx, lineWidth: 5, lineColor: .systemPink, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 200, y: 0), useDotLine: true)
            GraphicsManager.shared.drawCurve(context: ctx, lineWidth: 5, lineColor: .cPink_ff709b, startPoint: CGPoint(x: 0, y: 15), endPoint: CGPoint(x: 200, y: 15), controlPoint1: CGPoint(x: 50, y: 50), controlPoint2: CGPoint(x: 75, y: 0))
            GraphicsManager.shared.drawRect(context: ctx, rect: CGRect(x: 0, y: 20, width: 200, height: 50), lineWidth: 3, lineColor: .blue, fillColor: .red, useDotLine: false, isFill: false)
            GraphicsManager.shared.drawEllipse(context: ctx, rect: CGRect(x: 5, y: 75, width: 100, height: 100), lineWidth: 4)
            GraphicsManager.shared.drawPolyline(context: ctx, lineWidth: 2, lineColor: .green, points: [CGPoint(x: 0, y: 0), CGPoint(x: 50, y: 50), CGPoint(x: 100, y: 70), CGPoint(x: 30, y: 20), CGPoint(x: 200, y: 200)], useDotLine: false)
            GraphicsManager.shared.drawArc(context: ctx, lineWidth: 4, lineColor: .red, center: CGPoint(x: 100, y: 100), radius: 80, start: 0, end: .pi-1, clockwise: true, useDotLine: false)
            GraphicsManager.shared.drawArc(context: ctx, lineWidth: 2, start: CGPoint(x: 0, y: 10), point1: CGPoint(x: 100, y: 10), point2: CGPoint(x: 150, y: 50), radius: 20)
            GraphicsManager.shared.drawRoundedRect(context: ctx, rect: CGRect(x: 100, y: 200, width: 250, height: 300), lineWidth: 4, lineColor: .orange, rounded: 20, useDotLine: false, isFill: true)
            GraphicsManager.shared.drawText(context: ctx, text: "圣诞快乐风景收到了看家实力的克己复礼开始点击是谁可怜的肌肤是考虑到解放路开始的实力对抗肌肤尻脸上的肌肤立刻圣诞节快乐发生的", font: UIFont.systemFont(ofSize: 20), color: .blue, position: CGPoint(x: 20, y: 50), areaSize: CGSize(width: 100, height: 200), lineBreak: .byTruncatingTail)
        }
    }

}
