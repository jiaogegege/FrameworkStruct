//
//  ApplicationManager.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/2/20.
//

/**
 * 应用程序管理器
 * 主要管理应用程序生命周期内的各种状态和事件
 * 包括但不限于`UIApplication`、`AppDelegate`、`UIWindow`、全局属性、全局状态等
 */
import UIKit

class ApplicationManager: OriginManager
{
    //MARK: 属性
    //单例
    static let shared = ApplicationManager()
    
    //应用程序对象
    fileprivate(set) weak var app: UIApplication! = UIApplication.shared
    
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
        g_getWindow()
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
    
    
    //MARK: 方法
    //私有化初始化方法
    private override init()
    {
        super.init()
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
    
}


//接口方法
extension ApplicationManager: ExternalInterface
{
    //屏幕旋转方向
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
    
    //是否竖屏
    var isVertical: Bool {
        return self.orientation == .portrait || self.orientation == .portraitUpsideDown
    }
    
    //判断是否横屏
    var isLandscape: Bool {
        return self.orientation == .landscapeLeft || self.orientation == .landscapeRight
    }
    
    //电池电量：0-1
    var deviceBattery: Float {
        return UIDevice.current.batteryLevel
    }
    
    //电池状态
    var batteryState: UIDevice.BatteryState {
        return UIDevice.current.batteryState
    }
    
    //是否在充电
    var isCharging: Bool {
        return UIDevice.current.batteryState == .charging
    }
    
    
    
    
    
    
    
}
