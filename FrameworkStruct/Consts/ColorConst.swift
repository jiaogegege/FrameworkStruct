//
//  ColorConst.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/11/5.
//

/**
 * 定义各种颜色
 */
import Foundation

extension UIColor
{
    //MARK: 常量颜色值
    
    /**
     * 常量颜色建议以`c`开头，表示`color`，方便区分
     */
    //主题色红色
    @objc static var cMainRed = UIColor.red
    //accentcolor
    @objc static var cAccent = UIColor(named: "AccentColor")
    //黑色333333
    @objc static var cBlack333333 = UIColor.colorFromHex(value: 0x333333)
    
    
    
    
    
    
    
    
    //MARK: 颜色相关方法
    
    //16进制颜色字符串转UIColor
    //colorStr:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
    static func colorWithHex(colorStr: String , alpha: CGFloat = 1) -> UIColor
    {
        //删除字符串中的空格
        var cString = colorStr.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        // String should be 6 or 8 characters
        if (cString.count < 6)
        {
            return UIColor.clear
        }
        // strip 0X if it appears
        //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
        if (cString.hasPrefix("0X"))
        {
            cString = String(cString[cString.index(cString.startIndex, offsetBy: 2)...])
        }
        //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
        if (cString.hasPrefix("#"))
        {
            cString = String(cString[cString.index(cString.startIndex, offsetBy: 1)...])
        }
        if (cString.count != 6)
        {
            return UIColor.clear
        }
        
        // Separate into r, g, b substrings
        //r
        let rString = String(cString[cString.startIndex..<cString.index(cString.startIndex, offsetBy: 2)])
        //g
        let gString = String(cString[cString.index(cString.startIndex, offsetBy: 2)..<cString.index(cString.startIndex, offsetBy: 4)])
        //b
        let bString = String(cString[cString.index(cString.startIndex, offsetBy: 4)..<cString.index(cString.startIndex, offsetBy: 6)])
        
        // Scan values
        var r: UInt64 = 0, g: UInt64 = 0, b: UInt64 = 0
        Scanner(string: rString).scanHexInt64(&r)
        Scanner(string: gString).scanHexInt64(&g)
        Scanner(string: bString).scanHexInt64(&b)
        return UIColor.colorWithRGBA(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: alpha)
    }
    
    //16进制颜色转换成UIColor
    static func colorFromHex(value : Int , alpha : CGFloat = 1) -> UIColor
    {
        let red = CGFloat((value & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((value & 0xFF00) >> 8) / 255.0
        let blue = CGFloat(value & 0xFF) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    //红绿蓝255值转换成UIColor，RGBA都有默认值，默认纯白色
    static func colorWithRGBA(red: CGFloat = 255.0, green: CGFloat = 255.0, blue: CGFloat = 255.0, alpha: CGFloat = 1.0) -> UIColor
    {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }
    
}

