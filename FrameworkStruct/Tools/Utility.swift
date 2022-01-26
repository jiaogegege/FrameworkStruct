//
//  CommonTools.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/11/5.
//

/**
 * 通用工具集
 * 除去一些和特定领域及类型相关的专用特定的工具方法，这里定义一些杂七杂八的实用方法
 */
import UIKit


///跳转到app store评分
func gotoAppStoreComment()
{
    let urlStr = "itms-apps://itunes.apple.com/app/id\(gAppId)?action=write-review"
    UIApplication.shared.open(URL.init(string: urlStr)!, options: [:], completionHandler: nil)
}

///返回一个拷贝的数据对象，如果是NSObject，那么返回copy对象；如果是Array/Dictionary，需要复制容器中的所有对象，返回新的容器和对象；其他返回原始值（基础类型、结构体、枚举等）
func getCopy(origin: Any?) -> Any
{
    if let nsData = origin as? NSObject
    {
        return nsData.copy()
    }
    else if let array = origin as? Array<Any>
    {
        return array.copy()
    }
    else if let dic = origin as? Dictionary<AnyHashable, Any>
    {
        return dic.copy()
    }
    else
    {
        return origin as Any
    }
}

///获得一个对象的类名
func getObjClassName(_ obj: AnyObject) -> String
{
    let typeName = type(of: obj).description()
    return typeName.components(separatedBy: ".").last!
}

/// iOS11之后没有automaticallyAdjustsScrollViewInsets属性，第一个参数是当下的控制器适配iOS11 一下的，第二个参数表示scrollview或子类
func adjustsScrollViewInsetNever(controller: UIViewController, scrollView: UIScrollView)
{
    if #available(iOS 11.0, *)
    {
        scrollView.contentInsetAdjustmentBehavior = .never
    }
    else if controller.isKind(of: UIViewController.self)
    {
        controller.automaticallyAdjustsScrollViewInsets = false
    }
}

///获取window对象
func getWindow() -> UIWindow
{
    if let window = AppDelegate.shared().window
    {
        return window
    }
    if #available(iOS 13.0, *)
    {
        if let window = SceneDelegate.currentWindow()
        {
            return window
        }
    }
    else
    {
        if let kw = UIApplication.shared.keyWindow
        {
            return kw
        }
    }
    if let w = UIApplication.shared.windows.first
    {
        return w
    }
    return UIWindow()
}

///判断字符串是否是有效字符串，无效字符串：nil、null、<null>、<nil>、""、"(null)"、NSNull
func isValidString(_ str: String?) -> Bool
{
    guard let s = str?.trim() else {
        return false
    }
    
    if s == "" || s == "(null)" || s == "<null>" || s == "nil" || s == "<nil>" || (s as NSString).isKind(of: NSNull.self) || s.count <= 0
    {
        return false
    }
    return true
}

///判断是否有效对象，无效对象：nil，NSNull
func isValidObject(_ obj: AnyObject?) -> Bool
{
    guard let o = obj else {
        return false
    }
    
    if o.isKind(of: NSNull.self)
    {
        return false
    }
    return true
}

///打印一些信息，包含系统时间,打印的文件信息,要打印的内容
func printMsg<T>(message: T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line)
{
    #if DEBUG
        let arr = fileName.components(separatedBy: "/")
        print(getCurrentTimeString() + "\(arr.last!) - \(methodName)[\(lineNumber)]:\(message)")
    #endif
}

///打印简单信息，包含系统时间和文本内容
func FSLog(_ message: String)
{
    #if DEBUG
        print(getCurrentTimeString() + ": " + message)
    #endif
}


    
    
    
    

