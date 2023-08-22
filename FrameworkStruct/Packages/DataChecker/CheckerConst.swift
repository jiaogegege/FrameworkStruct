//
//  CheckerConst.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/3/10.
//

/**
 * 数据校验器的一些常量定义
 */
import Foundation

//MARK: 正则表达式
//判断用户名的正则表达式，2-10位汉字+字母
let userNameRegex: RegexExpression = "^[a-zA-Z\\u4E00-\\u9FA5]{2,10}$"

//国内手机号的正则表达式，以`1`开头的11位数字
let cellPhoneRegex: RegexExpression = "^1\\d{10}$"

//邮件地址
let mailRegex: RegexExpression = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,6}$"

//一种密码的正则，8-12位大小写字母、数字、@#_
let passwordRegex: RegexExpression = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[#@_])[0-9a-zA-Z#@_]{8,12}$"

//整数的字符串，至少一个数字
let integerRegex: RegexExpression = "^\\d+$"

//浮点数的字符串，小数点前有0个或多个数字，小数点后有1个或多个数字
let floatRegex: RegexExpression = "^\\d*\\.\\d+$"
