//
//  Utility.swift
//  FrameworkStruct
//
//  Created by  jggg on 2021/11/5.
//

/**
 * 通用工具集
 * 对接其他功能模块中的方法，进行简化调用
 * 除去一些和特定领域及类型相关的专用特定的工具方法，这里定义一些杂七杂八的实用方法
 * 方法名前面加`g_`表示全局函数
 */
import UIKit

//MARK: 打印日志
///打印一些信息，包含系统时间,打印的文件信息,要打印的内容
func printMsg<T>(message: T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line)
{
    #if DEBUG
    let arr = fileName.components(separatedBy: String.sSlash)
        print(currentTimeString() + " -> " + "\(arr.last!) : \(methodName) : [\(lineNumber)] : \(message)")
    #endif
}

///打印简单信息，包含系统时间和文本内容
func FSLog(_ message: String)
{
    #if DEBUG
    print(currentTimeString() + String.sColon + String.sSpace + message)
    #endif
}

//MARK: 类型判断和复制
///获得类型的类名的字符串
func g_className(_ aClass: AnyClass) -> String
{
    NSStringFromClass(aClass).components(separatedBy: String.sDot).last!
}

///获得一个对象的类名
func g_objClassName(_ obj: AnyObject) -> String
{
    let typeName = type(of: obj).description()
    if(typeName.contains(String.sDot))
    {
        return typeName.components(separatedBy: String.sDot).last!
    }
    else
    {
        return typeName
    }
}

///判断是否是对象
func g_isObj(_ obj: Any) -> Bool
{
    type(of: obj) is AnyClass
}

///判断是否是NSObject对象
func g_isObjc(_ obj: AnyObject) -> Bool
{
    type(of: obj) is NSObject.Type
}

///判断一个类是否是NSObject子类
func g_isOC(_ cls: AnyClass) -> Bool
{
    cls is NSObject.Type
}

///判断两个变量是否是同样的类型
func g_isBrother(_ one: Any, _ another: Any) -> Bool
{
    type(of: one) == type(of: another)
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


//MARK: 全局窗口和VC
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

///全局截屏
func g_screenShot() -> UIImage?
{
    ApplicationManager.shared.screenshot()
}

///push控制器
func g_pushVC(_ vc: UIViewController, hideTabBar: Bool = true, animated: Bool = true)
{
    vc.hidesBottomBarWhenPushed = hideTabBar
    ControllerManager.shared.pushController(vc, animated: animated)
}

///present控制器
func g_presentVC(_ vc: UIViewController, mode: UIModalPresentationStyle = .fullScreen, isModal: Bool = false, animated: Bool = true)
{
    vc.modalPresentationStyle = mode
    vc.isModalInPresentation = isModal
    ControllerManager.shared.presentController(vc, animated: animated)
}

//MARK: 字符串和对象有效性判断
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

//MARK: 异步操作
///在线程中异步执行代码
func g_async(onMain: Bool = true, action: @escaping VoClo)
{
    ThreadManager.shared.async(onMain: onMain, action: action)
}

///在后台线程中执行任务并在当前线程中返回，不一定是主线程
func g_async(action: @escaping ((_ queue: DispatchQueue) -> Void))
{
    ThreadManager.shared.async(onMain: false, action: action)
}

///延时操作
func g_after(_ interval: TimeInterval, onMain: Bool? = nil, action: @escaping VoClo)
{
    TimerManager.shared.after(interval: interval, onMain: onMain, action: action)
}
    
//MARK: 随机标志符
///生成一个随机字符串
func g_uuid() -> String
{
    EncryptManager.shared.uuidString()
}

///用于生成一类带时间和uuid的特定字符串，通常用来唯一标记一个key
///形如："2022/02/02 11:11:11<=>skldffjslwfw9323rwjfxzskldf3fjww293jf<=>http://www.baidu.com/search=123"
func g_identifier(_ id: String) -> String
{
    currentTimeString() + String.sSeprator + g_uuid() + String.sSeprator + id
}
    
///获取设备id，在app安装周期内保持不变
func g_deviceId() -> String
{
    ApplicationManager.shared.getDeviceId()
}

//MARK: 加密和解密
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

//AMRK: 全局信息获取
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

//MARK: 全局提示，toast和alert，加载动画
///全局弹框
func g_alert(title: String? = nil,
             message: String? = nil,
             messageAlign: NSTextAlignment = .center,
             needInput: Bool = false,
             inputPlaceHolder: String? = nil,
             usePlaceHolder: Bool = false,
             leftTitle: String? = String.cancel,
             leftBlock: VoClo? = nil,
             rightTitle: String? = String.confirm,
             rightBlock: OpStrClo? = nil)
{
    AlertManager.shared.wantPresentAlert(title: title, message: message, messageAlign: messageAlign, needInput: needInput, inputPlaceHolder: inputPlaceHolder, usePlaceHolder: usePlaceHolder, leftTitle: leftTitle, leftBlock: leftBlock, rightTitle: rightTitle) { text in
        if let rightBlock = rightBlock {
            rightBlock(text)
        }
    }
}

///全局文本toast提示
///interaction:是否能操作后面的UI
func g_toast(text: String, hideDelay: TimeInterval = 2.5, interaction: Bool = false, completion: ToastManager.CompletionCallback? = nil)
{
    ToastManager.shared.hideHUD()
    ToastManager.shared.interaction = interaction
    ToastManager.shared.wantShowText(text: text, hideDelay: hideDelay, completion: completion)
}

///全局加载提示
///interaction:是否能操作后面的UI
func g_loading(_ interaction: Bool = false)
{
    ToastManager.shared.hideHUD()
    ToastManager.shared.interaction = interaction
    ToastManager.shared.wantShowAnimate()
}

///全局停止加载提示
func g_endLoading()
{
    ToastManager.shared.hideHUD()
}

//MARK: 沙盒目录操作
///沙盒Documents目录，参数可追加子目录
func g_documentsDir(subDir: String? = nil) -> NSString
{
    var dir = SandBoxAccessor.shared.getDocumentDir()
    if let subDir = subDir {
        dir = dir.appendingPathComponent(subDir) as NSString
    }
    return dir
}
