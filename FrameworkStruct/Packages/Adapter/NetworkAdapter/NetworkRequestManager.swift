//
//  NetworkRequestManager.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/2/9.
//

/**
 * 网络请求对象管理器
 * 配置基础的网络请求对象，监控网络状态
 */
import UIKit

class NetworkRequestManager: OriginManager
{
    //MARK: 属性
    //单例
    static let shared = NetworkRequestManager()
    
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
                if !nt_escapeParam_Key.contains(key)     //不包含在不加密数组中的key需要加密
                {
                    if let value = params[key]
                    {
                        if value is String
                        {
                            let val = value as! String
                            parameters[key] = g_des(val, key:nt_encryptDes_Key)
                        }
                        else    //如果value不是字符串，那么格式化成字符串
                        {
                            let val = String(format: "%@", value as! CVarArg)
                            parameters[key] = g_des(val, key:nt_encryptDes_Key)
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
    
    //构造加密参数，加密整个参数列表，最终返回一个key为`data`的dict，如果不加密或者加密失败返回原始参数列表
    fileprivate func encryptParams(_ params: Dictionary<String, Any>) -> Dictionary<String, Any>
    {
        if nt_needEncryptParam
        {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: params, options: .fragmentsAllowed)
                let jsonStr = String.init(data: jsonData, encoding: .utf8)
                let encryptStr = g_des(jsonStr!, key: nt_encryptDes_Key)
                return [nt_paramData_Key: encryptStr as Any]    //返回加密参数
            } catch {
                FSLog("encrypt error: \(error.localizedDescription)")
                return params    //如果加密失败，返回原始参数
            }
        }
        else
        {
            return params
        }
    }
    
    ///解密返回数据，解密整个参数列表，最终返回一个dict
    fileprivate func decryptParams(_ responseObject: Any) -> Dictionary<String, Any>
    {
        if nt_needEncryptParam  //如果要解密
        {
            if let res = responseObject as? Data
            {
                do {
                    let resStr = String.init(data: res, encoding: .utf8)
                    let decryptStr = g_desDecrypt(resStr, key: nt_encryptDes_Key)
                    let decryptData = decryptStr?.data(using: .utf8)
                    let resDict = try JSONSerialization.jsonObject(with: decryptData!, options: .mutableLeaves)
                    return resDict as! Dictionary<String, Any>
                } catch {
                    FSLog("decrypt error: \(error.localizedDescription)")
                    return [:]  //如果解密失败返回空字典
                }
            }
        }
        //如果不是Data，就是Dictionary
        return responseObject as! Dictionary<String, Any>
    }
    
    ///创建请求对象
    ///timeoutInterval：请求超时时间
    fileprivate func createRequest(timeoutInterval: TimeInterval, requestHeaders: Dictionary<String, String>? = nil) -> AFHTTPSessionManager
    {
        let requestManager = AFHTTPSessionManager()
        //request
        let requestSerializer = AFJSONRequestSerializer()
        requestSerializer.timeoutInterval = timeoutInterval
        //设置默认请求头
        for (key, value) in self.getDefaultRequestHeaders()
        {
            requestSerializer.setValue(value, forHTTPHeaderField: key)
        }
        //设置自定义请求头
        if let headers = requestHeaders
        {
            for (key, value) in headers
            {
                requestSerializer.setValue(value, forHTTPHeaderField: key)
            }
        }
        requestManager.requestSerializer = requestSerializer
        //response
        //如果参数加密了，那么返回的是二进制数据；用HTTP解析，如果不加密返回的是字典，用JSON解析
        let responseSerializer = nt_needEncryptParam ? AFHTTPResponseSerializer() : AFJSONResponseSerializer()
        responseSerializer.acceptableContentTypes = nt_acceptableContentType
        requestManager.responseSerializer = responseSerializer
        
        return requestManager
    }

    ///获取默认请求头，每个请求都会有，根据实际需要修改
    fileprivate func getDefaultRequestHeaders() -> Dictionary<String, String>
    {
        return [:]
    }

}


//接口方法
extension NetworkRequestManager: ExternalInterface
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

