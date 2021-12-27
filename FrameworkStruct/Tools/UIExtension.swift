//
//  UIExtension.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2021/12/13.
//

/**
 * UI组件扩展
 */
import Foundation
import UIKit

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

extension UIView
{
    /**
     * 切圆角
     * - Parameters:
     *  - conrners
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
