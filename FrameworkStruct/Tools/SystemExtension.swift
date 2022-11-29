//
//  SystemExtension.swift
//  FrameworkStruct
//
//  Created by jggg on 2021/12/11.
//

/**
 * 主要对各种系统组件进行扩展
 */
import Foundation

//MARK: NSObject
/**
 * NSObject
 */
extension NSObject
{
    ///获取对象的类名，计算属性
    var className: String {
        let typeName = type(of: self).description()
        if(typeName.contains(String.sDot))
        {
            return typeName.components(separatedBy: String.sDot).last!
        }
        else
        {
            return typeName
        }
    }
    
    ///获取类型的类名，计算属性
    class var className: String {
        NSStringFromClass(Self.self).components(separatedBy: String.sDot).last!
    }
    
    ///判断self是否和指定对象是同样的类的实例
    func isBrother(_ to: Any) -> Bool
    {
        type(of: self) == type(of: to)
    }
    
}


//MARK: Character
/**
 * Character
 */
extension Character
{
    //字符转字符串
    var toString: String {
        String(self)
    }
    
    //char转ASCII码
    var toAscii: Int? {
        guard let ascii = self.asciiValue else {
            return nil
        }
        return Int(ascii)
    }
    
    //char转unicode码
    var toUnicode: Int {
        Int(String(self).unicodeScalars.first!.value)
    }
    
    //unicode或ascii转char
    static func fromUnicode(_ num: Int) -> Character?
    {
        guard let unicode = UnicodeScalar(num) else {
            return nil
        }
        return Character(unicode)
    }
    
}


//MARK: String
/**
 * String
 */
extension String
{
    ///字符串转字符数组
    var chars: [Character] {
        Array(self)
    }
    
    ///用于单个字符串转字符，如果不止一个字符，那么取第一个字符
    var toChar: Character? {
        if let first = self.chars.first {
            return first
        }
        return nil
    }
    
    ///从char数组转字符串
    static func fromChars(_ chars: [Character]) -> String
    {
        String(chars[0..<chars.count])
    }
    
    ///去除字符串头尾空格和换行
    func trim() -> String
    {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    ///去除字符串中的换行和空格
    ///参数：includeSpace：是否去除空格，默认不去除
    func trimSpaceAndNewLine(includeSpace: Bool = false) -> String
    {
        var str = self.trim()
        str = str.replacingOccurrences(of: String.sNewLine, with: String.sEmpty)
        str = str.replacingOccurrences(of: String.sNewline, with: String.sEmpty)
        if includeSpace
        {
            str = str.replacingOccurrences(of: String.sSpace, with: String.sEmpty)
        }
        return str
    }
    
    ///截取规定下标之后的字符串
    func subStringFrom(index: Int) -> String
    {
        let temporaryString: String = self
        let temporaryIndex = temporaryString.index(temporaryString.startIndex, offsetBy: index)
        return String(temporaryString[temporaryIndex...])
    }

    ///截取规定下标之前的字符串，不包括index
    func subStringTo(index: Int) -> String
    {
        let temporaryString = self
        let temporaryIndex = temporaryString.index(temporaryString.startIndex, offsetBy: index)
        return String(temporaryString[..<temporaryIndex])
    }
    
    ///替换某个range的字符串
    func replaceStringWithRange(location: Int, length: Int, newString: String) -> String
    {
        if location + length > self.count {
            return self
        }
        let start = self.startIndex
        let location_start = self.index(start, offsetBy: location)
        let location_end = self.index(location_start, offsetBy: length)
        let result = self.replacingCharacters(in: location_start..<location_end, with: newString)
        return result
    }
    
    ///获取某个range的子串
    func subStringWithRange(location: Int, length: Int) -> String
    {
        if location + length > self.count{
            return self
        }
        let str: String = self
        let start = str.startIndex
        let startIndex = str.index(start, offsetBy: location)
        let endIndex = str.index(startIndex, offsetBy: length)
        return String(str[startIndex..<endIndex])
    }
        
    /// 正则匹配第一次出现的范围，没有匹配到返回nil
    func firstMatchWith(pattern: RegexExpression) -> NSRange?
    {
        if self.count == 0  //如果源字符串为空，返回nil
        {
            return nil
        }
        
        do {
            let str: String = self
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let ret = regex.firstMatch(in: str, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSMakeRange(0, str.count))
            if let result = ret {
                return NSMakeRange(result.range.location, result.range.length)
            }
        }catch {
            FSLog("regex error: \(error)")
        }
        
        return nil
    }
    
    ///该字符串是否符合正则表达式
    func isMatch(pattern: RegexExpression) -> Bool
    {
        var ret = false
        if let regex = try? NSRegularExpression(pattern: pattern, options: [])
        {
            if regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil
            {
                ret = true
            }
        }
        return ret
    }
        
    /// 获取子串的所有range
    static func rangesOfString(_ searchString: String, inString: NSString) -> [NSRange]
    {
         var results = [NSRange]()
         if searchString.count > 0 && inString.length > 0 {
             var searchRange = NSMakeRange(0, inString.length)
             var range = inString.range(of: searchString, options: [], range: searchRange)
             while (range.location != NSNotFound) {
                 results.append(range)
                 searchRange = NSMakeRange(NSMaxRange(range), inString.length - NSMaxRange(range))
                 range = inString.range(of: searchString, options: [], range: searchRange)
             }
             
         }
         return results
     }
    
    ///根据下标，截取子字符，闭区间
    func subStr(_ start: Int, _ end: Int) -> String
    {
        if start >= self.count {
            return self
        }
        var newEnd: Int = end
        if end >= self.count {
            newEnd = self.count - 1
        }
        let startIdx = self.index(self.startIndex, offsetBy: start)
        let endIdx = self.index(self.startIndex, offsetBy: newEnd)
        return String(self[startIdx...endIdx])
    }
    
    ///移除第一个子字符
    func removeFirstSubStr(_ subStr: String) -> String
    {
        if subStr.count > self.count {
             return self
         }
         
         let len = subStr.count
         for i in 0..<self.count {
             let start = i
             let end = i + len - 1
             
             if end > self.count - 1 { // 防止数组越界
                 break
             }
             if subStr == self.subStr(start, end) {
                 if i == 0 && end == self.count - 1 { // 前后完全覆盖
                     return String.sEmpty
                 } else if i == 0 && end < self.count - 1 { // 从0开始覆盖前面一部分
                     return self.subStr(end + 1, self.count - 1)
                 } else if i > 0 && end == self.count - 1 { // 从结尾覆盖后面一部分
                     return self.subStr(0, i - 1)
                 } else { // 中间
                     let preStr = self.subStr(0, i - 1)
                     let trailStr = self.subStr(end + 1, self.count - 1)
                     return preStr + trailStr
                 }
             }
         }
         
         return self
     }
    
    ///是否包含某个子字符
    func isContainSubStr(_ subStr: String) -> Bool
    {
        let len = subStr.count
        for i in 0..<self.count {
            let start = i
            let end = i + len - 1
            if end > self.count - 1 {
                break
            }
            if subStr == self.subStr(start, end) {
                return true
            }
        }
        
        return false
    }
    
    ///计算字符串尺寸大小
    func sizeWith(font: UIFont, maxWidth: CGFloat) -> CGSize
    {
        let rect = self.boundingRect(with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font : font], context: nil)
        return rect.size
    }
    
