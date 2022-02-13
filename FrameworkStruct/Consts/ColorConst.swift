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
    @objc static var cMainThemeColor = ThemeManager.shared.getCurrentTheme().mainColor
    //红色
    @objc static let cRed = UIColor.red
    //0xff709b
    @objc static let cPink_ff709b = UIColor.colorFromHex(value: 0xff709b)
    //accentcolor
    @objc static var cAccent = UIColor(named: "AccentColor")
    //黑色333333
    @objc static let cBlack_3 = UIColor.colorFromHex(value: 0x333333)
    //黑色666666
    @objc static let cBlack_6 = UIColor.colorFromHex(value: 0x666666)
    //黑色999999
    @objc static let cBlack_9 = UIColor.colorFromHex(value: 0x999999)
    //f4f4f4
    @objc static let cGray_f4 = UIColor.colorFromHex(value: 0xf4f4f4)
    //E7E7E7
    @objc static let cGray_E7E7E7 = UIColor.colorFromHex(value: 0xE7E7E7)
    //2C2C3D
    @objc static let cBlack_2C2C3D = UIColor.colorWithHex(colorStr: "2C2C3D")
    //"D6D6D9"
    @objc static var cGray_D6D6D9 = UIColor.colorWithHex(colorStr: "D6D6D9")
    //5B5B7E
    @objc static let cGray_5B5B7E = UIColor.colorFromHex(value: 0x5B5B7E)

    
}
