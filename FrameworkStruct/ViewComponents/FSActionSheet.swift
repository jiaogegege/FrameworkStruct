//
//  FSActionSheet.swift
//  FrameworkStruct
//
//  Created by jggg on 2022/1/12.
//

/**
 * 系统底部选择器
 */
import UIKit

class FSActionSheet: UIAlertController, AlertManagerProtocol
{
    //MARK: 属性
    //静态变量，记录已经创建的FSActionSheet对象
    static let identifierKeyMap = WeakDictionary.init()
    
    //遵循alertmanager协议，提供属性
    var dismissCallback: VoClo?
    
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
        FSLog("FSActionSheet: dealloc")
    }

}


//接口方法
extension FSActionSheet: ExternalInterface
{
    //创建一个actionsheet
    class func actionSheet(title: String? = nil,
                           message: String? = nil,
                           actionArray: Array<[ASItemName: GnClo<UIAlertAction>]>,
                           cancelAction: GnClo<UIAlertAction>? = nil,
                           identifierKey: String,
                           tintColor: UIColor,
                           inViewController: UIViewController? = nil) -> FSActionSheet?
    {
        if identifierKeyMap.object(forKey: identifierKey) is FSActionSheet
        {
            //如果有值那么不创建
            return nil
        }
        
        let actionSheet = FSActionSheet(title: title, message: message, preferredStyle: .actionSheet)
        actionSheet.identifierKey = identifierKey
        //添加动作按钮
        for action in actionArray
        {
            let act = UIAlertAction(title: action.keys.first, style: .default, handler: action.values.first)
            act.setValue(tintColor, forKey: "titleTextColor")
            actionSheet.addAction(act)
        }
        //添加取消按钮
        if let cancel = cancelAction
        {
            let cancelAct = UIAlertAction(title: String.cancel, style: .cancel, handler: cancel)
//            cancelAct.setValue(tintColor, forKey: "titleTextColor")
            actionSheet.addAction(cancelAct)
        }
        //设置自身到字典中
        identifierKeyMap.setObject(actionSheet, forKey: identifierKey)
        if let parent = inViewController
        {
            parent.present(actionSheet, animated: true, completion: nil)
        }
        return actionSheet
    }
    
    //消失掉所有的弹框
    static func dismissAllActionSheet(completion:VoClo?)
    {
        let keys = self.identifierKeyMap.keyEnumerator()
        for key in keys
        {
            let actionSheet = identifierKeyMap.object(forKey: key) as! FSActionSheet
            actionSheet.presentingViewController?.dismiss(animated: false, completion: nil)
        }
        if let comp = completion
        {
            comp()
        }
    }
    
}


//内部类型
extension FSActionSheet: InternalType
{
    //actionsheet上每一个条目的标题类型，就是String
    typealias ASItemName = String
    
}
