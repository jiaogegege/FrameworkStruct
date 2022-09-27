//
//  iCloudAdapter.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/9/22.
//


/**
 iCloud存储适配器
 主要用来在iCloud中保存和同步数据
 
 配置方法：
 在开发者中心的AppIDs页面勾选iCloud，并配置添加Containers，identifier建议填写项目的bundleID，可配置多个；创建profile并下载安装；在Xcode的Capabilities中添加iCloud并勾选需要的服务，再勾选Containers
 */
import UIKit
import CloudKit


/**
 通知
 */
extension FSNotification
{
    static let iCloudValueChange = FSNotification(value: "iCloudValueChange", paramKey: "IAValueChangeModel")        //value change的通知
}


class iCloudAdapter: OriginAdapter {
    //MARK: 属性
    //单例
    static let shared = iCloudAdapter()
    
    //key-value存储管理器
    fileprivate(set) lazy var kvMgr: NSUbiquitousKeyValueStore = NSUbiquitousKeyValueStore.default
    
    //FileManager
    fileprivate lazy var fileMgr: FileManager = FileManager.default
    
    //沙盒存取器
    fileprivate lazy var sbMgr: SandBoxAccessor = SandBoxAccessor.shared
    
    //icloud数据查询对象
    fileprivate lazy var fileQuery: NSMetadataQuery = {
        let query = NSMetadataQuery()
        query.searchScopes = [NSMetadataQueryUbiquitousDocumentsScope]      //默认搜索icloud的Documents目录
        query.notificationBatchingInterval = nt_request_timeoutInterval
        NotificationCenter.default.addObserver(self, selector: #selector(fileQueryFinished(notification:)), name: NSNotification.Name.NSMetadataQueryDidFinishGathering, object: query)
        NotificationCenter.default.addObserver(self, selector: #selector(fileQueryFinished(notification:)), name: NSNotification.Name.NSMetadataQueryDidUpdate, object: query)
        return query
    }()
    
    //当发起一次query documents后的回调，返回查询结果，是个数组，可以同时发起多次查询
    fileprivate lazy var queryDocumentsCallbacks: [(([IADocumentResultModel]) -> Void)] = []
    
    
    //MARK: 方法
    //私有化初始化方法
    private override init()
    {
        super.init()
        //判断icloud是否有Documents文件夹，如果不存在则创建
        initContainer()
        addNotification()
    }
    
    override func copy() -> Any
    {
        return self
    }
    
    override func mutableCopy() -> Any
    {
        return self
    }
    
    //初始化iCloud文件夹， 主要是初始化Documents文件夹
    fileprivate func initContainer()
    {
        //先判断Documents文件夹是否存在       //创建根目录下临时文件路径
        if let documentPath = getDocumentsDir()?.path, let metaUrl = getDir()?.appendingPathComponent(iCloudAdapter.metaFileName)
        {
            //不存在则创建，因为Documents是系统默认文件夹，所以不能手动创建，可以通过在iCloud根目录下保存一个文件来让系统自动创建，创建完成后在把这个文件删除
            if !sbMgr.isExist(documentPath)
            {
                do {
                    //写入一个空格字符串
                    try String.sSpace.write(to: metaUrl, atomically: true, encoding: .utf8)
                    FSLog("create iCloud Documents success")
                } catch {
                    FSLog("create iCloud Documents failure")
                }
            }
            else    //如果存在Documents文件夹，则删除`meta.data`临时文件，如果有的话
            {
                if sbMgr.isExist(metaUrl.path)
                {
                    do {
                        try fileMgr.removeItem(at: metaUrl)
                        FSLog("delete meta.dat success")
                    } catch {
                        FSLog("delete meta.dat failure")
                    }
                }
            }
        }
    }
    
    fileprivate func addNotification()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(iCloudAdapterDidReceiveValueChangeNotification(notification:)), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: nil)
    }

}


//通知代理
extension iCloudAdapter: DelegateProtocol
{
    //收到icloud value变化的通知
    @objc func iCloudAdapterDidReceiveValueChangeNotification(notification: Notification)
    {
        if let userInfo = notification.userInfo
        {
            let reason = userInfo[NSUbiquitousKeyValueStoreChangeReasonKey] as! Int
            let keys = userInfo[NSUbiquitousKeyValueStoreChangedKeysKey] as! [String]
            for key in keys {
                //只应该出现预先设定的key
                let keyE = IAValueKey(rawValue: key)
                let value = keyE?.getValue()
                let obj = IAValueChangeModel(key: keyE!, value: value, changeReasion: IAValueChangeReason(rawValue: reason))
                NotificationCenter.default.post(name: FSNotification.iCloudValueChange.name, object: [FSNotification.iCloudValueChange.paramKey: obj])
            }
        }
    }
    
    //fileQuery查询或获取更新完毕
    @objc func fileQueryFinished(notification: Notification)
    {
        fileQuery.stop()
        var fileArray: [IADocumentResultModel] = []
        for item in fileQuery.results
        {
            let it = item as! NSMetadataItem
            let st = IADocumentResultModel.init(info: it)
            fileArray.append(st)
        }
        for cb in queryDocumentsCallbacks
        {
            cb(fileArray)
        }
        //完毕之后，清理回调
        queryDocumentsCallbacks.removeAll()
    }
    
}


//内部类型
extension iCloudAdapter: InternalType
{
    ///iCloud存储容器id，根据实际配置修改
    static let iCloudIdentifier = "iCloud.FrameworkStruct"
    
    ///用于创建Documents的临时文件名
    fileprivate static let metaFileName = "meta.dat"
    
