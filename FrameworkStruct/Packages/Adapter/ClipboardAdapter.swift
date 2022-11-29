//
//  ClipboardAdapter.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/4/1.
//

/**
 * 系统剪贴板适配器
 * 读取系统剪贴板、向系统剪贴板写入内容等
 */
import UIKit

class ClipboardAdapter: OriginAdapter
{
    //MARK: 属性
    //单例
    static let shared = ClipboardAdapter()
    
    
    //MARK: 方法
    //私有化初始化方法
    private override init()
    {
        super.init()
        self.addNotification()
    }
    
    override func copy() -> Any
    {
        return self
    }
    
    override func mutableCopy() -> Any
    {
        return self
    }
    
    fileprivate func addNotification()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(pasteboardDidChangeNotification(notification:)), name: UIPasteboard.changedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pasteboardDidRemoveNotification(notification:)), name: UIPasteboard.removedNotification, object: nil)
    }

}


//代理通知方法
extension ClipboardAdapter: DelegateProtocol
{
    //剪贴板内容变化
    @objc func pasteboardDidChangeNotification(notification: Notification)
    {
        
    }
    
    //删除某个自定义剪贴板
    @objc func pasteboardDidRemoveNotification(notification: Notification)
    {
        
    }
    
}


//内部类型
extension ClipboardAdapter: InternalType
{
    ///剪贴板类型，全局或app范围
    enum CAPasteboardType {
        case system             //系统剪贴板
        case custom(String)     //自定义剪贴板，传入标志符
        
        //用户剪贴板，用户保存一些app级的自定义内容
        static let userPasteboard = CAPasteboardType.custom("userPasteboard")
        
        //获取剪贴板对象
        func getPasteboard() -> UIPasteboard
        {
            switch self {
            case .system:
                return UIPasteboard.general
            case .custom(let name):
                return UIPasteboard(name: .init(rawValue: name), create: true) ?? UIPasteboard.general
            }
        }
    }
    
    ///保存在剪贴板中的数据的类型
    enum CAPasteboardDataType {
        case string
        case strings
        case url
        case urls
        case image
        case images
        case color
        case colors
        case data(String)   //关联一个key，到时根据key取数据
        case any(String)    //关联一个key，到时根据key取数据
    }
    
    ///保存的item数据类型，如果有新的类型，那么在此处新增
    ///目前仅支持string/data/image
    enum CAItemType {
        case string, data, image
        
        //将Data转换成需要的数据类型
        func convertData(data: Data) -> Any?
        {
            switch self {
            case .string:
                return String(data: data, encoding: .utf8)
            case .data:
                return Data(data)
            case .image:
                return UIImage(data: data)
            }
        }
    }
    
}


//接口方法
extension ClipboardAdapter: ExternalInterface
{
    ///将数据写入剪贴板，返回剪贴板对象
    func write(value: Any, valueType: CAPasteboardDataType, in pasteboard: CAPasteboardType = .system) -> UIPasteboard
    {
        let pb = pasteboard.getPasteboard()
        switch valueType {
        case .string:
            pb.string = value as? String
        case .strings:
            pb.strings = value as? [String]
        case .url:
            pb.url = value as? URL
        case .urls:
            pb.urls = value as? [URL]
        case .image:
            pb.image = value as? UIImage
        case .images:
            pb.images = value as? [UIImage]
        case .color:
            pb.color = value as? UIColor
        case .colors:
            pb.colors = value as? [UIColor]
        case .data(let key):
            if let val = value as? Data
            {
                pb.setData(val, forPasteboardType: key)
            }
        case .any(let key):
            pb.setValue(value, forPasteboardType: key)
        }
        return pb
    }
    
    ///从剪贴板读取数据
    func read(valueType: CAPasteboardDataType, in pasteboard: CAPasteboardType = .system) -> Any?
    {
        let pb = pasteboard.getPasteboard()
        switch valueType {
        case .string:
            return pb.string
        case .strings:
            return pb.strings
        case .url:
            return pb.url
        case .urls:
            return pb.urls
        case .image:
            return pb.image
        case .images:
            return pb.images
        case .color:
            return pb.color
        case .colors:
            return pb.colors
        case .data(let key):
            return pb.data(forPasteboardType: key)
        case .any(let key):
            return pb.value(forPasteboardType: key)
        }
    }
    
    ///向剪贴板中添加key/values，并设置多少秒后过期，是否仅本app可用
    ///目前仅支持string/data/image
    func writeItem(_ item: Any, key: String, expire after: TimeInterval = .infinity, onlyLocal: Bool = false, in pasteboard: CAPasteboardType = .userPasteboard)
    {
        let pb = pasteboard.getPasteboard()
        let options: [UIPasteboard.OptionsKey : Any] = [.expirationDate: nowAfter(after), .localOnly: onlyLocal]
        pb.setItems([[key: item]], options: options)
    }
    
    ///从剪贴板读取key/values，如果有并且未过期的话
    func readItem(key: String, itemType: CAItemType, in pasteboard: CAPasteboardType = .userPasteboard) -> Any?
    {
        var value: Any? = nil
        let pb = pasteboard.getPasteboard()
        let items = pb.items
        for item in items   //item是字典
        {
            if let val = item[key]
            {
                //由于从剪贴板读取数据后是Data类型，所以需要转换
                value = itemType.convertData(data:(val as! Data))
                break
            }
        }
        return value
    }
    
    ///判断剪贴板中是否有某种类型的值
    func contain(valueType: CAPasteboardDataType, in pasteboard: CAPasteboardType = .system) -> Bool
    {
        let pb = pasteboard.getPasteboard()
        switch valueType {
        case .string:
            return pb.hasStrings
        case .strings:
            return pb.hasStrings
        case .url:
            return pb.hasURLs
        case .urls:
            return pb.hasURLs
        case .image:
            return pb.hasImages
        case .images:
            return pb.hasImages
        case .color:
            return pb.hasColors
        case .colors:
            return pb.hasColors
        case .data(let key):
            return pb.contains(pasteboardTypes: [key])
        case .any(let key):
            return pb.contains(pasteboardTypes: [key])
        }
    }
    
    ///删除某个自定义剪贴板
    func deletePasteboard(_ name: String)
    {
        UIPasteboard.remove(withName: .init(rawValue: name))
    }
    
}
