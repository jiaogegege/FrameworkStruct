//
//  SocializeActivity.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/4/1.
//

/**
 * 继承自`UIActivity`的自定义分享功能，具体需要哪些功能应该根据实际项目需求定义
 */
import UIKit

class SocializeActivity: UIActivity
{
    //MARK: 属性
    fileprivate var titleStr: String
    
    override var activityTitle: String? {
        get {
            return self.titleStr
        }
    }
    
    fileprivate var img: UIImage
    
    override var activityImage: UIImage? {
        get {
            return self.img
        }
    }
    
    fileprivate var url: URL?
    
    
    //MARK: 方法
    //初始化方法，传入文本，图片，url，具体根据实际需求定义
    init(title: String, img: UIImage, urlStr: String?)
    {
        self.titleStr = title
        self.img = img
        if let urlStr = urlStr {
            self.url = URL(string: urlStr)
        }
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return true
    }
    
}