    ///当前host地址
    var hostUrl: String {
        return nt_serverHost.getHost()
    }
    
    ///创建一个get请求
    ///参数：
    ///urlPath：接口地址，不包含host
    ///exact:`urlPath`是否是完整的url，如果是true，那么不需要组合host地址，一般是false；主要用来测试一些完整的url
    ///params：接口参数
    ///authorization:验证，比如用户token，需要验证用户身份的接口要传这个参数
    ///timeoutInterval：超时时间
    ///headers：自定义请求头，根据不同接口可能会不同，大部分为nil
    ///progressCallback:下载数据进度
    func get(urlPath: String,
             exact: Bool = false,
             params: Dictionary<String, Any>? = nil,
             authorization: String? = nil,
             timeoutInterval: TimeInterval = nt_requestTimeoutInterval,
             headers: Dictionary<String, String>? = nil,
             progressCallback: ((_ progress: Float) -> Void)? = nil,
             success: @escaping RequestSuccessCallback,
             failure: @escaping RequestFailureCallback)
    {
        _ = self.dataTask(httpMethod: .GET, urlPath: urlPath, exact: exact, params: params, authorization: authorization, timeoutInterval: timeoutInterval, headers: headers, uploadProgressCallback: nil, downloadProgressCallback: progressCallback, success: success, failure: failure)
    }
    
    ///创建一个post请求
    ///参数：
    ///urlPath：接口地址，不包含host
    ///exact:`urlPath`是否是完整的url，如果是true，那么不需要组合host地址，一般是false；主要用来测试一些完整的url
    ///params：接口参数
    ///authorization:验证，比如用户token，需要验证用户身份的接口要传这个参数
    ///timeoutInterval：超时时间
    ///headers：自定义请求头，根据不同接口可能会不同，大部分为nil
    ///progressCallback:上传数据进度
    func post(urlPath: String,
              exact: Bool = false,
              params: Dictionary<String, Any>? = nil,
              authorization: String? = nil,
              timeoutInterval: TimeInterval = nt_requestTimeoutInterval,
              headers: Dictionary<String, String>? = nil,
              progressCallback: ((_ progress: Float) -> Void)? = nil,
              success: @escaping RequestSuccessCallback,
              failure: @escaping RequestFailureCallback)
    {
        _ = self.dataTask(httpMethod: .POST, urlPath: urlPath, exact: exact, params: params, authorization: authorization, timeoutInterval: timeoutInterval, headers: headers, uploadProgressCallback: progressCallback, downloadProgressCallback: nil, success: success, failure: failure)
    }
    
    ///创建一个put请求
    ///参数：
    ///urlPath：接口地址，不包含host
    ///exact:`urlPath`是否是完整的url，如果是true，那么不需要组合host地址，一般是false；主要用来测试一些完整的url
    ///params：接口参数
    ///authorization:验证，比如用户token，需要验证用户身份的接口要传这个参数
    ///timeoutInterval：超时时间
    ///headers：自定义请求头，根据不同接口可能会不同，大部分为nil
    func put(urlPath: String,
             exact: Bool = false,
             params: Dictionary<String, Any>? = nil,
             authorization: String? = nil,
             timeoutInterval: TimeInterval = nt_requestTimeoutInterval,
             headers: Dictionary<String, String>? = nil,
             success: @escaping RequestSuccessCallback,
             failure: @escaping RequestFailureCallback)
    {
        _ = self.dataTask(httpMethod: .PUT, urlPath: urlPath, exact: exact, params: params, authorization: authorization, timeoutInterval: timeoutInterval, headers: headers, uploadProgressCallback: nil, downloadProgressCallback: nil, success: success, failure: failure)
    }
    
