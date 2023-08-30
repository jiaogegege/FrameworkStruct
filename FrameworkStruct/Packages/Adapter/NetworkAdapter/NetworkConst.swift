//
//  NetworkConst.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/2/10.
//

/**
 网络常量和url配置
 变量以`nt`开头，表示network
 */
import Foundation

//MARK: 常量定义
/**************************************** 加密相关 Section Begin ****************************************/
///参数是否加密
let nt_encrypt = false

///DES加密的密钥
let nt_encrypt_des_key = "Aipi3pWCzdo6tA2SL0gp3ajx"

///不需要加密的参数key，在这个数组中的key不会被加密
let nt_encrypt_escape_key = ["imgCode"]

///如果加密整个参数，那么最终返回的参数都放在key为`data`的字典中，和后端协商确定
let nt_encrypt_data_key = "data"

/**************************************** 加密相关 Section End ****************************************/

///请求超时时间间隔
let nt_request_timeoutInterval: TimeInterval = 30.0

///可接受的返回数据类型
let nt_response_acceptableContentType: Set<String> = ["text/html", "application/json", "text/json", "text/javascript", "text/plain"]

//请求成功和失败的回调
typealias RequestSuccessCallback = (_ response: Any) -> Void
typealias RequestFailureCallback = (_ error: NSError) -> Void

//MARK: 部分参数名定义，和后端协商确定
let nt_request_macAddress_key = "macAddress"    //mac地址
let nt_request_deviceType_key = "deviceType"    //iOS
let nt_request_clientTime_key = "clientTime"    //客户端时间

let nt_response_code_key = "errCode"  //返回的状态码key
let nt_response_msg_key = "errMsg"    //返回的状态信息key
let nt_response_data_key = "data"     //返回数据的key

//MARK: 服务器环境定义
///服务器环境变量
let nt_serverHost: ServerHostType = .qa

enum ServerHostType {
    case dev    //开发环境
    case qa     //测试环境
    case uat    //内测/预发布环境
    case pro    //生产环境
    
    //获取服务器环境的主机地址
    func getHost() -> String
    {
        switch self {
        case .dev:
            return "http://192.168.50.54"
        case .qa:
            return "https://jszhaofeng.cn"
        case .uat:
            return "https://www.awaitz.com/pre"
        case .pro:
            return "https://www.awaitz.com"
        }
    }
}

//MARK: URL定义
//首页数据，包括首页模块、活动信息和banner等
let url_homeData = "/api/awaitz-mall/home/v1/homeData"
//使用手机号和验证码快速登录
let url_loginWithPhoneAndSms = "/api/awaitz-mall/user/v1/sms/login"




//MARK: HTTP相关信息定义
///HTTP方法
enum HttpMethodType: String {
    case GET
    case POST
    case PUT
    case PATCH
    case HEAD
    case DELETE
}

//MIME type
enum MIMEType: String {
    case txt = "text/plain"
    case xml = "text/xml"
    case html = "text/html"
    case svg = "image/svg+xml"
    case css = "text/css"
    case js = "text/javascript"
    case rtf = "application/rtf"
    case rtx = "text/richtext"
    case pdf = "application/pdf"
    case gif = "image/gif"
    case jpeg = "image/jpeg"
    case png = "image/png"
    case bmp = "image/bmp"
    case xbm = "image/x-xbitmap"
    case pbm = "image/x-portable-bitmap"
    case tiff = "image/tiff"
    case psd = "image/x-photoshop"
    case au = "audio/basic"
    case wav = "audio/x-wav"
    case kar = "audio/x-midi"
    case mid = "audio/mid"
    case midi = "audio/midi,audio/x-midi"
    case mp3 = "audio/x-mpeg"
    case ra = "audio/x-pn-realaudio"
    case mpeg = "video/mpeg"
    case mpv2 = "video/mpeg2"
    case movie = "video/quicktime"
    case qti = "image/x-quicktime"
    case avi = "video/x-msvideo"
    case zip = "application/zip"
    case gz = "application/x-gzip"
    case tar = "application/x-tar"
    case gtar = "application/x-gtar"
    case swf = "application/x-shockwave-flash"
}