    ///计算字符串高度
    func heightWith(font: UIFont, maxWidth: CGFloat) -> CGFloat
    {
        let size = self.sizeWith(font: font, maxWidth: maxWidth)
        return size.height
    }
    
    ///计算文本高度
    func calcHeight(font: UIFont, size: CGSize) -> CGFloat
    {
        var height:CGFloat = 0.0
        let rect = (self as NSString).boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        height = rect.height
        return height
    }
    
    ///计算文本宽度
    func calcWidth(font: UIFont, size: CGSize) -> CGFloat
    {
        var width:CGFloat = 0.0
        let rect = (self as NSString).boundingRect(with: size, options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: font], context: nil)
        width = rect.width
        return width
    }
    
    ///带有行间距、颜色和字体的属性字符串
    func attrString(font: UIFont, color: UIColor, lineSpace: CGFloat = 4.0) -> NSAttributedString
    {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = lineSpace
        let attrStr = NSAttributedString.init(string: self, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.paragraphStyle: paragraph])
        return attrStr
    }
    
    ///字符串转字典，前提是这是个json字符串
    func toDictionary() -> [String: Any]
    {
        var result = [String: Any]()
        guard !self.isEmpty else { return result }
        guard let dataSelf = self.data(using: .utf8) else {
            return result
        }
        if let dic = try? JSONSerialization.jsonObject(with: dataSelf, options: .mutableContainers) as? [String: Any] {
            result = dic
        }
        return result
    }
    
    ///将数组或字典对象转换成json字符串
    static func convertObjToJsonString(_ obj: Any) -> String?
    {
        guard let data = try? JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted) else {
            return nil
        }
        var str = String.init(data: data, encoding: .utf8)
        str = str?.trimSpaceAndNewLine()
        return str
    }
    
    ///将json字符串转换为数组或字典
    func toJsonObj() -> Any?
    {
        if let data = self.data(using: .utf8)
        {
            if let obj = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            {
                return obj
            }
        }
        return nil
    }
    
    ///将字符串转换为Data
    func toData() -> Data?
    {
        self.data(using: .utf8)
    }
    
    ///base64编码
    var base64: String? {
        EncryptManager.shared.base64FromString(self)
    }
    
    ///base64解码
    var base64Decode: String? {
        EncryptManager.shared.base64DecodeToString(self)
    }
    
    ///md5加密
    var md5: String {
        EncryptManager.shared.md5(self)
    }
    
    ///sha256加密
    var sha256: String {
        EncryptManager.shared.sha256(self)
    }
    
    ///rsa加密
    var rsa: String {
        EncryptManager.shared.rsa(self, publicKey: rsa_public_key)
    }
    
    ///rsa解密
    var rsaDecrypt: String {
        EncryptManager.shared.rsaDecrypt(self, privateKey: rsa_private_key)
    }
    
    ///如果字符串是url，那么拼接参数，如果value为nil，那么不拼接
    func joinUrlParam(_ value: String?, key: String) -> String
    {
        var finalStr: String = self
        if let value = value
        {
            if !self.contains(String.sQuestion)   //如果没有有问号，那么先拼接一个问号
            {
                finalStr += String.sQuestion
            }
            else    //如果有问号，说明已经有参数了，那么拼接一个`&`
            {
                finalStr += String.sAnd
            }
            //拼接参数
            finalStr += "\(key)=\(value)"
        }
        return finalStr
    }
    
    ///是否有效字符串
    func isValid() -> Bool
    {
        DatasChecker.shared.checkValidString(self)
    }
    
}