    ///创建一个delete请求
    ///参数：
    ///urlPath：接口地址，不包含host
    ///exact:`urlPath`是否是完整的url，如果是true，那么不需要组合host地址，一般是false；主要用来测试一些完整的url
    ///params：接口参数
    ///authorization:验证，比如用户token，需要验证用户身份的接口要传这个参数
    ///timeoutInterval：超时时间
    ///headers：自定义请求头，根据不同接口可能会不同，大部分为nil
    func delete(urlPath: String,
                exact: Bool = false,
                params: Dictionary<String, Any>? = nil,
                authorization: String? = nil,
                timeoutInterval: TimeInterval = nt_requestTimeoutInterval,
                headers: Dictionary<String, String>? = nil,
                success: @escaping RequestSuccessCallback,
                failure: @escaping RequestFailureCallback)
    {
        _ = self.dataTask(httpMethod: .DELETE, urlPath: urlPath, exact: exact, params: params, authorization: authorization, timeoutInterval: timeoutInterval, headers: headers, uploadProgressCallback: nil, downloadProgressCallback: nil, success: success, failure: failure)
    }
    
    ///创建一个patch请求
    ///参数：
    ///urlPath：接口地址，不包含host
    ///exact:`urlPath`是否是完整的url，如果是true，那么不需要组合host地址，一般是false；主要用来测试一些完整的url
    ///params：接口参数
    ///authorization:验证，比如用户token，需要验证用户身份的接口要传这个参数
    ///timeoutInterval：超时时间
    ///headers：自定义请求头，根据不同接口可能会不同，大部分为nil
    ///progressCallback:上传数据进度
    func patch(urlPath: String,
               exact: Bool = false,
               params: Dictionary<String, Any>? = nil,
               authorization: String? = nil,
               timeoutInterval: TimeInterval = nt_requestTimeoutInterval,
               headers: Dictionary<String, String>? = nil,
               success: @escaping RequestSuccessCallback,
               failure: @escaping RequestFailureCallback)
    {
        _ = self.dataTask(httpMethod: .PATCH, urlPath: urlPath, exact: exact, params: params, authorization: authorization, timeoutInterval: timeoutInterval, headers: headers, uploadProgressCallback: nil, downloadProgressCallback: nil, success: success, failure: failure)
    }
    
