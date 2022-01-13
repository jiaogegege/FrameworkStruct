//
//  FSActionSheet.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/1/12.
//

/**
 * 系统底部选择器
 */
import UIKit

class FSActionSheet: UIAlertController
{
    //MARK: 属性
    //静态变量，记录已经创建的FSActionSheet对象
    static let identifierKeyMap = WeakDictionary.init()
    
    //遵循alertmanager协议，提供属性
    var dismissCallback: (() -> Void)?
    
    //唯一标志符
    fileprivate(set) var identifierKey: String? = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    deinit {
        if let callback = self.dismissCallback
        {
            callback()
        }
        print("FSActionSheet: dealloc")
    }

}


//接口方法
extension FSActionSheet: ExternalInterface
{
    //创建一个actionsheet
    class func actionSheet(title: String? = nil, ) -> FSActionSheet?
    {
        
    }
    
    //消失掉所有的弹框
    static func dismissAllAlert(completion:(() -> Void)?)
    {
        let keys = self.identifierKeyMap.keyEnumerator()
        for key in keys
        {
            let alertView = identifierKeyMap.object(forKey: key) as! FSAlertView
            alertView.presentingViewController?.dismiss(animated: false, completion: nil)
        }
        if let comp = completion
        {
            comp()
        }
    }
    
}
