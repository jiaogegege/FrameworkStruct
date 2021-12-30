//
//  ConstraintTestViewController.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2021/12/26.
//

import UIKit

class ConstraintTestViewController: BasicViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func createUI() {
        super.createUI()
        self.backgroundStyle = .white
        
        let topLine = UIView()
        topLine.backgroundColor = .red
        self.view.addSubview(topLine)
        topLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(kTopHeight)
            make.height.equalTo(30)
        }
        
        let topSel = DemoTopSelectBar()
        topSel.titleArray = ["可用以后", "不可用以后", "随机优惠券", "优惠券"]
        self.view.addSubview(topSel)
        topSel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(topLine.snp.bottom)
            make.height.equalTo(fitX(30.0))
        }
        topSel.createView()
    }
    
    override func configUI() {
        super.configUI()
        self.title = String.sConstraintTest
        
    }


}
