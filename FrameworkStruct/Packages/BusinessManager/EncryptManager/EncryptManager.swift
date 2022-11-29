//
//  EncryptManager.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/1/27.
//

/**
 * 加密管理器
 *
 * 功能详述：主要负责管理工程中的加密算法和实用加密方法
 *
 * 注意事项：
 *
 * AES加密参考：https://github.com/krzyzanowskim/CryptoSwift
 *
 * RSA加密参考：https://github.com/TakeScoop/SwiftyRSA
 *
 */
import UIKit
import CommonCrypto

class EncryptManager: OriginManager
{
    //MARK: 属性
    //单例
    static let shared = EncryptManager()
    
    
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


//接口方法
extension EncryptManager: ExternalInterface
{
    ///生成一个32~36位随机字符串，用于生成各种随机id
    ///形如：F4709DFF-24CD-458F-AECB-C0082B87052A
    ///参数：lower：是否将字母转为小写格式；short：是否转为紧凑模式（去除字符串中间的`-`分隔符），使用紧凑模式将返回32位字符串，非紧凑模式返回36位
    func uuidString(lower: Bool = true, short: Bool = true) -> String
    {
        let uuid_ref: CFUUID = CFUUIDCreate(nil)
        let uuid_string_ref: CFString = CFUUIDCreateString(nil, uuid_ref)
        var uuid = uuid_string_ref as String
        if lower
        {
            uuid = uuid.lowercased()
        }
        if short
        {
            uuid = uuid.replacingOccurrences(of: "-", with: "")
        }
        return uuid
    }
    
    ///DES加密一个字符串
    func des(_ originStr: String, desKey: String) -> String
    {
        return NSString.des(originStr, key: desKey)
    }
    
    ///des解密一个字符串
    func desDecrypt(_ encryptStr: String, desKey: String) -> String
    {
        return NSString.decryptDes(encryptStr, key: desKey)
    }
    
    ///MD5加密一个字符串
    ///参数：originStr：原始字符串；short：是否短格式，true返回16位，false返回32位；lower：是否小写字母
    func md5(_ originStr: String, short: Bool = false, lower: Bool = false) -> String
    {
        if short
        {
            return lower ? NSString.md5(forLower16Bate: originStr) : NSString.md5(forUpper16Bate: originStr)
        }
        else
        {
            return lower ? NSString.md5(forLower32Bate: originStr) : NSString.md5(forUpper32Bate: originStr)
        }
    }
    
    ///swift版本md5加密
    func md5(_ originStr: String) -> String
    {
        let str = originStr.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(originStr.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deallocate()
        return hash as String
    }
    
    ///字符串sha256加密
    func sha256(_ originStr: String) -> String
    {
        let utf8 = originStr.cString(using: .utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CC_SHA256(utf8, CC_LONG(utf8!.count - 1), &digest)
        return digest.reduce(String.sEmpty) { $0 + String(format:"%02x", $1) }
    }
    
    ///base64编码
    func base64(_ data: Data) -> String
    {
        let baseStr = data.base64EncodedString()
        return baseStr
    }
    
    ///将字符串base64编码
    func base64FromString(_ str: String) -> String?
    {
        guard let data = str.data(using: .utf8) else {
            return nil
        }
        return self.base64(data)
    }
    
    ///base64解码
    func base64Decode(_ str: String) -> Data?
    {
        let data = Data.init(base64Encoded: str)
        return data
    }
    
    ///解码base64字符串为字符串
    func base64DecodeToString(_ str: String) -> String?
    {
        guard let data = self.base64Decode(str) else {
            return nil
        }
        return String.init(data: data, encoding: .utf8)
    }
    
    ///RSA公钥加密
    func rsa(_ str: String, publicKey: String) -> String
    {
        var reslutStr = ""
        do{
            let rsa_publicKey = try PublicKey(pemEncoded: publicKey)
            let clear = try ClearMessage(string: str, using: .utf8)
            reslutStr = try clear.encrypted(with: rsa_publicKey, padding: .PKCS1).base64String
             
        }catch{
            FSLog("RSA encrypt failed")
        }
        return reslutStr
    }
    
    ///RSA私钥解密
    func rsaDecrypt(_ str: String, privateKey: String) -> String
    {
        var resultStr = ""
        let enData = Data(base64Encoded: str, options: .ignoreUnknownCharacters)!
        do {
            let rsa_privateKey = try PrivateKey(pemEncoded: privateKey)
            let data = try EncryptedMessage(data: enData).decrypted(with: rsa_privateKey, padding: .PKCS1).data
            resultStr = String(data: data, encoding: .utf8) ?? ""
        } catch {
            FSLog("RSA decrypt failed")
        }
        return resultStr
    }
    
    ///AES加密
    func aes()
    {
        
    }
    
    ///AES解密
    func aesDecrypt()
    {
        
    }
    
}
