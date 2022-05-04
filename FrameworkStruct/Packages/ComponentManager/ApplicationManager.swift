//
//  ApplicationManager.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/2/20.
//

/**
 * 应用程序管理器
 * 主要管理应用程序生命周期内的各种状态和事件，监控各种应用级行为和系统行为
 * 包括但不限于`UIApplication`、`AppDelegate`、`UIWindow`、全局属性、全局状态、全局事件和行为等
 */
import UIKit


//应用程序管理器代理方法，根据实际需求设计
protocol ApplicationManagerDelegate: NSObjectProtocol
{
    ///应用程序管理器截屏了
    func applicationManagerDidScreenshot(image: UIImage)
    
}


class ApplicationManager: OriginManager
{
    //MARK: 属性
    //单例
    static let shared = ApplicationManager()
    
    //UserDefaults
    fileprivate lazy var ud: UserDefaultsAccessor = UserDefaultsAccessor.shared
    
    //应用程序对象
    var app: UIApplication {
        UIApplication.shared
    }
    
    //应用程序代理对象
    var appDelegate: AppDelegate {
        AppDelegate.shared()
    }
    
    //scene代理对象
    var sceneDelegate: SceneDelegate? {
        SceneDelegate.shared()
    }
    
    //窗口对象
    var window: UIWindow {
        if let window = appDelegate.window
        {
            return window
        }
        if #available(iOS 13.0, *)
        {
            if let window = sceneDelegate?.currentWindow
            {
                return window
            }
        }
        else
        {
            if let kw = app.keyWindow
            {
                return kw
            }
        }
        if let w = app.windows.first
        {
            return w
        }
        
        return UIWindow()   //永远不应该执行这一步
    }
    
    ///强制设置屏幕是否横屏，默认竖屏
    ///如果需要手动设置屏幕旋转，那么使用这个属性
    var isForceLandscape: Bool = false {
        didSet {
            if isForceLandscape == true
            {
                UIDevice.current.setValue(UIDeviceOrientation.landscapeRight.rawValue, forKey: "orientation")
            }
            else
            {
                UIDevice.current.setValue(UIDeviceOrientation.portrait.rawValue, forKey: "orientation")
            }
        }
    }
    
    ///是否开启截屏监听
    var isListenScreenshot: Bool = false
    
    ///代理对象
    weak var delegate: ApplicationManagerDelegate?
    
    
    //MARK: 方法
    //私有化初始化方法
    private override init()
    {
        super.init()
        //设置初始状态
        stMgr.setStatus(AMAppState.unknown, forKey: AMStatusKey.appState)
        
        self.addNotification()
        //监控电池
        UIDevice.current.isBatteryMonitoringEnabled = true
    }
    
    override func copy() -> Any
    {
        return self
    }
    
    override func mutableCopy() -> Any
    {
        return self
    }
    
    //添加通知
    fileprivate func addNotification()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidFinishLaunchNotification(notification:)), name: UIApplication.didFinishLaunchingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForegroundNotification(notification:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActiveNotification(notification:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActiveNotification(notification:)), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackgroundNotification(notification:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidReceiveMemoryWarningNotification(notification:)), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillTerminateNotification(notification:)), name: UIApplication.willTerminateNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didTakeScreenShotNotification(notification:)), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(capturingDidChangeNotification(notification:)), name: UIScreen.capturedDidChangeNotification, object: nil)
    }
    
}


//代理和通知方法
extension ApplicationManager: DelegateProtocol
{
    /**************************************** UIApplication通知 Section Begin ***************************************/
    //app启动完毕
    @objc func applicationDidFinishLaunchNotification(notification: Notification)
    {
        stMgr.setStatus(AMAppState.launched, forKey: AMStatusKey.appState)
        //写入app启动次数
        let launchTimes = self.launchTimes
        ud.write(key: .runTimes, value: launchTimes + 1)
    }
    
    //app即将进入前台
    @objc func applicationWillEnterForegroundNotification(notification: Notification)
    {
        stMgr.setStatus(AMAppState.foreground, forKey: AMStatusKey.appState)
    }
    
    //app已经获得焦点
    @objc func applicationDidBecomeActiveNotification(notification: Notification)
    {
        stMgr.setStatus(AMAppState.active, forKey: AMStatusKey.appState)
    }
    
    //app即将失去焦点
    @objc func applicationWillResignActiveNotification(notification: Notification)
    {
        stMgr.setStatus(AMAppState.inactive, forKey: AMStatusKey.appState)
    }
    
    //app已经进入后台
    @objc func applicationDidEnterBackgroundNotification(notification: Notification)
    {
        stMgr.setStatus(AMAppState.background, forKey: AMStatusKey.appState)
    }
    
    //app收到内存警告
    @objc func applicationDidReceiveMemoryWarningNotification(notification: Notification)
    {
        stMgr.setStatus(AMAppState.memoryWarning, forKey: AMStatusKey.appState)
    }
    
