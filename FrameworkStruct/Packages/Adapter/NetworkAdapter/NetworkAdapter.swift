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
    fileprivate let request = NetworkRequestManager.shared
    
    
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
    
    ///获取默认参数，根据项目实际需要修改
    fileprivate func defaultParams() -> Dictionary<String, String>
    {
        return [nt_request_macAddress: g_getDeviceId(),
                nt_request_deviceType: "ios",
                nt_request_clientTime: String(format: "%lld", currentTimeInterval() * 1000)]
    }
    
    //组合自定义参数和默认参数
    fileprivate func combineParams(_ customParams: Dictionary<String, Any>) -> Dictionary<String, Any>
    {
        var params = Dictionary<String, Any>()
        params.merge(self.defaultParams()) { current, _ in
            current
        }   //组合默认参数
        params.merge(customParams) { current, _ in
            current
        }   //组合自定义参数
        return params
    }
    
    //如果数据没有解析成功，那么生成错误信息
    fileprivate func parseDataError() -> NSError
    {
        let errCode: HttpStatusCode = .dataParseError
        let userInfo = [NSLocalizedDescriptionKey: errCode.getErrorDesc()]
        let error = NSError(domain: NSCocoaErrorDomain, code: errCode.rawValue, userInfo: userInfo)
        return error
    }

}

//外部接口
extension NetworkAdapter: ExternalInterface
{
    /**************************************** 基本网络功能 Section Begin ***************************************/
    ///当前网络状态
    var currentNetworkStatus: AFNetworkReachabilityStatus {
        return request.networkStatus
    }
    
    ///当前网络是否可用
    var isNetworkOk: Bool {
        return request.networkAvailable
    }
    
    ///当前主机地址
    var currentHost: String {
        return request.hostUrl
    }
    
    /**************************************** 基本网络功能 Section End ***************************************/
    
    /**************************************** 注册登录 Section Begin ***************************************/
    /**
     * 验证码登录
     *
     * 参数：
     * account：手机号；
     * token：易盾返回的token；
     * verificationCode：内测码；
     * verifyCode：验证码
     *
     * 注意事项：
     *
     */
    func loginWithPhoneAndSms(phone: String,
                              token: String,
                              verifyCode: String,
                              verificationCode: String? = nil,
                              success: @escaping ((UserInfoModel) -> Void),
                              failure: @escaping RequestFailureCallback)
    {
        //处理参数
        var param = ["account": phone, "token": token, "verifyCode": verifyCode]
        if let verCode = verificationCode
        {
            param["verificationCode"] = verCode
        }
        request.post(urlPath: url_loginWithPhoneAndSms, params: combineParams(param)) { response in
            //解析数据
            if let userInfo = UserInfoModel.mj_object(withKeyValues: response)
            {
                success(userInfo)
            }
            else    //如果数据没有解析成功，那么执行失败的回调
            {
                failure(self.parseDataError())
            }
        } failure: { error in
            failure(error)
        }

    }
    
    /**************************************** 注册登录 Section End ***************************************/
    
    /**************************************** 首页数据 Section Begin ***************************************/
    ///获取首页模块、活动、banner等数据
    func getHomeData(success: @escaping ((HomeDataModel) -> Void), failure: @escaping RequestFailureCallback)
    {
        request.get(urlPath: url_homeData, exact: false, params: defaultParams(), authorization: nil, timeoutInterval: nt_requestTimeoutInterval, headers: nil, progressCallback: nil) { response in
            //解析数据为对象
            if let homeDataModel = HomeDataModel.mj_object(withKeyValues: response)
            {
                success(homeDataModel)
            }
            else    //如果数据没有解析成功，那么执行失败的回调
            {
                failure(self.parseDataError())
            }
        } failure: { error in
            failure(error)
        }
    }
    
    /**************************************** 首页数据 Section End ***************************************/
    
    

}
