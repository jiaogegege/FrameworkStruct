//
//  StringEmbellisher.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/11/5.
//

/**
 * 字符串修饰器
 * 1. 处理各种字符串格式转换
 */
import UIKit

class StringEmbellisher: OriginEmbellisher
{
    //MARK: 属性
    //单例
    static let shared = StringEmbellisher()
    
    
    //MARK: 方法
    //私有化初始化方法
    private override init()
    {
        super.init()
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
extension StringEmbellisher: ExternalInterface
{
    ///将一个字符串的一定范围内的字符以某个字符替换
    ///参数：
    ///originStr：原始字符串
    ///start：开始位置；
    ///length：长度；
    ///replaceChar：用于替换的字符；
    ///replaceCount：替换的字符重复次数，负数表示和length相同，0表示不填充，相当于删除，大于0表示填充的数量；
    ///compact：是否紧凑，如果传false，那么将在被替换的字符头尾加一个空格
    func changeStringWithChar(_ originStr: String, start: Int, length: Int, replaceChar: Character, replaceCount: Int = -1, compact: Bool = true) -> String
    {
        //计算填充用的字符
        var replaceStr: String = ""
        if replaceCount < 0 //负数取length
        {
            for _ in 0..<length
            {
                replaceStr.append(replaceChar)
            }
            if compact == false //非紧凑模式，头尾加空格
            {
                replaceStr = " " + replaceStr + " "
            }
        }
        else if replaceCount > 0    //正数取replaceCount
        {
            for _ in 0..<replaceCount
            {
                replaceStr.append(replaceChar)
            }
            if compact == false //非紧凑模式，头尾加空格
            {
                replaceStr = " " + replaceStr + " "
            }
        }
        //替换字符串
        let newStr = originStr.replaceStringWithRange(location: start, length: length, newString: replaceStr)
        return newStr
    }
    
    ///将手机号中间几位替换为`*`
    func changePhoneWithStar(_ originStr: String, start: Int = 3, length: Int = 4, replaceChar: Character = "*", withBlank: Bool = false) -> String
    {
        self.changeStringWithChar(originStr, start: start, length: length, replaceChar: replaceChar, replaceCount: -1, compact: !withBlank)
    }
    
    ///在手机号中间4位数字前后加一个空格
    ///参数：
    ///start：插入空格的第一个位置
    ///length：中间字符的长度
    ///count：插入空格的数量
    func phoneAddSpace(_ originStr: String, start: Int = 3, length: Int = 4, count: UInt = 1) -> String?
    {
        //先判断是否手机号
        let ret = DatasChecker.shared.checkPhoneNum(originStr)
        if ret
        {
            var newStr: String = ""
            var spaceStr: String = ""   //要插入的空格字符串
            for _ in 0..<count
            {
                spaceStr.append(" ")    //计算空格数量
            }
            newStr.append(originStr.subStringTo(index: start))
            newStr.append(originStr)
            newStr.append(originStr.subStringWithRange(location: start, length: length))
            newStr.append(originStr)
            newStr.append(originStr.subStringFrom(index: start + length))
            return newStr
        }
        return nil
    }
    
    ///返回一个富文本，可以设置以下属性：颜色/字体/行距/段落对齐/...
    func attrStringWith(_ str: String,
                        font: UIFont,
                        color: UIColor? = nil,
                        bgColor: UIColor? = nil,
                        underlineStyle: NSNumber = 0,
                        underlineColor: UIColor? = nil,
                        strokeColor: UIColor? = nil,
                        strokeWidth: NSNumber = 0,
                        lineSpace: CGFloat? = nil,
                        parahSpace: CGFloat? = nil,
                        align: NSTextAlignment = .left,
                        firstLineHeadIndent: CGFloat? = nil,
                        headIndent: CGFloat? = nil,
                        tailIndent: CGFloat? = nil,
                        minLineHeight: CGFloat? = nil,
                        maxLineHeight: CGFloat? = nil,
                        link: NSURL? = nil,
                        lineBreakMode: NSLineBreakMode? = nil) -> NSAttributedString
    {
        //段落属性
        let parah = NSMutableParagraphStyle()
        parah.alignment = align
        if let ls = lineSpace
        {
            parah.lineSpacing = ls
        }
        if let ps = parahSpace
        {
            parah.paragraphSpacing = ps
        }
        if let fi = firstLineHeadIndent
        {
            parah.firstLineHeadIndent = fi
        }
        if let hi = headIndent
        {
            parah.headIndent = hi
        }
        if let ti = tailIndent
        {
            parah.tailIndent = ti
        }
        if let minl = minLineHeight
        {
            parah.minimumLineHeight = minl
        }
        if let maxl = maxLineHeight
        {
            parah.maximumLineHeight = maxl
        }
        if let lb = lineBreakMode
        {
            parah.lineBreakMode = lb
        }
        
        var attrs = [NSAttributedString.Key.paragraphStyle: parah,
                     NSAttributedString.Key.font: font,
                     NSAttributedString.Key.underlineStyle: underlineStyle,
                     NSAttributedString.Key.strokeWidth: strokeWidth]
        if let color = color
        {
            attrs[NSAttributedString.Key.foregroundColor] = color
        }
        if let bg = bgColor
        {
            attrs[NSAttributedString.Key.backgroundColor] = bg
        }
        if let sc = strokeColor
        {
            attrs[NSAttributedString.Key.strokeColor] = sc
        }
        if let uc = underlineColor
        {
            attrs[NSAttributedString.Key.underlineColor] = uc
        }
        if let url = link
        {
            attrs[NSAttributedString.Key.link] = url
        }
        
        let attrStr = NSAttributedString.init(string: str, attributes: attrs)
        return attrStr
    }
    
    ///从一个字符串中获取第一个浮点数
    func floatFromString(_ str: String) -> Float?
    {
        let scan = Scanner(string: str)
        //这一步是要把扫描器的游标放到第一个数字的位置，不然scanFloat会返回nil
        guard scan.scanUpToCharacters(from: .decimalDigits) != nil else {
            return nil
        }
        let num = scan.scanFloat()
        return num
    }
    
    ///从一个字符串中获取第一个整数
    func intFromString(_ str: String) -> Int?
    {
        let scan = Scanner(string: str)
        //这一步是要把扫描器的游标放到第一个数字的位置，不然scanFloat会返回nil
        guard scan.scanUpToCharacters(from: .decimalDigits) != nil else {
            return nil
        }
        let num = scan.scanInt()
        return num
    }
    
    ///从一个字符串获取一组整数，如果有多个的话
    func intsFromString(_ str: String) -> [Int]
    {
        let scan = Scanner(string: str)
        var array = [Int]()
        while scan.scanUpToCharacters(from: .decimalDigits) != nil {
            if let num = scan.scanInt()
            {
                array.append(num)
            }
        }
        return array
    }
    
    ///组合多个属性字符串，可以设置字体/颜色/行距/段落间距，行距默认可设置为4
    func combineAttrStrings(strs: [String],
                            attrs: [(UIFont, UIColor)],
                            lineSpace: CGFloat = 4.0,
                            parahSpace: CGFloat = 4.0) -> NSAttributedString
    {
        let attrStr = NSMutableAttributedString()
        for (index, str) in strs.enumerated()
        {
            let attr = attrs[index]
            let parah = NSMutableParagraphStyle()
            parah.lineSpacing = lineSpace
            parah.paragraphSpacing = parahSpace
            let attrS = NSAttributedString(string: str, attributes: [NSAttributedString.Key.font: attr.0, NSAttributedString.Key.foregroundColor: attr.1, NSAttributedString.Key.paragraphStyle: parah])
            attrStr.append(attrS)
        }
        return attrStr
    }
    
    ///将阿拉伯数字转换为中文数字，如果转换失败，返回nil
    func arabNumToChineseNum(_ num: NSNumber) -> String?
    {
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        let chineseCharacters = formatter.string(from: num)
        return chineseCharacters
    }

    
    
}
