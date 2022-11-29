//
//  UrlSchemeConst.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/4/1.
//

/**
 * url scheme常量定义
 * 其它app调用该app的url形式：fst://functionality/subFunctionality?key1=value1&key2=value2&key3=value3
 */
import Foundation

//url参数起始符
let urlParamStartChar = "?"
//url参数分隔符
let urlParamSeparateChar = "&"
//url参数连接符
let urlParamJoinChar = "="

//url scheme结构
struct UrlSchemeStructure
{
    var urlString: String                                           //完整url
    var `protocol`: UrlSchemeProtocol                               //协议
    var functionality: UrlSchemeFunctionalityList                   //主功能
    var subFunctionality: UrlSchemeSubFunctionalityList             //子功能
    var params: Dictionary<UrlSchemeParamKey, String>               //参数列表
    
    init(urlString: String, protocoll: String?, host: String?, path: String?, query: String?)
    {
        self.urlString = urlString
        if let protocoll = protocoll {
            self.protocol = UrlSchemeProtocol(rawValue: protocoll) ?? UrlSchemeProtocol.none
        }
        else
        {
            self.protocol = UrlSchemeProtocol.none
        }
        if let host = host {
            self.functionality = UrlSchemeFunctionalityList(rawValue: host) ?? UrlSchemeFunctionalityList.none
        }
        else
        {
            self.functionality = UrlSchemeFunctionalityList.none
        }
        if let path = path {
            let pathStr = path.replacingOccurrences(of: "/", with: "")
            self.subFunctionality = UrlSchemeSubFunctionalityList(rawValue: pathStr) ?? UrlSchemeSubFunctionalityList.none
        }
        else
        {
            self.subFunctionality = UrlSchemeSubFunctionalityList.none
        }
        //处理参数
        self.params = [:]
        if let query = query {
            let paramArray: [String] = query.components(separatedBy: urlParamSeparateChar)
            //遍历参数字符串列表，提取key/value
            for paramStr in paramArray
            {
                let arr = paramStr.components(separatedBy: urlParamJoinChar)
                if arr.count >= 2
                {
                    self.params[UrlSchemeParamKey.getKey(arr[0])] = arr[1]
                }
            }
        }
    }
    
    init(_ url: URL)
    {
        self.init(urlString: url.absoluteString, protocoll: url.scheme, host: url.host, path: url.path, query: url.query)
    }
    
    //执行动作
    func performFunc()
    {
        self.functionality.performFunc(params: self.params)
    }
}

//url协议，目前只有一种
enum UrlSchemeProtocol: String, CaseIterable
{
    case none = ""              //如果没有协议，那么为空
    case fst                    //在info.plist中定义的url协议
    
    //判断某个URL的协议是否是此处定义的协议
    static func isLegalUrl(_ url: URL) -> Bool
    {
        var ret: Bool = false
        for item in Self.allCases
        {
            if item.rawValue == url.scheme
            {
                ret = true
                break
            }
        }
        return ret
    }
}

//主功能列表，根据实际需求定义
enum UrlSchemeFunctionalityList: String
{
    case none = ""                  //打开app，最基础功能，协议后什么都不跟
    
    case selectTheme                //选择主题
    case goMine                     //进入我的模块
    
    //执行指定的功能，主要是打开或进入某个功能模块
    func performFunc(params: Dictionary<UrlSchemeParamKey, String>)
    {
        switch self {
        case .none:
            break
        case .selectTheme:
            let vc = ThemeSelectViewController.getViewController()
            if let nav = ControllerManager.shared.currentNavVC
            {
                nav.pushViewController(vc, animated: true)
            }
        case .goMine:
            ControllerManager.shared.tabbarVC?.selectedIndex = 1
        }
    }
}

//子功能列表，根据主功能列表分段列出，主要是打开或进入某个子功能模块
//子功能暂时未实现，也不建议使用，统一使用主功能进行划分
enum UrlSchemeSubFunctionalityList: String
{
    case none = ""                      //未指定子功能
}

//参数key，所有参数的key都定义在此处
enum UrlSchemeParamKey: String
{
    case none = ""                  //没有参数
    
    //从字符串创建枚举key类型
    static func getKey(_ str: String) -> UrlSchemeParamKey
    {
        UrlSchemeParamKey(rawValue: str) ?? .none
    }
}
