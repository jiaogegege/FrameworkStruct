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

class Utility: NSObject
{
    
    //跳转到app store评分
    static func gotoAppStoreComment()
    {
        let urlStr = "itms-apps://itunes.apple.com/app/id\(kAppId)?action=write-review"
        UIApplication.shared.open(URL.init(string: urlStr)!, options: [:], completionHandler: nil)
    }
    
    //获得沙盒文件夹路径
    static func getHomePath() -> String
    {
        return SandBoxAccessor.getHomeDirectory()
    }
    
    //获得Documents文件夹路径
    static func getDocumentPath() -> String
    {
        return SandBoxAccessor.getDocumentDirectory()
    }
    
    //获得Library路径
    static func getLibraryPath() -> String
    {
        return SandBoxAccessor.getLibraryDirectory()
    }
    
    //获取 Temp 的路径
    static func getTempPath() -> String
    {
        return SandBoxAccessor.getTempDirectory()
    }
    
    //返回一个拷贝的数据对象，如果是NSObject，那么返回copy对象；如果是Array/Dictionary，需要复制容器中的所有对象，返回新的容器和对象；其他返回原始值（基础类型、结构体、枚举等）
    static func getCopy(origin: Any?) -> Any
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
    
    //获得一个对象的类名
    static func getObjClassName(obj: AnyObject) -> String
    {
        let typeName = type(of: obj).description()
        return typeName.components(separatedBy: ".").last!
    }
    
    // iOS11之后没有automaticallyAdjustsScrollViewInsets属性，第一个参数是当下的控制器适配iOS11 一下的，第二个参数表示scrollview或子类
    static func adjustsScrollViewInsetNever(controller: UIViewController, scrollView: UIScrollView)
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
    
    //获取window对象
    static func getWindow() -> UIWindow
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
        if let kw = UIApplication.shared.keyWindow
        {
            return kw
        }
        if let w = UIApplication.shared.windows.first
        {
            return w
        }
        return UIWindow()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