    ///创建一个数据请求
    ///参数：
    ///urlPath：接口地址，不包含host
    ///exact:`urlPath`是否是完整的url，如果是true，那么不需要组合host地址，一般是false；主要用来测试一些完整的url
    ///params：接口参数
    ///authorization:验证，比如用户token，需要验证用户身份的接口要传这个参数
    ///timeoutInterval：超时时间
    ///headers：自定义请求头，根据不同接口可能会不同，大部分为nil
    ///downloadProgressCallback:下载数据进度
    ///uploadProgressCallback:上传数据进度
    func dataTask(httpMethod: HttpMethodType,
                  urlPath: String,
                  exact: Bool = false,
                  params: Dictionary<String, Any>? = nil,
                  authorization: String? = nil,
                  timeoutInterval: TimeInterval = nt_requestTimeoutInterval,
                  headers: Dictionary<String, String>? = nil,
                  uploadProgressCallback: ((_ progress: Float) -> Void)? = nil,
                  downloadProgressCallback: ((_ progress: Float) -> Void)? = nil,
                  success: @escaping RequestSuccessCallback,
                  failure: @escaping RequestFailureCallback) -> URLSessionDataTask?
    {
        //处理token和header
        var customHeaders = Dictionary<String, String>()
        if let auth = authorization {
            customHeaders[HttpRequestHeaderKey.Authorization.rawValue] = auth
        }
        if let hds = headers {
            customHeaders.merge(hds) { current, _ in
                current
            }
        }
        //创建请求对象
        let manager = self.createRequest(timeoutInterval: timeoutInterval, requestHeaders: customHeaders)
        //加密参数
        var desParams = params  // 可能为nil
        if let pas = params
        {
            desParams = self.encryptParamValues(pas)
        }
        //组合url
        let url = exact ? urlPath : self.hostUrl + urlPath
        //启动请求
        let task = manager.dataTask(withHTTPMethod: httpMethod.rawValue, urlString: url, parameters: desParams, headers: nil) { uploadProgress in
            FSLog("uploadProgress:\(uploadProgress.completedUnitCount)---\(uploadProgress.totalUnitCount)")
            if let progress = uploadProgressCallback
            {
                progress(Float(uploadProgress.completedUnitCount) / Float(uploadProgress.totalUnitCount))
            }
        } downloadProgress: { downloadProgress in
            FSLog("downloadProgress:\(downloadProgress.completedUnitCount)---\(downloadProgress.totalUnitCount)")
            if let progress = downloadProgressCallback
            {
                progress(Float(downloadProgress.completedUnitCount) / Float(downloadProgress.totalUnitCount))
            }
        } success: { (task, responseObject) in
            //成功
            //处理返回的数据，解密
            let resDict = self.decryptParams(responseObject!)
            //判断请求是否成功
            let responseCode = resDict[nt_response_code_Key] as! Int
            if responseCode == HttpStatusCode.ok.rawValue   //请求成功
            {
                success(resDict[nt_response_data_Key] as Any)
            }
            else    //请求失败，构造错误对象
            {
                let errMsg: String
                if let msg = resDict[nt_response_msg_Key] as? String
                {
                    errMsg = msg
                }
                else    //如果服务器没有给错误信息，那么尝试从本地获取
                {
                    errMsg = HttpStatusCode(rawValue: responseCode)?.getDesc() ?? String.networkError
                }
                let userInfo = [NSLocalizedDescriptionKey: errMsg]
                let error = NSError(domain: NSCocoaErrorDomain, code: responseCode, userInfo: userInfo)
                failure(error)
            }
        } failure: { (task, error) in
            //失败
            failure(error as NSError)
        }
        task?.resume()
        return task
    }
    
