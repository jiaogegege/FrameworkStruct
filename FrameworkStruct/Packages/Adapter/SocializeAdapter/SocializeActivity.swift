//
//  SocializeActivity.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/4/1.
//

/**
 * 继承自`UIActivity`的自定义系统分享功能，具体需要哪些功能应该根据实际项目需求定义
 */
import UIKit

class SocializeActivity: UIActivity
{
    //MARK: 属性
    override class var activityCategory: UIActivity.Category {
        get {
            return .share
        }
    }
    
    override var activityType: UIActivity.ActivityType? {
        get {
            return UIActivity.ActivityType(rawValue: self.className)
        }
    }
    
    //分享按钮标题
    fileprivate var titleStr: String
    
    override var activityTitle: String? {
        get {
            return self.titleStr
        }
    }
    
    //分享按钮图片
    fileprivate var img: UIImage
    
    override var activityImage: UIImage? {
        get {
            return self.img
        }
    }
    
    //回调
    //具体的分享动作
    fileprivate var shareAction: ((_ text: String?, _ image: UIImage?, _ url: URL?) -> Void)
    //分享完成的回调
    fileprivate var completion: ((_ completed: Bool) -> Void)
    
    //分享内容
    fileprivate var shareText: String?
    fileprivate var shareImg: UIImage?
    fileprivate var shareUrl: URL?
    
    
    //MARK: 方法
    //初始化方法，传入文本，图片，url，具体根据实际需求定义
    init(title: String, img: UIImage, shareAction: @escaping ((_ text: String?, _ image: UIImage?, _ url: URL?) -> Void), completion: @escaping ((_ completed: Bool) -> Void))
    {
        self.titleStr = title
        self.img = img
        self.shareAction = shareAction
        self.completion = completion
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        for item in activityItems {
            if item is UIImage {
                return true
            }
            if item is String {
                return true
            }
            if item is URL {
                return true
            }
        }
        return false
    }
    
    override func prepare(withActivityItems activityItems: [Any]) {
        for item in activityItems {
            if let it = item as? String
            {
                self.shareText = it
            }
            else if let it = item as? UIImage
            {
                self.shareImg = it
            }
            else if let it = item as? URL
            {
                self.shareUrl = it
            }
            else
            {
                printMsg(message: item)
            }
        }
    }
    
    override var activityViewController: UIViewController? {
        get {
            return nil
        }
    }
    
    //具体的分享动作
    override func perform() {
        self.shareAction(self.shareText, self.shareImg, self.shareUrl)
        self.activityDidFinish(true)
    }
    
    override func activityDidFinish(_ completed: Bool) {
        self.completion(completed)
        super.activityDidFinish(completed)
    }
    
}


//预定义分享按钮
extension SocializeActivity: ExternalInterface
{
    //示例分享按钮
    static let fsShareAction: SocializeActivity = SocializeActivity(title: String.appName, img: UIImage.iMiku_0!) { text, image, url in
        //具体的分享动作，根据需求设计，比如可以分享给某个好友
        print("text: \(text ?? "")-image: \(image ?? UIImage())-url: \(url?.absoluteString ?? "")")
    } completion: { completed in
        //分享完成的动作
        print("share complete: \(completed)")
    }


}
