//
//  DemoTopSelectBar.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2021/12/26.
//

/**
 * 测试用顶部选择条
 */
import UIKit

class DemoTopSelectBar: UIView
{
    //MARK: 属性
    var titleArray: [String] = []
    var btnArray: [UIButton] = []
    fileprivate(set) var currentIndex: Int = -1
    var bar: UIView!
    var animated: Bool = true
    
    //MARK: 方法
    override func createView()
    {
        self.backgroundColor = .white
        
        var firstBtn: UIButton? = nil
        var preBtn: UIButton? = nil
        for (index, title) in self.titleArray.enumerated()
        {
            let btn = UIButton(type: .custom)
            btn.setTitle(title, for: .normal)
            btn.setTitleColor(.gray, for: .normal)
            btn.setTitleColor(.systemBlue, for: .selected)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: fitX(14))
            btn.tag = index
            btn.addTarget(self, action: #selector(btnAction(sender:)), for: .touchUpInside)
            self.addSubview(btn)
            btn.snp.makeConstraints { (make) in
                if index == 0
                {
                    make.left.equalToSuperview()
                }
                else
                {
                    if let preB = preBtn
                    {
                        make.left.equalTo(preB.snp.right).offset(fitX(10.0))
                    }
                }
                make.top.equalToSuperview()
                if let firstB = firstBtn
                {
                    make.width.equalTo(firstB.snp.width)
                }
                make.height.equalTo(fitX(20))
                if index >= self.titleArray.count - 1
                {
                    make.right.equalToSuperview()
                }
            }
            btnArray.append(btn)
            if index == 0
            {
                firstBtn = btn
            }
            preBtn = btn    //记录上一个按钮
        }
        
        //滑动条
        self.bar = UIView()
        bar.backgroundColor = .blue
        bar.layer.cornerRadius = 1.5
        self.addSubview(bar)
        bar.snp.makeConstraints { (make) in
            make.height.equalTo(3.0)
            if let firstB = firstBtn
            {
                make.centerX.equalTo(firstB.snp.centerX)
            }
            make.bottom.equalToSuperview()
            make.width.equalTo(fitX(60.0))
        }
        self.setSelect(curBtn: firstBtn!, animated: false)
    }
    
    //设置某个按钮选中
    func setSelect(curBtn: UIButton, animated: Bool)
    {
        if currentIndex < 0
        {
            self.currentIndex = curBtn.tag
        }
        else
        {
            let preBtn = btnArray[currentIndex]
            preBtn.isSelected = false
            currentIndex = curBtn.tag
        }
        curBtn.isSelected = true
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut) { [weak self] in
            self?.bar.snp.remakeConstraints { (make) in
                make.height.equalTo(3.0)
                make.centerX.equalTo(curBtn.snp.centerX)
                make.bottom.equalToSuperview()
                make.width.equalTo(fitX(60.0))
            }
            if animated
            {
                self?.layoutIfNeeded()
            }
        } completion: { (finished) in
            
        }

    }
    
    @objc func btnAction(sender: UIButton)
    {
        if sender.tag == currentIndex
        {
            return
        }
        self.setSelect(curBtn: sender, animated: self.animated)
    }

    deinit {
//        print("DemoTopSelectBar: dealloc")
    }
}
