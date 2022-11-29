//
//  SocializeAdapter.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/4/1.
//

/**
 * 社会化适配器
 * 目前主要包括分享功能，第三方分享和系统分享
 */
import UIKit


class SocializeAdapter: OriginAdapter
{
    //MARK: 属性
    //单例
    static let shared = SocializeAdapter()
    
    
    //MARK: 方法
    //私有化初始化方法
    private override init()
    {
        super.init()
    }
    
    override func copy() -> Any
    {
        return self
    }
    
    override func mutableCopy() -> Any
    {
        return self
    }

}


//接口方法
extension SocializeAdapter: ExternalInterface
{
    ///系统分享，示例，具体根据实际需求定义
    func systemShare(text: String, image: UIImage, urlStr: String?)
    {
        var items: [Any] = [text, image]
        if let urlStr = urlStr {
            if let url = URL(string: urlStr)
            {
                items.append(url)
            }
        }
        let vc = UIActivityViewController(activityItems: items, applicationActivities: [SocializeActivity.fsShareAction])
        vc.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            FSLog("system share: \(completed ? "success" : "failure")")
        }
        g_presentVC(vc)
    }
    
}
