//
//  ImageConst.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/12/6.
//

/**
 * 定义各种资源图片
 */
import UIKit

extension UIImage: ConstantPropertyProtocol
{
    //MARK: 资源图片常量
    
    /**
     * 常量图片建议以`i`开头，表示`image`，方便区分
     */
    //app图标
    @objc static let iAppIcon:UIImage? = UIImage(named: "AppIcon")
    
    //tabbar图标
    static var iHomeNormal: UIImage? {
        UIImage(named: "home_normal")
    }
    static var iHomeSelected: UIImage? {
        UIImage(named: "home_selected")
    }
    static var iMineNormal: UIImage? {
        UIImage(named: "mine_normal")
    }
    static var iMineSelected: UIImage? {
        UIImage(named: "mine_selected")
    }
    
    //返回按钮图片
    @objc static var iBackDark: UIImage? {
        UIImage(named: "common_back_dark")
    }
    @objc static var iBackDarkAlways: UIImage? {
        UIImage(named: "common_back_dark_always")
    }
    @objc static var iBackLight: UIImage? {
        UIImage(named: "common_back_light")
    }
    @objc static var iBackClose: UIImage? {
        UIImage(named: "common_back_close")
    }
    
    //cell向右箭头
    @objc static var iRightArrow: UIImage? {
        UIImage(named: "right_arrow")
    }
    
    //系统设置图标
    @objc static var iSysSettingIcon: UIImage? {
        UIImage(named: "sys_setting")
    }
    
    //青少年模式弹窗头图
    @objc static var iTeenagerProtect = UIImage(named: "teenager_protect")
    
    //miku系列图片
    @objc static let iMiku_0 = UIImage(named: "miku_0")
    
    //Guide提示图片
    @objc static let iGuideHand = UIImage(named: "gudie_hand")
    @objc static let iGuideOrderAdd = UIImage(named: "guide_order_add")
    
    
    
    
    //对于某些全屏的图片有iPhone8和iPhoneX的尺寸区别，对于iPhoneX的图片，添加后缀`_bang`
    static func bangImage(name: String) -> UIImage?
    {
        return UIImage(named: name + String.bangSuffix)
    }
    
}