///request headers key
enum HttpRequestHeaderKey: String {
    case Accept = "Accept"  //指定客户端能够接收的内容类型：Accept: text/plain, text/html
    case AcceptCharset = "Accept-Charset"   //浏览器可以接受的字符编码集：Accept-Charset: iso-8859-5
    case AcceptEncoding = "Accept-Encoding"     //指定浏览器可以支持的web服务器返回内容压缩编码类型：Accept-Encoding: compress, gzip
    case AcceptLanguage = "Accept-Language"     //浏览器可接受的语言：Accept-Language: en,zh
    case AcceptRanges = "Accept-Ranges"     //可以请求网页实体的一个或者多个子范围字段：Accept-Ranges: bytes
    case Authorization = "Authorization"    //HTTP授权的授权证书：Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==
    case CacheControl = "Cache-Control"     //指定请求和响应遵循的缓存机制：Cache-Control: no-cache
    case Connection = "Connection"      //表示是否需要持久连接。（HTTP 1.1默认进行持久连接）：Connection: close
    case Cookie = "Cookie"  //HTTP请求发送时，会把保存在该请求域名下的所有cookie值一起发送给web服务器：Cookie: $Version=1; Skin=new;
    case ContentLength = "Content-Length"   //请求的内容长度：Content-Length: 348
    case ContentType = "Content-Type"       //请求的与实体对应的MIME信息：Content-Type: application/x-www-form-urlencoded
    case Date = "Date"  //请求发送的日期和时间：Date: Tue, 15 Nov 2010 08:12:31 GMT
    case Expect = "Expect"  //请求的特定的服务器行为：Expect: 100-continue
    case From = "From"  //发出请求的用户的Email：From: user@email.com
    case Host = "Host"  //指定请求的服务器的域名和端口号：Host: www.zcmhi.com
    case IfMatch = "If-Match"   //只有请求内容与实体相匹配才有效：If-Match: “737060cd8c284d8af7ad3082f209582d”
    case IfModifiedSince = "If-Modified-Since"  //如果请求的部分在指定时间之后被修改则请求成功，未被修改则返回304代码：If-Modified-Since: Sat, 29 Oct 2010 19:43:31 GMT
    case IfNoneMatch = "If-None-Match"  //如果内容未改变返回304代码，参数为服务器先前发送的Etag，与服务器回应的Etag比较判断是否改变：If-None-Match: “737060cd8c284d8af7ad3082f209582d”
    case IfRange = "If-Range"   //如果实体未改变，服务器发送客户端丢失的部分，否则发送整个实体。参数也为Etag：If-Range: “737060cd8c284d8af7ad3082f209582d”
    case IfUnmodifiedSince = "If-Unmodified-Since"  //只在实体在指定时间之后未被修改才请求成功：If-Unmodified-Since: Sat, 29 Oct 2010 19:43:31 GMT
    case MaxForwards = "Max-Forwards"   //限制信息通过代理和网关传送的时间：Max-Forwards: 10
    case Pragma = "Pragma"  //用来包含实现特定的指令：Pragma: no-cache
    case ProxyAuthorization = "Proxy-Authorization"     //连接到代理的授权证书：Proxy-Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==
    case Range = "Range"    //只请求实体的一部分，指定范围：Range: bytes=500-999
    case Referer = "Referer"    //先前网页的地址，当前请求网页紧随其后,即来路：Referer: http://www.zcmhi.com/archives/71.html
    case TE = "TE"  //客户端愿意接受的传输编码，并通知服务器接受接受尾加头信息：TE: trailers,deflate;q=0.5
    case Upgrade = "Upgrade"    //向服务器指定某种传输协议以便服务器进行转换（如果支持）：Upgrade: HTTP/2.0, SHTTP/1.3, IRC/6.9, RTA/x11
    case UserAgent = "User-Agent"   //User-Agent的内容包含发出请求的用户信息
    case Via = "Via"    //通知中间网关或代理服务器地址，通信协议：Via: 1.0 fred, 1.1 nowhere.com (Apache/1.1)
    case Warning = "Warning"    //关于消息实体的警告信息：Warn: 199 Miscellaneous warning
}