    ///下载大文件
    ///参数：
    ///urlPath：url
    ///exact:`urlPath`是否是完整的url，如果是true，那么不需要组合host地址，一般是false；主要用来测试一些完整的url
    ///downloadProgressCallback:下载数据进度
    ///completion：下载完成后的回调，传入本地下载文件路径
    func download(urlPath: String,
                  exact: Bool = false,
                  authorization: String? = nil,
                  headers: Dictionary<String, String>? = nil,
                  downloadProgressCallback: ((_ progress: Float) -> Void)? = nil,
                  completion: @escaping ((_ filePath: String) -> Void),
                  failure: @escaping RequestFailureCallback) -> URLSessionDownloadTask
    {
        let url = exact ? urlPath : self.hostUrl + urlPath
        let config = URLSessionConfiguration.default
        let manager = AFURLSessionManager.init(sessionConfiguration: config)
        var request = URLRequest(url: URL(string: url)!)
        //构造headers
        if let auth = authorization {
            request.setValue(auth, forHTTPHeaderField: HttpRequestHeaderKey.Authorization.rawValue)
        }
        if let hds = headers {
            for (key, value) in hds
            {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        let downloadTask = manager.downloadTask(with: request) { downloadProgress in
            // @property int64_t totalUnitCount;     需要下载文件的总大小
            // @property int64_t completedUnitCount; 当前已经下载的大小
            let progress = Float(downloadProgress.completedUnitCount) / Float(downloadProgress.totalUnitCount)
            FSLog(String(format: "%f", progress))
            //执行回调
            if let prog = downloadProgressCallback
            {
                prog(progress)
            }
        } destination: { targetUrl, response in
            //block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
            let tmpDownloadDir = SandBoxAccessor.shared.getTempDownloadDir()
            let filePath = (tmpDownloadDir as NSString).appendingPathComponent(response.suggestedFilename!)
            return URL(fileURLWithPath: filePath)
        } completionHandler: { response, fileUrl, error in
            if let err = error //如果下载失败，那么删除临时文件并执行失败的回调
            {
                let filePath = fileUrl?.path
                SandBoxAccessor.shared.deletePath(filePath ?? "")
                failure(err as NSError)
            }
            else
            {
                //设置下载完成操作
                // fileUrl就是你下载文件的位置，你可以解压，也可以直接拿来使用
                let filePath = fileUrl?.path
                completion(filePath!)
            }
        }
        downloadTask.resume()
        return downloadTask
    }
    
    ///上传文件
    ///参数：
    ///urlPath：接口地址，不包含host
    ///exact:`urlPath`是否是完整的url，如果是true，那么不需要组合host地址，一般是false；主要用来测试一些完整的url
    ///fileDatas:文件数据，是个字典，key是文件的标志符（可以是文件路径+文件名，或者随机字符串），value是文件的二进制Data
    ///params：接口参数
    ///authorization:验证，比如用户token，需要验证用户身份的接口要传这个参数
    ///timeoutInterval：超时时间
    ///headers：自定义请求头，根据不同接口可能会不同，大部分为nil
    ///progressCallback:上传数据进度
    func upload(urlPath: String,
                exact: Bool = false,
                fileDatas: Dictionary<String, Data>,
                mimeType: MIMEType,
                params: Dictionary<String, Any>? = nil,
                authorization: String? = nil,
                timeoutInterval: TimeInterval = nt_requestTimeoutInterval,
                headers: Dictionary<String, String>? = nil,
                progressCallback: ((_ progress: Float) -> Void)? = nil,
                success: @escaping RequestSuccessCallback,
                failure: @escaping RequestFailureCallback)
    {
        //处理token和header
        var customHeaders = Dictionary<String, String>()
        if let auth = authorization {
            customHeaders[HttpRequestHeaderKey.Authorization.rawValue] = auth
        }
        if let hds = headers {
            customHeaders.merge(hds) { current, _ in
                current
            }
        }
        //创建请求对象
        let manager = self.createRequest(timeoutInterval: timeoutInterval, requestHeaders: customHeaders)
        //加密参数
        var desParams = params  // 可能为nil
        if let pas = params
        {
            desParams = self.encryptParamValues(pas)
        }
        //组合url
        let url = exact ? urlPath : self.hostUrl + urlPath
        //启动请求
        manager.post(url, parameters: desParams, headers: nil) { formData in
            //拼接数据
            for (key, data) in fileDatas
            {
                formData.appendPart(withFileData: data, name: key, fileName: key, mimeType: mimeType.rawValue)
            }
        } progress: { uploadProgress in
            //上传进度
            FSLog("uploadProgress:\(uploadProgress.completedUnitCount)---\(uploadProgress.totalUnitCount)")
            if let progress = progressCallback
            {
                progress(Float(uploadProgress.completedUnitCount) / Float(uploadProgress.totalUnitCount))
            }
        } success: { task, responseObject in
            //成功
            //处理返回的数据，解密
            let resDict = self.decryptParams(responseObject!)
            //判断请求是否成功
            let responseCode = resDict[nt_response_code_Key] as! Int
            if responseCode == HttpStatusCode.ok.rawValue   //请求成功
            {
                success(resDict[nt_response_data_Key] as Any)     //具体返回的内容和服务器端约定
            }
            else    //请求失败，构造错误对象
            {
                let errMsg: String
                if let msg = resDict[nt_response_msg_Key] as? String
                {
                    errMsg = msg
                }
                else    //如果服务器没有给错误信息，那么尝试从本地获取
                {
                    errMsg = HttpStatusCode(rawValue: responseCode)?.getDesc() ?? String.networkError
                }
                let userInfo = [NSLocalizedDescriptionKey: errMsg]
                let error = NSError(domain: NSCocoaErrorDomain, code: responseCode, userInfo: userInfo)
                failure(error)
            }
        } failure: { task, error in
            failure(error as NSError)
        }
    }
    
}
