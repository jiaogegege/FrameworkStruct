//
//  DatasChecker.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/3/10.
//

/**
 * 通用数据校验器
 * 提供一些常用的数据校验方法，比如手机号，密码等
 */
import UIKit

class DatasChecker: OriginChecker
{
    //MARK: 属性
    //单例
    static let shared = DatasChecker()
    
    
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
extension DatasChecker: ExternalInterface
{
    ///是否是手机号，以`1`开头的11位数字
    func checkPhoneNum(_ phoneStr: String) -> Bool
    {
        return phoneStr.isMatch(pattern: cellPhoneRegex)
    }
    
    ///校验密码格式，8-12位大小写字母、数字、@#_
    func checkPassword(_ psdStr: String) -> Bool
    {
        return psdStr.isMatch(pattern: passwordRegex)
    }
    
    ///校验用户名，2-10位汉字+字母
    func checkUserName(_ userName: String) -> Bool
    {
        return userName.isMatch(pattern: userNameRegex)
    }
    
    ///判断一个字符串是否整数
    func checkIsInteger(_ str: String) -> Bool
    {
        return str.isMatch(pattern: integerRegex)
    }

    ///判断一个字符串是否是浮点数
    func checkIsFloat(_ str: String) -> Bool
    {
        return str.isMatch(pattern: floatRegex)
    }

    ///判断一个字符串是否是数字，包括整数和浮点数
    func checkIsNumber(_ str: String) -> Bool
    {
        return checkIsInteger(str) || checkIsFloat(str)
    }
    
    ///判断字符串是否是整数
    ///过滤掉所有10进制数字，剩下为空字符串则原字符串都是数字
    func checkIsIntegerString(_ str: String) -> Bool
    {
        let originStr = str.trimmingCharacters(in: CharacterSet.decimalDigits)
        if originStr.count > 0
        {
            return false
        }
        return true
    }

    
    
    
    
}