//MARK: Double
/**
 Double
 */
extension Double
{
    //截取到几位小数，非四舍五入
    func truncate(_ places : UInt)-> Double
    {
        return Double(floor(pow(10.0, Double(places)) * self) / pow(10.0, Double(places)))
    }
    
}


//MARK: NSAttributedString
/**
 * NSAttributedString
 */
extension NSAttributedString
{
    ///计算属性字符串的位置大小，请保证设置了属性字体
    func calcSize(originSize: CGSize) -> CGSize
    {
        let rect = self.boundingRect(with: originSize, options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil)
        return rect.size
    }
    
}


//MARK: Data
/**
 * Data
 */
extension Data
{
    ///将Data转换成string
    func toString(encode: String.Encoding = .utf8) -> String?
    {
        String(data: self, encoding: encode)
    }
    
    ///将二进制json对象转换成json字典
    func toDictionary() -> Dictionary<String, Any>?
    {
        if let obj = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers) as? Dictionary<String, Any>
        {
            return obj
        }
        return nil
    }
    
    ///base64编码
    var base64: String {
        EncryptManager.shared.base64(self)
    }
    
}


//MARK: Array
/**
 * Array
 */
extension Array
{
    ///实现复制方法，返回一个新数组和新元素
    func copy() -> Array<Any>
    {
        var newArray = [Any]()
        for item in self
        {
            newArray.append(g_copy(item)!)
        }
        return newArray
    }
    
    ///让Array支持contains方法
    func contains<T>(_ item: T) -> Bool where T: Equatable
    {
        return self.filter({$0 as? T == item}).count > 0
    }
    
    ///删除某个元素
    mutating func removeObject(_ obj: Element!) where Element: Equatable
    {
        self.removeAll(where: {$0 == obj})
    }
    
}


//MARK: Dictionary
/**
 * Dictionary
 */
extension Dictionary
{
    ///实现复制方法，返回一个新的字典和新元素
    func copy() -> Dictionary<AnyHashable, Any>
    {
        var newDic = Dictionary<AnyHashable, Any>()
        for (k, v) in self
        {
            newDic[k] = g_copy(v)
        }
        return newDic
    }
    
    ///字典转json字符串
    func toJsonString() -> String?
    {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            return nil
        }
        guard let str = String(data: data, encoding: .utf8) else {
            return nil
        }
        return str
     }
    
}


//MARK: NSPointerArray
/**
 * NSPointerArray
 */
extension NSPointerArray
{
    ///向弱引用数组添加对象
    func addObject(_ object: AnyObject?)
    {
        guard let strongObject = object else { return }
        let pointer = Unmanaged.passUnretained(strongObject).toOpaque()
        addPointer(pointer)
    }
 
    ///向弱引用数组的index位置插入对象
    func insertObject(_ object: AnyObject?, at index: Int)
    {
        guard index < count, let strongObject = object else { return }
        let pointer = Unmanaged.passUnretained(strongObject).toOpaque()
        insertPointer(pointer, at: index)
    }
 
    ///替换弱引用数组index位置的对象
    func replaceObject(at index: Int, withObject object: AnyObject?)
    {
        guard index < count, let strongObject = object else { return }
        let pointer = Unmanaged.passUnretained(strongObject).toOpaque()
        replacePointer(at: index, withPointer: pointer)
    }
 
    ///获取弱引用数组index位置的对象
    func object(at index: Int) -> AnyObject?
    {
        guard index < count, let pointer = self.pointer(at: index) else { return nil }
        return Unmanaged<AnyObject>.fromOpaque(pointer).takeUnretainedValue()
    }
 
    ///删除弱引用数组index位置的对象
    func removeObject(at index: Int)
    {
        guard index < count else { return }
        removePointer(at: index)
    }
    
}
