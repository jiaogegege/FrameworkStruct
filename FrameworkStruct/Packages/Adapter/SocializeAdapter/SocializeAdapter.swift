//
//  SocializeAdapter.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/4/1.
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
    func systemShare(title: String, img: UIImage, urlStr: String?)
    {
        let act = SocializeActivity(title: title, img: img, urlStr: urlStr)
        let vc = UIActivityViewController(activityItems: [title, img], applicationActivities: [act])
        vc.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            FSLog("system share: \(completed ? "success" : "failure")")
        }
        ControllerManager.shared.topVC.present(vc, animated: true)
    }
    
}
