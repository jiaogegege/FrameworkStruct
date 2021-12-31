//
//  ToastManager.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2021/12/19.
//

/**
 * toast管理器
 * 使用SVProgressHUD、MBProgressHUD或其他Toast组件
 * 默认，同时只能显示一个HUD，当一个HUD消失之后再显示另一个HUD，如果同时有多个HUD要显示，那么剩余的HUD放入队列中，直到前一个HUD消失
 */
import UIKit

class ToastManager: OriginManager
{
    //MARK: 属性
    //单例对象
    static let shared = ToastManager()
    
    //hud显示队列
    //存储hud，对hud进行统一管理，所有hud先进入这个队列，然后按顺序显示，当显示完一个之后，再显示另一个，直到队列被清空
    //实际存储的是操作闭包，当一个闭包执行时显示HUD，当HUD消失后，执行下一个闭包
    fileprivate let hudQueue: FSQueue<(() -> Void)> = FSQueue()
    
    //HUD类型，目前支持`SVProgressHUD、MBProgressHUD`
    fileprivate var hudType: TMHudType = .mbHud
    
    //MARK: 方法
    //私有化init方法
    private override init()
    {
        super.init()
    }
    
    //重写复制方法
    override func copy() -> Any
    {
        return self
    }
        
    //重写复制方法
    override func mutableCopy() -> Any
    {
        return self
    }
    
    //析构方法
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

//内部类型
extension ToastManager
{
    //使用HUD的类型
    enum TMHudType
    {
        case mbHud  //MBProgressHUD，默认
        case svHud  //SVProgressHUD
    }
    
    //显示方式，并行或者串行
    //如果不明确指定显示方式，那么使用串行，如果设置并行，只在那一次设置的时候有效
    enum TMShowMode
    {
        case serial //串行，同时只能显示一个hud，默认方式，并且推荐使用该方式
        case concurrent //并行，同时可显示多个hud，不推荐，多个hud同时显示会造成混乱和不可预见的情况
    }
    
}
//[SVProgressHUD setErrorImage:[UIImage imageNamed:@""]];
//[SVProgressHUD setSuccessImage:[UIImage imageNamed:@""]];
//[SVProgressHUD setMinimumDismissTimeInterval:1.5f];
//[SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
//[SVProgressHUD setForegroundColor:[[UIColor whiteColor] colorWithAlphaComponent:.8f]]; //字体颜色
//[SVProgressHUD setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:.8f]];   //背景颜色

//HUD通知方法
extension ToastManager
{
    
}

//外部接口方法
extension ToastManager
{
    //显示一个hud，会生成一个闭包放到队列中，然后按顺序显示
    func wantShowHud()
    {
        let closure = {[weak self]() in
            
        }
    }
    
}
