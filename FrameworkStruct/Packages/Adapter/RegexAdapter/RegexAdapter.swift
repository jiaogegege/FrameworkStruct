//
//  RegexAdapter.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/11/7.
//

/**
 正则表达式适配器
 */
import UIKit

class RegexAdapter: OriginAdapter, SingletonProtocol
{
    typealias Singleton = RegexAdapter
    
    //MARK: 属性
    //单例
    static let shared = RegexAdapter()
    
    
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


extension RegexAdapter: ExternalInterface
{
    ///从一个字符串中提取字符，如果报错返回空数组
    ///参数：str：源字符串；regex：正则表达式；once：是否只提取第一个，false为提取所有匹配的字符串；options：匹配选项
    func getSubStrIn(_ str: String, with regex: RegExp, once: Bool = true, options: NSRegularExpression.Options = []) -> [String]
    {
        var subStrs = [String]()
        do {
            let regexExp = try NSRegularExpression(pattern: regex, options: options)
            if once //提取第一个
            {
                if let ret = regexExp.firstMatch(in: str, range: NSRange(location: 0, length: str.count))
                {
                    let subStr = regexExp.replacementString(for: ret, in: str, offset: 0, template: "$0")
                    subStrs.append(subStr)
                }
            }
            else    //提取所有
            {
                let rets = regexExp.matches(in: str, range: NSRange(location: 0, length: str.count))
                for ret in rets
                {
                    let subStr = regexExp.replacementString(for: ret, in: str, offset: 0, template: "$0")
                    subStrs.append(subStr)
                }
            }
            return subStrs
        } catch {
            FSLog("regex error: \(error.localizedDescription)")
            return subStrs
        }
    }
    
}
