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
    
}

extension UILabel
{
    
}