    ///icloud目录搜索范围
    enum IASearchScope {
        case root               //icloud根目录icloud，并且除去Documents目录
        case documents          //icloud Documents目录
        case rootAndDocuments   //icloud根目录和Documents目录
        case external           //在此App沙盒之外不可用户交互的可获取的文件
        
        //获得搜索范围的值
        func getScope() -> [String]
        {
            switch self {
            case .root:
                return [NSMetadataQueryUbiquitousDataScope]
            case .documents:
                return [NSMetadataQueryUbiquitousDocumentsScope]
            case .rootAndDocuments:
                return [NSMetadataQueryUbiquitousDataScope, NSMetadataQueryUbiquitousDocumentsScope]
            case .external: //不明所以，先写上
                return [NSMetadataQueryAccessibleUbiquitousExternalDocumentsScope]
            }
        }
    }

}


//接口方法
extension iCloudAdapter: ExternalInterface
{
    /**************************************** key-value存储 Section Begin ***************************************/
    ///向icloud保存一个值
    func saveValue(_ value: Any, key: IAValueKey)
    {
        kvMgr.set(value, forKey: key.rawValue)
        kvMgr.synchronize()
    }
    
    ///获取icloud中所有的key-value
    func getAllKeyValues() -> [String: Any]
    {
        kvMgr.dictionaryRepresentation
    }
    
    ///从icloud读取一个值
    func getValue(_ key: IAValueKey) -> Any?
    {
        kvMgr.object(forKey: key.rawValue)
    }
    
    func getString(_ key: IAValueKey) -> String?
    {
        kvMgr.string(forKey: key.rawValue)
    }
    
    func getBool(_ key: IAValueKey) -> Bool?
    {
        guard let value = getValue(key) as? Bool else {
            return nil
        }
        
        return value
    }
    
    func getDouble(_ key: IAValueKey) -> Double?
    {
        guard let value = getValue(key) as? Double else {
            return nil
        }
        
        return value
    }
    
    func getInt(_ key: IAValueKey) -> Int?
    {
        guard let value = getValue(key) as? Int else {
            return nil
        }
        
        return value
    }
    
    func getLonglong(_ key: IAValueKey) -> Int64?
    {
        guard let value = getValue(key) as? Int64 else {
            return nil
        }
        
        return value
    }
    
    func getData(_ key: IAValueKey) -> Data?
    {
        kvMgr.data(forKey: key.rawValue)
    }
    
    func getArray(_ key: IAValueKey) -> [Any]?
    {
        kvMgr.array(forKey: key.rawValue)
    }
    
    func getDict(_ key: IAValueKey) -> [String: Any]?
    {
        kvMgr.dictionary(forKey: key.rawValue)
    }
    
    ///删除icloud上的一个值
    func deleteValue(_ key: IAValueKey)
    {
        kvMgr.removeObject(forKey: key.rawValue)
    }
    
    ///删除icloud上所有值
    func deleteAllValues()
    {
        for key in IAValueKey.allCases
        {
            deleteValue(key)
        }
    }
    /**************************************** key-value存储 Section End ***************************************/
    
    /**************************************** document存储 Section Begin ***************************************/
    ///设置icloud目录搜索范围
    func setSearchScope(_ scope: IASearchScope)
    {
        self.fileQuery.searchScopes = scope.getScope()
    }
    
    ///获取icloud对应container根目录或者子目录路径，如果目录不存在则创建，不能创建根目录，不能创建`Documents`目录，因为这是系统目录，用户没有权限修改
    ///请确保是目录，而非文件
    ///参数：
    ///path：子目录路径，不传则返回根目录；identifier：icloud容器id，可配置多个容器
    func getDir(_ path: IADocumentDir? = nil, identifier: String = iCloudIdentifier) -> URL?
    {
        var dirUrl: URL? = nil
        if let url = fileMgr.url(forUbiquityContainerIdentifier: identifier)
        {
            dirUrl = url
            if let path = path {
                if let fullUrl = dirUrl?.appendingPathComponent(path.rawValue)
                {
                    dirUrl = fullUrl
                }
            }
            //如果目录不存在则创建，不能创建根目录和Documents目录
            if let urlStr = dirUrl?.path, !sbMgr.isExist(urlStr), path != nil, path != .Documents
            {
                //创建失败则返回nil
                if !sbMgr.createDir(urlStr)
                {
                    dirUrl = nil
                }
            }
        }
        
        return dirUrl
    }
    
    ///获取iCloud Documents目录
    func getDocumentsDir(identifier: String = iCloudIdentifier) -> URL?
    {
        getDir(.Documents, identifier: identifier)
    }
    
    ///查询icloud文件信息
    func queryDocuments(_ callback: @escaping ([IADocumentResultModel]) -> Void)
    {
        self.queryDocumentsCallbacks.append(callback)
        if !self.fileQuery.isStarted || self.fileQuery.isStopped    //如果还未开始查询，那么开始查询
        {
            self.fileQuery.start()
        }
    }
    
    ///将数据写入iCloud文件
    ///参数：
    ///data：要保存的数据；
    ///targetUrl：要保存文件的icloud路径，可能包含文件名；
    ///fileName：icloud上的文件名，包含扩展名，如果targetUrl没有包含文件名，在这个参数中传入
    func write(_ data: Data, targetUrl: URL, fileName: String? = nil)
    {
        
    }
    
    ///将本地文件写入icloud中
    ///参数：
    ///fileUrl：本地文件路径；
    ///targetUrl：icloud上的目标文件路径；
    ///fileName：如果传这个参数表示前面的两个参数都不包含文件名和扩展名，用这个参数拼接
    func write(_ sourceUrl: URL, targetUrl: URL, fileName: String? = nil)
    {
        
    }
    
    
    
    /**************************************** document存储 Section End ***************************************/
    
}
