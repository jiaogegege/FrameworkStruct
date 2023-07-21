//
//  NetworkAdapter.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/2/10.
//

/**
 * 网络适配器
 * 此处定义所有的网络接口方法
 * 如果某些模块想要在模块内部编写网络接口方法，那么可以扩展该类，并可以通过实现一个和那个模块关联的空协议来标记该扩展
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

}


//保护方法
extension NetworkAdapter: ProtectAvailable
{
    ///获取默认参数，根据项目实际需要修改
    func defaultParams() -> Dictionary<String, Any>
    {
        [nt_request_macAddress_key: g_deviceId(),
         nt_request_deviceType_key: String.iOS,
         nt_request_clientTime_key: String(format: "%lld", currentTimeInterval() * 1000)]
    }
    
    //组合自定义参数和默认参数
    func combineParams(_ customParams: Dictionary<String, Any>) -> Dictionary<String, Any>
    {
        var params = defaultParams()    //默认参数
        params.merge(customParams) { current, _ in
            current
        }   //组合自定义参数
        return params
    }
    
    //如果数据没有解析成功，那么生成错误信息
    func parseDataError() -> NSError
    {
        HttpStatusCode.dataParseError.getError()
    }

}


//外部接口，可以在其它功能模块中扩展外部接口，比如某些接口调用和特定功能模块具有强关联性
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
        return request.host
    }
    
    /**************************************** 基本网络功能 Section End ***************************************/
    
    /**************************************** 网络请求任务相关 Section Begin ***************************************/
    ///所有请求任务信息
    func allTasks() -> String
    {
        request.allTasks()
    }
    
    ///获取某个请求对象，id就是请求任务时生成的id
    func getTask(_ id: String) -> URLSessionTask?
    {
        request.getTask(id)
    }
    
    ///获取某个任务的运行状态
    func taskState(_ id: String) -> URLSessionTask.State?
    {
        request.taskState(id)
    }
    
    ///取消某个请求任务
    func cancelTask(_ id: String)
    {
        request.cancelTask(id)
    }
    
    ///暂时挂起某个请求任务
    func suspendTask(_ id: String)
    {
        request.suspendTask(id)
    }
    
    ///恢复执行某个任务
    func resumeTask(_ id: String)
    {
        request.resumeTask(id)
    }
    
    /**************************************** 网络请求任务相关 Section End ***************************************/

    //MARK: 网络接口方法
    /**************************************** 注册登录 Section Begin ***************************************/
    /**
     * 验证码登录
     *
     * 参数：
     * account：手机号；
     * token：一个token，可以通过网易易盾获取或者本地生成；
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
                              success: @escaping GnClo<UserInfoModel>,
                              failure: @escaping RequestFailureCallback)
    {
        //处理参数
        var param = ["account": phone, "token": token, "verifyCode": verifyCode]
        if let verCode = verificationCode
        {
            param["verificationCode"] = verCode
        }
        _ = request.post(urlPath: url_loginWithPhoneAndSms, params: combineParams(param)) { response in
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
    func getHomeData(success: @escaping GnClo<HomeDataModel>, failure: @escaping RequestFailureCallback) -> String
    {
        return request.get(urlPath: url_homeData, exact: false, params: defaultParams(), authorization: nil, timeoutInterval: nt_request_timeoutInterval, headers: nil, progressCallback: nil) { response in
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
