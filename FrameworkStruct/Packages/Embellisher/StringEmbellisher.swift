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
    
}
