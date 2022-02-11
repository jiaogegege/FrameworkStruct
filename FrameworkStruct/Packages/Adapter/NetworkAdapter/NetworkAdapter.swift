//
//  NetworkAdapter.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/2/10.
//

/**
 网络适配器
 此处定义所有的网络接口方法
 */
import UIKit

class NetworkAdapter: OriginAdapter
{
    //MARK: 属性
    //单例
    static let shared = NetworkAdapter()
    
    //请求对象
    fileprivate let request = NetworkRequest.shared
    
    
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
    
    ///获取默认参数
    fileprivate func getDefaultParams() -> Dictionary<String, String>
    {
        return [nt_macAddress: g_getDeviceId(), nt_deviceType: "ios", nt_clientTime: String(format: "%lld", getCurrentTimeInterval() * 1000)]
    }

}

//外部接口
extension NetworkAdapter: ExternalInterface
{
    ///获取首页模块、活动、banner等数据
    func getHomeData(success:@escaping ((HomeDataModel) -> Void), failure: @escaping RequestFailureCallback)
    {
        request.get(urlPath: url_homeData, exact: false, params: getDefaultParams(), authorization: nil, timeoutInterval: nt_requestTimeoutInterval, headers: nil, progressCallback: nil) { response in
            //解析数据为对象
            let homeDataModel = HomeDataModel.mj_object(withKeyValues: response)
            success(homeDataModel!)
        } failure: { error in
            failure(error)
        }

    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
