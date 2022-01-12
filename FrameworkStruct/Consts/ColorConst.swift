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

extension UIColor
{
    //MARK: 常量颜色值
    /**
     * 常量颜色建议以`c`开头，表示`color`，方便区分
     */
    //主题色
    @objc static var cThemeColor = ThemeManager.shared.getCurrentTheme().mainColor
    //红色
    @objc static var cRed = UIColor.red
    //accentcolor
    @objc static var cAccent = UIColor(named: "AccentColor")
    //黑色333333
    @objc static var cBlack_3 = UIColor.colorFromHex(value: 0x333333)
    //f4f4f4
    @objc static var cGray_f4 = UIColor.colorFromHex(value: 0xf4f4f4)
    //0xff709b
    @objc static var cPink_ff709b = UIColor.colorFromHex(value: 0xff709b)
    //"D6D6D9"
    @objc static var cGray_D6D6D9 = UIColor.colorWithHex(colorStr: "D6D6D9")
    

    
}
