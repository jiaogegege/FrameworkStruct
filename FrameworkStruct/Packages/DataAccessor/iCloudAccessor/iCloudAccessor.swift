//
//  iCloudAccessor.swift
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


class iCloudAccessor: OriginAccessor {
    //MARK: 属性
    //单例
    static let shared = iCloudAccessor()
    
    //key-value存储管理器
    fileprivate(set) lazy var kvMgr: NSUbiquitousKeyValueStore = NSUbiquitousKeyValueStore.default
    
    //FileManager
    fileprivate lazy var fileMgr: FileManager = FileManager.default
    
    //沙盒存取器
    fileprivate lazy var sbMgr: SandBoxAccessor = SandBoxAccessor.shared
    
    //icloud文件查询器
    fileprivate lazy var fileQuery: NSMetadataQuery = {
        let query = NSMetadataQuery()
        query.searchScopes = [NSMetadataQueryUbiquitousDocumentsScope]      //默认搜索icloud的Documents目录
        query.notificationBatchingInterval = nt_request_timeoutInterval
        NotificationCenter.default.addObserver(self, selector: #selector(fileQueryFinished(notification:)), name: NSNotification.Name.NSMetadataQueryDidFinishGathering, object: query)
        NotificationCenter.default.addObserver(self, selector: #selector(fileQueryFinished(notification:)), name: NSNotification.Name.NSMetadataQueryDidUpdate, object: query)
        return query
    }()
    
    ///搜索结果排序规则
    fileprivate(set) var querySort: IASearchResultSort?
    
    //当发起一次query documents后的回调，返回查询结果，是个数组，可以同时发起多次查询
    fileprivate lazy var queryDocumentsCallbacks: [(([IADocumentSearchResult]) -> Void)] = []
    
    //正在操作的文件句柄dict
    fileprivate var handledFiles: [IADocumentHandlerType: iCloudDocument] = [:]
    
    
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
        if let documentPath = getDocumentsDir()?.path, let metaUrl = getDir()?.appendingPathComponent(iCloudAccessor.metaFileName)
        {
            //不存在则创建，因为Documents是系统默认文件夹，所以不能手动创建，可以通过在iCloud根目录下保存一个文件来让系统自动创建，创建完成后在把这个文件删除
            if !sbMgr.isExist(documentPath)
            {
                do {
                    //写入一个空格字符串
                    try String.sSpace.write(to: metaUrl, atomically: true, encoding: .utf8)
//                    FSLog("create iCloud Documents success")
                } catch {
                    FSLog("create iCloud Documents failure: \(error.localizedDescription)")
                }
            }
            else    //如果存在Documents文件夹，则删除`meta.data`临时文件，如果有的话
            {
                if sbMgr.isExist(metaUrl.path)
                {
                    do {
                        try fileMgr.removeItem(at: metaUrl)
//                        FSLog("delete meta.dat success")
                    } catch {
                        FSLog("delete meta.dat failure: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    fileprivate func addNotification()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(iCloudAdapterDidReceiveValueChangeNotification(notification:)), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: nil)
    }
    
    ///生成一个文件id作为key
    fileprivate func generateFileId(fileUrl: URL) -> IADocumentHandlerType
    {
        g_identifier(fileUrl.absoluteString)
    }

}


//通知代理
extension iCloudAccessor: DelegateProtocol
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
        var fileArray: [IADocumentSearchResult] = []
        for item in fileQuery.results
        {
            let it = item as! NSMetadataItem
            let st = IADocumentSearchResult.init(info: it)
            fileArray.append(st)
        }
        //排序
        if let sort = querySort
        {
            fileArray.sort { (lhs, rhs) in
                sort.compare(lhs: lhs, rhs: rhs)
            }
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
extension iCloudAccessor: InternalType
{
    ///iCloud存储容器id，根据实际配置修改
    enum iCloudContainerIdentifier: String {
        case frameworkStruct = "iCloud.FrameworkStruct"
    }
    
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
    
    ///搜索结果排序规则，绑定的值是是否升序，更多排序规则根据实际需求添加
    enum IASearchResultSort {
        case name(Bool)
        case createDate(Bool)
        case changeDate(Bool)
        
        //返回排序结果
        func compare(lhs: IADocumentSearchResult, rhs: IADocumentSearchResult) -> Bool
        {
            switch self {
            case .name(let bool):
                return bool ? lhs.name < rhs.name : lhs.name > rhs.name
            case .createDate(let bool):
                return bool ? lhs.createDate < rhs.createDate : lhs.createDate > rhs.createDate
            case .changeDate(let bool):
                return bool ? lhs.changeDate < rhs.changeDate : lhs.changeDate > rhs.changeDate
            }
        }
    }
    
    ///正在操作的文件句柄类型
    typealias IADocumentHandlerType = String

}


//接口方法
extension iCloudAccessor: ExternalInterface
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
    
    ///设置搜索结果过滤条件
    ///参数：type：要过滤的类型；opposite：是否取反，如果为true，那么type中的类型会被去除，否则只保留type中指定的类型
    func setFilter(_ types: [FMUTIs], opposite: Bool = false)
    {
        var predicateStr: PredicateExpression = ""
        for type in types {
            //"(kMDItemContentType != 'com.apple.mail.emlx') && (kMDItemContentType != 'public.vcard')"
            //[NSPredicate predicateWithFormat:@"(%K == %@)", NSMetadataItemContentTypeKey, whatToFilter]
            if g_validString(predicateStr)  //如果已经有内容了，那么追加` && `
            {
                predicateStr.append(String(format: " %@ ", opposite ? "&&" : "||"))
            }
            //拼接过滤条件
            predicateStr.append(String(format: "(kMDItemContentType %@ '%@')", (opposite ? "!=" : "=="), type.rawValue))
        }
        self.fileQuery.predicate = NSPredicate(format: predicateStr)
    }
    
    ///设置排序规则
    func setSort(type: IASearchResultSort)
    {
        self.querySort = type
    }
    
    ///获取icloud对应container根目录或者子目录路径，如果目录不存在则创建，不能创建根目录，不能创建`Documents`目录，因为这是系统目录，用户没有权限修改
    ///请确保是目录，而非文件
    ///参数：
    ///path：子目录路径，不传则返回根目录；identifier：icloud容器id，可配置多个容器
    func getDir(_ path: IADocumentDir? = nil, identifier: iCloudContainerIdentifier = .frameworkStruct) -> URL?
    {
        var dirUrl: URL? = nil
        if let url = fileMgr.url(forUbiquityContainerIdentifier: identifier.rawValue)
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
    func getDocumentsDir(identifier: iCloudContainerIdentifier = .frameworkStruct) -> URL?
    {
        getDir(.Documents, identifier: identifier)
    }
    
    ///获取icloud下`Documents/Data`目录
    func getDataDir(identifier: iCloudContainerIdentifier = .frameworkStruct) -> URL?
    {
        getDir(.data, identifier: identifier)
    }
    
    ///获取icloud下的某个目录下的某个文件的路径，fileName：包括扩展名
    func getFileUrl(in dir: URL, fileName: String) -> URL
    {
        dir.appendingPathComponent(fileName)
    }
    
    ///查询icloud文件信息
    func queryDocuments(_ callback: @escaping ([IADocumentSearchResult]) -> Void)
    {
        self.queryDocumentsCallbacks.append(callback)
        if !self.fileQuery.isStarted || self.fileQuery.isStopped    //如果还未开始查询，那么开始查询
        {
            self.fileQuery.start()
        }
    }
    
    ///在iCloud中创建一个文件并传入数据，没有数据为什么要创建文件呢
    func createDocument(_ data: Data, targetUrl: URL, fileName: String? = nil, completion: BoolClosure? = nil)
    {
        //组装fileUrl
        var fileUrl = targetUrl
        if let fileName = fileName {
            fileUrl = fileUrl.appendingPathComponent(fileName)
        }
        let document = iCloudDocument(fileURL: fileUrl)
        document.data = data
        document.save(to: fileUrl, for: .forOverwriting) {[weak document] isSuccess in
            if let cb = completion
            {
                cb(isSuccess)
            }
            //创建完毕后关闭文件
            document?.close()
        }
    }
    
    ///打开一个文件，返回文件句柄，失败返回nil
    func openDocument(_ fileUrl: URL, completion: @escaping ((IADocumentHandlerType?) -> Void))
    {
        let document = iCloudDocument(fileURL: fileUrl)
        let id = generateFileId(fileUrl: fileUrl)
        handledFiles[id] = document
        document.open {[weak self, weak document] success in
            //打开成功
            if success
            {
                completion(id)
            }
            else
            {
                //关闭文件
                document?.close()
                self?.handledFiles.removeValue(forKey: id)
                completion(nil)
            }
        }
    }
    
    ///读取文件内容
    func readDocument(_ id: IADocumentHandlerType) -> Data?
    {
        guard let document = handledFiles[id] else {
            return nil
        }
        
        return document.data
    }
    
    ///将数据写入iCloud文件
    ///参数：
    ///id：要保存的文件id
    ///data：要保存的数据；
    func writeDocument(_ id: IADocumentHandlerType, data: Data, completion: BoolClosure? = nil)
    {
        if let document = handledFiles[id]
        {
            document.data = data
            document.save(to: document.fileURL, for: .forOverwriting) { success in
                if let cb = completion
                {
                    cb(success)
                }
            }
        }
        else
        {
            if let cb = completion
            {
                cb(false)
            }
        }
    }
    
    ///关闭文件
    func closeDocument(_ id: IADocumentHandlerType, completion: BoolClosure? = nil)
    {
        if let document = handledFiles[id]
        {
            document.close {[weak self] success in
                self?.handledFiles.removeValue(forKey: id)
                if let cb = completion
                {
                    cb(success)
                }
            }
        }
        else
        {
            if let cb = completion
            {
                cb(false)
            }
        }
    }
    
    ///将本地文件复制到icloud中，通常用于备份本地文件到icloud
    ///参数：
    ///sourcePath：本地文件路径；
    ///targetUrl：icloud上的目标文件路径；
    ///fileName：如果传这个参数表示前面的两个参数都不包含文件名和扩展名，用这个参数拼接
    func copyDocument(_ sourcePath: String, targetUrl: URL, fileName: String? = nil, completion: BoolClosure? = nil)
    {
        var source = sourcePath
        var target = targetUrl
        //处理文件路径
        if let fn = fileName
        {
            if !source.hasSuffix(fn)
            {
                source = (source as NSString).appendingPathComponent(fn)
            }
            if !target.path.hasSuffix(fn)
            {
                target = target.appendingPathComponent(fn)
            }
        }
        //读写文件较慢，所以异步操作
        let currentQueue = OperationQueue.current?.underlyingQueue  //记录当前queue
        g_async(onMain: false) {
            //读取本地文件data
            if let data = self.fileMgr.contents(atPath: source)
            {
                //写入icloud文件
                let document = iCloudDocument(fileURL: target)
                document.data = data
                document.save(to: target, for: .forOverwriting) {[weak document] success in
                    var queue: DispatchQueue = .main
                    if let currentQueue = currentQueue {
                        queue = currentQueue
                    }
                    queue.async {
                        //保存完成后关闭文件
                        document?.close()
                        if let cb = completion
                        {
                            cb(success)
                        }
                    }
                }
            }
        }
    }
    
    ///删除一个icloud上的文件
    func deleteDocument(_ fileUrl: URL, completion: OptionalErrorClosure? = nil)
    {
        do {
            try fileMgr.removeItem(at: fileUrl)
            if let cb = completion
            {
                cb(nil)
            }
        } catch {
            if let cb = completion
            {
                cb(error)
            }
        }
    }

    
    /**************************************** document存储 Section End ***************************************/
    
}
