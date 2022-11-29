//
//  TestWebViewController.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/2/25.
//

import UIKit

class TestWebViewController: BasicWebViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func createUI() {
        super.createUI()
        
    }

    override func initData() {
        super.initData()
//        self.url = .remote(WebUrlPath.helpCenterUrl.getUrl())
        self.url = .local(SandBoxAccessor.shared.getBundleFilePath("jstest", ext: "html") ?? "")
//        self.url = .remote("https://www.baidu.com")
    }

}