///response headers key
enum HttpResponseHeaderKey: String {
    case AcceptRanges = "Accept-Ranges"     //表明服务器是否支持指定范围请求及哪种类型的分段请求：Accept-Ranges: bytes
    case Age = "Age"    //从原始服务器到代理缓存形成的估算时间（以秒计，非负）：Age: 12
    case Allow = "Allow"    //对某网络资源的有效的请求行为，不允许则返回405：Allow: GET, HEAD
    case CacheControl = "Cache-Control"     //告诉所有的缓存机制是否可以缓存及哪种类型：Cache-Control: no-cache
    case ContentEncoding = "Content-Encoding"   //web服务器支持的返回内容压缩编码类型：Content-Encoding: gzip
    case ContentLanguage = "Content-Language"   //响应体的语言：Content-Language: en,zh
    case ContentLength = "Content-Length"   //响应体的长度：Content-Length: 348
    case ContentLocation = "Content-Location"   //请求资源可替代的备用的另一地址：Content-Location: /index.htm
    case ContentMD5 = "Content-MD5" //返回资源的MD5校验值：Content-MD5: Q2hlY2sgSW50ZWdyaXR5IQ==
    case ContentRange = "Content-Range" //在整个返回体中本部分的字节位置：Content-Range: bytes 21010-47021/47022
    case ContentType = "Content-Type"   //返回内容的MIME类型：Content-Type: text/html; charset=utf-8
    case Date = "Date"  //原始服务器消息发出的时间：Date: Tue, 15 Nov 2010 08:12:31 GMT
    case ETag = "ETag"  //请求变量的实体标签的当前值：ETag: “737060cd8c284d8af7ad3082f209582d”
    case Expires = "Expires"    //响应过期的日期和时间：Expires: Thu, 01 Dec 2010 16:00:00 GMT
    case LastModified = "Last-Modified"     //请求资源的最后修改时间：Last-Modified: Tue, 15 Nov 2010 12:45:26 GMT
    case Location = "Location"  //用来重定向接收方到非请求URL的位置来完成请求或标识新的资源：Location: http://www.zcmhi.com/archives/94.html
    case Pragma = "Pragma"  //包括实现特定的指令，它可应用到响应链上的任何接收方：Pragma: no-cache
    case ProxyAuthenticate = "Proxy-Authenticate"   //它指出认证方案和可应用到代理的该URL上的参数：Proxy-Authenticate: Basic
    case refresh = "refresh"    //应用于重定向或一个新的资源被创造，在5秒之后重定向（由网景提出，被大部分浏览器支持）：Refresh: 5; url=http://www.zcmhi.com/archives/94.html
    case RetryAfter = "Retry-After"     //如果实体暂时不可取，通知客户端在指定时间之后再次尝试：Retry-After: 120
    case Server = "Server"  //web服务器软件名称：Server: Apache/1.3.27 (Unix) (Red-Hat/Linux)
    case SetCookie = "Set-Cookie"   //设置Http Cookie：Set-Cookie: UserID=JohnDoe; Max-Age=3600; Version=1
    case Trailer = "Trailer"    //指出头域在分块传输编码的尾部存在：Trailer: Max-Forwards
    case TransferEncoding = "Transfer-Encoding" //文件传输编码：Transfer-Encoding:chunked
    case Vary = "Vary"  //告诉下游代理是使用缓存响应还是从原始服务器请求：Vary: *
    case Via = "Via"    //告知代理客户端响应是通过哪里发送的：Via: 1.0 fred, 1.1 nowhere.com (Apache/1.1)
    case Warning = "Warning"    //警告实体可能存在的问题：Warning: 199 Miscellaneous warning
    case WWWAuthenticate = "WWW-Authenticate"   //表明客户端请求实体应该使用的授权方案：WWW-Authenticate: Basic
}

///接口返回的状态码，包括http标准状态码和自定义状态码
enum HttpStatusCode: Int
{
    case unknown = -1                       //未知状态，没有定义的状态
    
    case unavailable = 0                    //网络不可用
    
    case dataParseError = 10                //数据解析错误，接口返回了数据，但是本地解析出错
    
    case ok = 200                           //正常
    case created = 201                      //已创建。成功请求并创建了新的资源
    case accepted = 202                     //已接受。已经接受请求，但未处理完成
    
    case notFound = 404                     //资源未找到
    case badRequest = 400                   //请求失败
    case needAuth = 401                     //需要验证身份
    case forbidden = 403                    //服务器理解请求客户端的请求，但是拒绝执行此请求
    case timeout = 408                      //服务器等待客户端发送的请求时间过长，超时
    
    case systemError = 500                  //服务器错误
    case noService = 501                    //没有此服务
    case badGetway = 502                    //服务器连接失败
    case serviceUnavailable = 503           //服务器暂时的无法处理客户端的请求
    
    //Error Domain
    static let errorDomain: String = "FSNetworkErrorDomain"
    
    ///获取状态信息
    func getDesc() -> String
    {
        switch self {
        case .unknown:
            return String.networkUndefinedStatus
        case .unavailable:
            return String.networkUnavailable
        case .dataParseError:
            return String.networkDataParseError
        case .ok:
            return String.networkOk
        case .created:
            return String.networkCreated
        case .accepted:
            return String.networkAccepted
        case .notFound:
            return String.networkNotFound
        case .badRequest:
            return String.networkBadRequest
        case .needAuth:
            return String.networkNeedAuth
        case .forbidden:
            return String.networkForbidden
        case .timeout:
            return String.networkTimeout
        case .systemError:
            return String.networkSystemError
        case .noService:
            return String.networkNoService
        case .badGetway:
            return String.networkBadGetway
        case .serviceUnavailable:
            return String.networkServiceUnavailable
        }
    }
    
    ///获取错误对象
    func getError() -> NSError
    {
        let errMsg = self.getDesc()
        let userInfo = [NSLocalizedDescriptionKey: errMsg, NSLocalizedFailureErrorKey: errMsg, NSLocalizedFailureReasonErrorKey: errMsg]
        let error = NSError(domain: Self.errorDomain, code: self.rawValue, userInfo: userInfo)
        return error
    }
}
