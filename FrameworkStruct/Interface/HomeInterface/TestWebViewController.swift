//
//  TestWebViewController.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/2/25.
//

import UIKit

class TestWebViewController: BasicWebViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func initData() {
        super.initData()
        self.url = .local(SandBoxAccessor.shared.getBundleFilePath("jstest", ext: "html") ?? "")
//        self.url = .remote("https://www.baidu.com")
    }

}
