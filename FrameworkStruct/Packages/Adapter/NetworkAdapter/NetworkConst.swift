//
//  NetworkConst.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/2/10.
//

/**
 网络常量和url配置
 变量以`n`开头，表示network
 */
import Foundation

//MARK: 常量
///参数是否加密
let nt_needEncryptParam = false

///不需要加密的参数key，在这个数组中的key不会被加密
let nt_escapeParamKey = ["imgCode"]

///DES加密的密钥
let nt_encryptDesKey = "Aipi3pWCzdo6tA2SL0gp3ajx"

///如果加密整个参数，那么最终返回的参数都放在key为`data`的字典中
let nt_dataParamKey = "data"

///请求超时时间间隔
let nt_requestTimeoutInterval: TimeInterval = 20.0

///可接受的返回数据类型
let nt_acceptableContentType:Set<String> = ["text/html", "application/json", "text/json", "text/javascript", "text/plain"]

///发送数据的类型
let nt_requestContentType = "application/json"

///HTTP Header
let nt_requestHeaderContentType = "Content-Type"

//MARK: URL定义






//MARK: 错误信息定义
enum HttpStatusCode: Int
{
    case unavailable = 0
    case ok = 200
    
    case notFound = 404
    case badRequest = 400
    
    case systemError = 500
    case noService = 501
    case badGetway = 502
    
    ///获取错误信息
    func getErrorDes() -> String
    {
        switch self {
        case .unavailable:
            return String.networkUnavailable
        case .ok:
            return String.networkOk
        case .notFound:
            return String.networkNotFound
        case .badRequest:
            return String.networkBadRequest
        case .systemError:
            return String.networkSystemError
        case .noService:
            return String.networkNoService
        case .badGetway:
            return String.networkBadGetway
        }
    }
}
