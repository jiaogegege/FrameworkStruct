//
//  FSPageIndicatorBar.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/11/10.
//

/**
 条状页面指示器
 支持横向和竖向
 */
import UIKit

class FSPageIndicatorBar: UIView {
    //MARK: 属性
    var bgColor: UIColor = UIColor.white.withAlphaComponent(0.2) {       //背景色
        willSet {
            self.bgView.backgroundColor = newValue
        }
    }
    var barColor: UIColor = UIColor.white {         //前景色
        willSet {
            self.bar.backgroundColor = newValue
        }
    }
    //动画时长
    var animationTime: TimeInterval = 0.2
    
    //滚动方向
    fileprivate var scrollDirection: ScrollDirection = .horizontal
    
    var totalPage: Int = 0 {  //总页数
        willSet {
            let pageWidth: CGFloat = scrollDirection == .horizontal ? self.width / CGFloat(newValue) : self.height / CGFloat(newValue)    //一页的宽度
            bar.frame = CGRect(x: 0, y: 0, width: scrollDirection == .horizontal ? limitMin(pageWidth, min: self.height) : self.width, height: scrollDirection == .vertical ? limitMin(pageWidth, min: self.width) : self.height)
        }
    }
    
    fileprivate(set) var currentPage: Int = 0   //当前页
    
    //UI
    fileprivate var bgView: UIView!
    fileprivate var bar: UIView!
    
    //MARK: 方法
    init(frame: CGRect, pages: Int, direction: ScrollDirection = .horizontal) {
        self.scrollDirection = direction
        self.totalPage = pages
        super.init(frame: frame)
        createView()
        configView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createView() {
        bgView = UIView(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height))
        addSubview(bgView)
        
        bar = UIView(frame: CGRect(x: 0, y: 0, width: scrollDirection == .horizontal ? limitMin(self.width / CGFloat(self.totalPage), min: self.height) : self.width, height: scrollDirection == .vertical ? limitMin(self.height / CGFloat(self.totalPage), min: self.width) : self.height))
        addSubview(bar)
    }
    
    override func configView() {
        bgView.backgroundColor = bgColor
        let cornerRadius = bgView.width > bgView.height ? bgView.height / 2.0 : bgView.width / 2.0
        bgView.layer.cornerRadius = cornerRadius
        
        bar.backgroundColor = barColor
        bar.layer.cornerRadius = cornerRadius
    }

}


extension FSPageIndicatorBar: InternalType
{
    //滚动方向
    enum ScrollDirection {
        case horizontal         //水平
        case vertical           //竖直
    }
    
}


extension FSPageIndicatorBar: ExternalInterface
{
    //设置当前页
    func setCurrentPage(_ index: Int, animated: Bool = true)
    {
        guard index != currentPage else {
            return
        }
        
        self.currentPage = limitIn(index, min: 0, max: totalPage - 1)
        if animated
        {
            UIView.animate(withDuration: animationTime, delay: 0, options: .curveEaseOut) {
                if self.scrollDirection == .horizontal
                {
                    self.bar.x = CGFloat(self.currentPage) * (self.width - (self.bar.width > self.width / CGFloat(self.totalPage) ? self.bar.width - self.width / CGFloat(self.totalPage) : 0)) / CGFloat(self.totalPage)
                }
                else
                {
                    self.bar.y = CGFloat(self.currentPage) * (self.height - (self.bar.height > self.height / CGFloat(self.totalPage) ? self.bar.height - self.height / CGFloat(self.totalPage) : 0)) / CGFloat(self.totalPage)
                }
            } completion: { finished in
                
            }
        }
        else
        {
            if self.scrollDirection == .horizontal
            {
                self.bar.x = CGFloat(self.currentPage) * (self.width - (self.bar.width > self.width / CGFloat(self.totalPage) ? self.bar.width - self.width / CGFloat(self.totalPage) : 0)) / CGFloat(self.totalPage)
            }
            else
            {
                self.bar.y = CGFloat(self.currentPage) * (self.height - (self.bar.height > self.height / CGFloat(self.totalPage) ? self.bar.height - self.height / CGFloat(self.totalPage) : 0)) / CGFloat(self.totalPage)
            }
        }
    }
    
}
