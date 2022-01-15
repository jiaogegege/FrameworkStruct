//
//  ImageConst.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/12/6.
//

/**
 * 定义各种资源图片
 */
import Foundation

extension UIImage
{
    //MARK: 资源图片常量
    
    /**
     * 常量图片建议以`i`开头，表示`image`，方便区分
     */
    //app图标
    @objc static var iAppIcon:UIImage? = UIImage(named: "AppIcon")
    //cell向右箭头
    @objc static var iRightArrow: UIImage? = UIImage(named: "right_arrow")
    //返回按钮图片
    @objc static var iBackDark: UIImage? = UIImage(named: "common_back_dark")
    @objc static var iBackLight: UIImage? = UIImage(named: "common_back_light")
    @objc static var iBackClose: UIImage? = UIImage(named: "common_back_close")
    //青少年模式弹窗头图
    @objc static var iTeenagerProtect = UIImage(named: "teenager_protect")
    
    
    //对于某些全屏的图片有iPhone8和iPhoneX的尺寸区别，对于iPhoneX的图片，添加后缀`_bang`
    static func bangImage(name: String) -> UIImage?
    {
        return UIImage(named: name + String.bangSuffix)
    }
    
}
