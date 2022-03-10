//
//  CommonTools.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/11/5.
//

/**
 * 通用工具集
 * 除去一些和特定领域及类型相关的专用特定的工具方法，这里定义一些杂七杂八的实用方法
 * 方法名前面加`g_`表示全局函数
 */
import UIKit

///打印一些信息，包含系统时间,打印的文件信息,要打印的内容
func printMsg<T>(message: T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line)
{
    #if DEBUG
        let arr = fileName.components(separatedBy: "/")
        print(currentTimeString() + "\(arr.last!) - \(methodName)[\(lineNumber)]:\(message)")
    #endif
}

///打印简单信息，包含系统时间和文本内容
func FSLog(_ message: String)
{
    #if DEBUG
        print(currentTimeString() + ": " + message)
    #endif
}

///跳转到app store评分
func g_gotoAppStoreComment()
{
    let urlStr = "itms-apps://itunes.apple.com/app/id\(gAppId)?action=write-review"
    UIApplication.shared.open(URL.init(string: urlStr)!, options: [:], completionHandler: nil)
}

///返回一个拷贝的数据对象，如果是NSObject，那么返回copy对象；如果是Array/Dictionary，需要复制容器中的所有对象，返回新的容器和对象；其他返回原始值（基础类型、结构体、枚举等）
func g_getCopy(origin: Any?) -> Any?
{
    if origin != nil
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
    else
    {
        return origin
    }
}

///获得类型的类名的字符串
func g_getClassName(_ aClass: AnyClass) -> String
{
    return NSStringFromClass(aClass).components(separatedBy: ".").last!
}

///获得一个对象的类名
func g_getObjClassName(_ obj: AnyObject) -> String
{
    let typeName = type(of: obj).description()
    if(typeName.contains("."))
    {
        return typeName.components(separatedBy: ".").last!
    }
    else
    {
        return typeName
    }
}

/// iOS11之后没有automaticallyAdjustsScrollViewInsets属性，第一个参数是当下的控制器适配iOS11以下的，第二个参数表示scrollview或子类
func g_adjustsScrollViewInsetNever(controller: UIViewController, scrollView: UIScrollView)
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
func g_getWindow() -> UIWindow
{
    if let window = AppDelegate.shared().window
    {
        return window
    }
    if #available(iOS 13.0, *)
    {
        if let window = SceneDelegate.shared()?.currentWindow
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
    
    return UIWindow()   //永远不应该执行这一步
}

///判断字符串是否是有效字符串，无效字符串：nil、null、<null>、<nil>、""、"(null)"、NSNull
func g_isValidString(_ str: String?) -> Bool
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
func g_isValidObject(_ obj: AnyObject?) -> Bool
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

///在线程中异步执行代码
func g_async(onMain: Bool = true, action: @escaping VoidClosure)
{
    ThreadManager.shared.async(onMain: onMain, action: action)
}

///延时操作
func g_after(interval: TimeInterval, onMain: Bool = true, action: @escaping VoidClosure)
{
    TimerManager.shared.after(interval: interval, onMain: onMain, action: action)
}
    
///生成一个随机字符串
func g_uuidString() -> String
{
    return EncryptManager.shared.uuidString()
}
    
///获取设备id，在app安装周期内保持不变
func g_getDeviceId() -> String
{
    if let deviceId = UserDefaultsAccessor.shared.readString(key: UDAKeyType.deviceId)
    {
        return deviceId
    }
    else
    {
        let deviceId: String
        if let devId = kDeviceIdentifier
        {
            deviceId = devId.replacingOccurrences(of: "-", with: "_")
        }
        else    //如果系统未获取到，那么生成一个随机字符串，一般都会获取到
        {
            deviceId = g_uuidString()
        }
        UserDefaultsAccessor.shared.write(key: UDAKeyType.deviceId, value: deviceId)
        return deviceId
    }
}

///des加密一个字符串
func g_des(_ str: String, key: String) -> String
{
    return EncryptManager.shared.desString(originStr: str, desKey: key)
}
