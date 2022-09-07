//
//  Utility.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/11/5.
//

/**
 * 通用工具集
 * 对接其他功能模块中的方法，进行简化调用
 * 除去一些和特定领域及类型相关的专用特定的工具方法，这里定义一些杂七杂八的实用方法
 * 方法名前面加`g_`表示全局函数
 */
import UIKit

///打印一些信息，包含系统时间,打印的文件信息,要打印的内容
func printMsg<T>(message: T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line)
{
    #if DEBUG
        let arr = fileName.components(separatedBy: "/")
        print(currentTimeString() + " -> " + "\(arr.last!) : \(methodName) : [\(lineNumber)] : \(message)")
    #endif
}

///打印简单信息，包含系统时间和文本内容
func FSLog(_ message: String)
{
    #if DEBUG
        print(currentTimeString() + ": " + message)
    #endif
}

///返回一个拷贝的数据对象，如果是NSObject，那么返回copy对象；如果是Array/Dictionary，需要复制容器中的所有对象，返回新的容器和对象；其他返回原始值（基础类型、结构体、枚举等）
func g_copy(_ origin: Any?) -> Any?
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
func g_className(_ aClass: AnyClass) -> String
{
    NSStringFromClass(aClass).components(separatedBy: ".").last!
}

///获得一个对象的类名
func g_objClassName(_ obj: AnyObject) -> String
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

///获取window对象
func g_window() -> UIWindow
{
    ApplicationManager.shared.window
}

///获取顶层控制器
func g_topVC() -> UIViewController
{
    ControllerManager.shared.topVC
}

///判断字符串是否是有效字符串，无效字符串：nil、null、<null>、<nil>、""、"(null)"、NSNull
func g_validString(_ str: String?) -> Bool
{
    DatasChecker.shared.checkValidString(str)
}

///判断是否有效对象，无效对象：nil，NSNull
func g_validObject(_ obj: AnyObject?) -> Bool
{
    DatasChecker.shared.checkValidObject(obj)
}

///判断一个字符串是否都是数字
func g_checkNum(_ str: String) -> Bool
{
    DatasChecker.shared.checkNumber(str)
}

///在线程中异步执行代码
func g_async(onMain: Bool = true, action: @escaping VoidClosure)
{
    ThreadManager.shared.async(onMain: onMain, action: action)
}

///延时操作
func g_after(_ interval: TimeInterval, onMain: Bool = true, action: @escaping VoidClosure)
{
    TimerManager.shared.after(interval: interval, onMain: onMain, action: action)
}
    
///生成一个随机字符串
func g_uuid() -> String
{
    EncryptManager.shared.uuidString()
}
    
///获取设备id，在app安装周期内保持不变
func g_deviceId() -> String
{
    ApplicationManager.shared.getDeviceId()
}

///des加密一个字符串
func g_des(_ str: String, key: String) -> String
{
    EncryptManager.shared.des(str, desKey: key)
}

///des解密一个字符串
func g_desDecrypt(_ str: String?, key: String) -> String?
{
    guard str != nil else {
        return nil
    }
    return EncryptManager.shared.desDecrypt(str!, desKey: key)
}

///全局截屏
func g_screenShot() -> UIImage?
{
    ApplicationManager.shared.screenshot()
}

///push控制器
func g_pushVC(_ vc: UIViewController, animated: Bool = true)
{
    ControllerManager.shared.pushViewController(vc, animated: animated)
}

///present控制器
func g_presentVC(_ vc: UIViewController, animated: Bool = true)
{
    ControllerManager.shared.presentViewController(vc, animated: animated)
}

///当前用户token
var g_userToken: String? {
    UserManager.shared.currentUserToken
}

///当前用户id
var g_userId: String? {
    UserManager.shared.currentUserId
}

///默认价格格式，提供项目中最常用的形式，根据实际需求增减参数，参数：分
func g_price(_ fen: Int) -> NSAttributedString
{
    PriceEmbellisher.shared.toAttrPrice(fen,
                                        format: .twoDecimal,
                                        signType: .none,
                                        signColor: .black,
                                        signFont: .systemFont(ofSize: 20),
                                        hasSymbol: true,
                                        symbol: String.sCNY,
                                        symbolColor: .black,
                                        symbolFont: .systemFont(ofSize: 14),
                                        integerColor: .black,
                                        integetFont: .systemFont(ofSize: 20),
                                        decimalColor: .black,
                                        decimalFont: .systemFont(ofSize: 14),
                                        strokeLineType: [],
                                        strokeLineColor: .clear,
                                        underLineType: [],
                                        underlineColor: .clear)
}

///全局弹框
func g_alert(title: String,
             message: String? = nil,
             messageAlign: NSTextAlignment = .center,
             leftTitle: String? = String.cancel,
             leftBlock: VoidClosure? = nil,
             rightTitle: String? = String.confirm,
             rightBlock: VoidClosure? = nil)
{
    AlertManager.shared.wantPresentAlert(title: title, message: message, messageAlign: messageAlign, leftTitle: leftTitle, leftBlock: {
        if let leftBlock = leftBlock {
            leftBlock()
        }
    }, rightTitle: rightTitle) {
        if let rightBlock = rightBlock {
            rightBlock()
        }
    }
}
