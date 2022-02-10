//
//  NetworkRequest.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/2/9.
//

/**
 * 网络请求对象
 * 配置基础的网络请求对象，监控网络状态
 */
import UIKit

class NetworkRequest: OriginManager
{
    //MARK: 属性
    //单例
    static let shared = NetworkRequest()
    
    //网络状态监控对象
    fileprivate var networkReachabilityManager: AFNetworkReachabilityManager {
        let mgr = AFNetworkReachabilityManager.shared()
        //设置网络状态变化
        mgr.setReachabilityStatusChange { status in
            self.networkStatus = status
        }
        return mgr
    }
    
    //网络状态
    fileprivate(set) var networkStatus: AFNetworkReachabilityStatus = .unknown
    
    
    //MARK: 方法
    //私有化初始化方法
    private override init()
    {
        super.init()
        self.networkReachabilityManager.startMonitoring()
    }
    
    override func copy() -> Any
    {
        return self
    }
    
    override func mutableCopy() -> Any
    {
        return self
    }
    
    //构造加密参数，只加密value，不加密key
    fileprivate func encryptParamValues(_ params: Dictionary<String, Any>) -> Dictionary<String, Any>
    {
        if nt_needEncryptParam
        {
            var parameters = [String: Any]()
            for key in params.keys
            {
                if !nt_escapeParamKey.contains(key)     //不包含在不加密数组中的key需要加密
                {
                    if let value = params[key]
                    {
                        if value is String
                        {
                            let val = value as! String
                            parameters[key] = NSString.des(val, key:nt_encryptDesKey)
                        }
                        else    //如果value不是字符串，那么格式化成字符串
                        {
                            let val = String(format: "%@", value as! CVarArg)
                            parameters[key] = NSString.des(val, key:nt_encryptDesKey)
                        }
                    }
                }
            }
            return parameters
        }
        else
        {
            return params
        }
    }
    
    //构造加密参数，加密整个参数列表，最终返回一个key为`data`的dict
    fileprivate func encryptParams(_ params: Dictionary<String, Any>) -> Dictionary<String, Any>
    {
        if nt_needEncryptParam
        {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: params, options: .fragmentsAllowed)
                let jsonStr = String.init(data: jsonData, encoding: .utf8)
                let encryptStr = NSString.des(jsonStr, key: nt_encryptDesKey)
                return [nt_dataParamKey: encryptStr as Any]    //返回加密参数
            } catch {
                FSLog("encrypt error: \(error.localizedDescription)")
                return [nt_dataParamKey: params]    //如果加密失败，返回未加密的参数
            }
        }
        else
        {
            return [nt_dataParamKey: params]
        }
    }
    
    ///创建请求对象
    fileprivate func createRequest(timeoutInterval: TimeInterval = nt_requestTimeoutInterval) -> AFHTTPSessionManager
    {
        let requestManager = AFHTTPSessionManager()
        //request
        let requestSerializer = AFJSONRequestSerializer()
        requestSerializer.timeoutInterval = timeoutInterval
        requestSerializer.setValue(nt_requestContentType, forHTTPHeaderField: nt_requestHeaderContentType)
        requestManager.requestSerializer = requestSerializer
        //response
        let responseSerializer = AFJSONResponseSerializer()
        responseSerializer.acceptableContentTypes = nt_acceptableContentType
        requestManager.responseSerializer = responseSerializer
        
        return requestManager
    }

}

//接口方法
extension NetworkRequest: ExternalInterface
{
    ///计算属性，网络是否可用
    var networkAvailable: Bool {
        switch self.networkStatus {
        case .unknown, .notReachable:
            return false
        case .reachableViaWWAN, .reachableViaWiFi:
            return true
        @unknown default:
            return false
        }
    }
    
    ///计算属性，当前网络状态
    var networkState: AFNetworkReachabilityStatus {
        return self.networkStatus
    }
    
    
    
    
    
    
}