    //app即将被销毁
    @objc func applicationWillTerminateNotification(notification: Notification)
    {
        stMgr.setStatus(AMAppState.terminate, forKey: AMStatusKey.appState)
    }
    
    /**************************************** UIApplication通知 Section End ***************************************/
    
    //系统截屏通知
    @objc func didTakeScreenShotNotification(notification: Notification)
    {
        //如果在用户使用了系统截屏功能后收到通知，那么可以手动截屏
        if isListenScreenshot
        {
            //确实截到图了才通知外部程序，不然什么都不做
            if let img = self.screenshot()
            {
                //通知代理对象
                delegate?.applicationManagerDidScreenshot(image: img)
                //发送截屏的通知
                NotificationCenter.default.post(name: FSNotification.screenShot.name, object: [FSNotification.screenShot.paramKey: img])
            }
        }
    }
    
    //录屏变化通知
    @objc func capturingDidChangeNotification(notification: Notification)
    {
        
    }
    
}


//内部类型
extension ApplicationManager: InternalType
{
    ///应用程序管理器状态key
    enum AMStatusKey: SMKeyType {
        case appState                       //app状态
        case brightness                     //上一次保存的屏幕亮度，用于在某个界面高亮后退出该界面再调回正常亮度
    }
    
    ///应用程序状态
    enum AMAppState {
        case unknown                        //最初的状态，未知
        case launched                       //刚刚启动
        case foreground                     //在前台
        case active                         //活跃状态
        case inactive                       //不活跃状态
        case background                     //在后台
        case memoryWarning                  //内存警告
        case terminate                      //被销毁
    }
    
}


//接口方法
extension ApplicationManager: ExternalInterface
{
    ///是否安装或者更新后第一次启动app
    var isFirstLaunch: Bool {
        let lastVersion = ud.readString(key: .lastRunVersion)
        let currentVersion = gAppVersion
        //将本次启动版本号写入ud
        ud.write(key: .lastRunVersion, value: currentVersion)
        //判断上一次启动和本次启动的版本号是否一致，如果不一致，说明第一次启动或者更新后第一次启动
        if lastVersion != currentVersion
        {
            return true
        }
        return false
    }
    
    ///app启动次数
    var launchTimes: Int {
        return ud.readInt(key: .runTimes)
    }
    
    ///获取设备id，在app安装周期内保持不变
    func getDeviceId() -> String
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
    
    ///屏幕旋转方向
    var orientation: UIInterfaceOrientation {
        if #available(iOS 13, *)
        {
            if let cur = self.sceneDelegate?.currentWindowScene
            {
                return cur.interfaceOrientation
            }
            else
            {
                return self.app.statusBarOrientation
            }
        }
        else
        {
            return self.app.statusBarOrientation
        }
    }
    
    ///是否竖屏
    var isVertical: Bool {
        return self.orientation == .portrait || self.orientation == .portraitUpsideDown
    }
    
    ///是否横屏
    var isLandscape: Bool {
        return self.orientation == .landscapeLeft || self.orientation == .landscapeRight
    }
    
    ///电池电量：0-1
    var deviceBattery: Float {
        return UIDevice.current.batteryLevel
    }
    
    ///电池状态
    var batteryState: UIDevice.BatteryState {
        return UIDevice.current.batteryState
    }
    
    ///是否在充电
    var isCharging: Bool {
        return UIDevice.current.batteryState == .charging
    }
    
    ///当前屏幕亮度，0-1
    var currentBrightness: CGFloat {
        return UIScreen.main.brightness
    }
    
    ///提供给某个界面单独设置屏幕亮度,0-1
    func setBrightness(_ brightness: CGFloat)
    {
        //先保存一下当前亮度
        stMgr.setStatus(UIScreen.main.brightness, forKey: AMStatusKey.brightness)
        //设置屏幕亮度
        UIScreen.main.brightness = brightness
    }
    
    ///恢复之前的屏幕亮度
    func resetBrightness()
    {
        if let brightness = stMgr.status(forKey: AMStatusKey.brightness) as? CGFloat
        {
            UIScreen.main.brightness = brightness
            //清除状态历史
            stMgr.clear(forKey: AMStatusKey.brightness)
        }
    }
    
    ///是否在录屏，包括：屏幕录制/AirPlay/镜像
    var isCaputring: Bool {
        return UIScreen.main.isCaptured
    }
    
    ///手动截取整个屏幕
    func screenshot() -> UIImage?
    {
        let imageSize: CGSize = .fullScreen
        //绘制图像
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let imgData = image?.pngData()
        if let imgD = imgData
        {
            return UIImage(data: imgD)
        }
        
        return nil
    }
    
    ///跳转到app store评分
    func gotoAppStoreComment()
    {
        UIApplication.shared.open(URL.init(string: gAppStoreCommentUrl)!, options: [:], completionHandler: nil)
    }
    
    
}
