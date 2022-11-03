//
//  ColorConst.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/11/5.
//

/**
 * 定义各种颜色
 * 颜色转换
 */
import Foundation

extension UIColor: ConstantPropertyProtocol
{
    //MARK: 常量颜色值
    /**
     * 常量颜色建议以`c`开头，表示`color`，方便区分
     */
    //主题色
    @objc static var cMainThemeColor:UIColor {
        return ThemeManager.shared.getCurrentTheme().mainColor
    }
    //红色
    @objc static let cRed = UIColor.red
    //0xff709b
    @objc static let cPink_ff709b = UIColor.colorFromHex(0xff709b)
    //accentcolor
    @objc static var cAccent = UIColor(named: "AccentColor")
    //黑色333333
    @objc static let cBlack_3 = UIColor.colorFromHex(0x333333)
    //黑色444444
    @objc static let cBlack_4 = UIColor.colorFromHex(0x444444)
    //黑色555555
    @objc static let cBlack_5 = UIColor.colorFromHex(0x555555)
    //黑色666666
    @objc static let cBlack_6 = UIColor.colorFromHex(0x666666)
    //黑色999999
    @objc static let cBlack_9 = UIColor.colorFromHex(0x999999)
    //灰色f4f4f4
    @objc static let cGray_f4 = UIColor.colorFromHex(0xf4f4f4)
    //灰色dcdcdc
    @objc static let cGray_dc = UIColor.colorFromHex(0xdcdcdc)
    //E7E7E7
    @objc static let cGray_E7E7E7 = UIColor.colorFromHex(0xE7E7E7)
    //2C2C3D
    @objc static let cBlack_2C2C3D = UIColor.colorWithHex("2C2C3D")
    //"D6D6D9"
    @objc static var cGray_D6D6D9 = UIColor.colorWithHex("D6D6D9")
    //5B5B7E
    @objc static let cGray_5B5B7E = UIColor.colorFromHex(0x5B5B7E)
    //50%半透明黑色
    @objc static let cBlack_50Alpha = UIColor(white: 0, alpha: 0.5)

    
}
