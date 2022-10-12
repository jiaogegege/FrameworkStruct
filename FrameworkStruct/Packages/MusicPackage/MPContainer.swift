//
//  MPContainer.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/10/7.
//

/**
 音乐数据容器
 */
import UIKit


extension FSNotification
{
    //媒体库初始化完成的通知
    static let mpContainerInitFinished = FSNotification(value: "mpContainerInitFinished")
    //媒体库更新完成的通知
    static let mpContainerUpdated = FSNotification(value: "mpContainerUpdated")
}

class MPContainer: OriginContainer
{
    //MARK: 属性
    //单例
    static let shared = MPContainer()
    
    //icloud存取器
    fileprivate lazy var ia: iCloudAccessor = {
        let ia = iCloudAccessor.shared
        return ia
    }()
    
    //音乐库文件目录
    fileprivate lazy var libDir: URL? = ia.getMusicLibrary()

    
    //MARK: 方法
    //私有化初始化方法
    private override init()
    {
        super.init()
        self.addNotification()
        self.initLibrarys()
    }
    
    override func copy() -> Any
    {
        return self
    }
    
    override func mutableCopy() -> Any
    {
        return self
    }
    
    //添加通知
    fileprivate func addNotification()
    {
        //监听app active
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActiveNotification(notification:)), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    //初始化媒体库列表
    //参数：是否是更新操作
    fileprivate func initLibrarys(isUpdate: Bool = false)
    {
        //尝试获取保存在icloud上的媒体库文件，包含一个媒体库列表
        if let libDir = self.libDir
        {
            let libFileUrl = ia.getFileUrl(in: libDir, fileName: Self.libraryFileName)
            //尝试打开媒体库文件，如果失败则创建一个新的；如果媒体库文件在iCloud中没有下载到本地则打开失败
            //不能通过FileManager判断媒体库文件是否存在，因为如果没有下载到本地会返回false，但是实际存在iCloud上
            ia.openDocument(libFileUrl) {[weak self] handler in
                if let had = handler
                {
                    //读取文件
                    if let data = self?.ia.readDocument(had)
                    {
                        //序列化data为MPMediaLibraryModel数组
                        if let libs = ArchiverAdatper.shared.unarchive(data) as? [MPMediaLibraryModel]
                        {
                            //更新媒体库，目前只有iCloud
                            self?.updateLibrarys(libs, completion: { (newLibs, hasUpdate) in
                                //媒体库更新完成后，保存到container中
                                self?.mutate(key: MPDataKey.librarys, value: newLibs)
                                //如果有数据更新，那么需要更新iCloud库文件
                                if hasUpdate
                                {
                                    if let data = ArchiverAdatper.shared.archive(newLibs as NSCoding)
                                    {
                                        self?.ia.writeDocument(had, data: data, completion: { success in
                                            //关闭文件
                                            self?.ia.closeDocument(had)
                                            NotificationCenter.default.post(name: isUpdate ? FSNotification.mpContainerUpdated.name : FSNotification.mpContainerInitFinished.name, object: nil)
                                        })
                                    }
                                }
                                else    //如果没有数据更新
                                {
                                    //发出通知
                                    NotificationCenter.default.post(name: isUpdate ? FSNotification.mpContainerUpdated.name : FSNotification.mpContainerInitFinished.name, object: nil)
                                }
                            })
                        }
                    }
                }
                else    //如果文件打开失败，则创建一个新的
                {
                    self?.createLibrarys(libFileUrl)
                }
            }
        }
    }
    
    //创建一个新的媒体库
    fileprivate func createLibrarys(_ libFileUrl: URL)
    {
        //先删除旧文件，如果有的话
        ia.deleteDocument(libFileUrl) {[weak self] error in
            //不管是否删除成功都创建新的
            self?.queryAlliCloudSongs { songs in
                //创建一个iCloud媒体库
                let iCloudLib = MPMediaLibraryModel(type: .iCloud, songs: songs, albums: [], artists: [], lyrics: [], musicbooks: [])
                self?.mutate(key: MPDataKey.librarys, value: [iCloudLib])
                //写入iCloud文件
                if let data = ArchiverAdatper.shared.archive([iCloudLib] as NSCoding)
                {
                    self?.ia.createDocument(data, targetUrl: libFileUrl)
                    NotificationCenter.default.post(name: FSNotification.mpContainerInitFinished.name, object: nil)
                }
            }
        }
    }
    
    //update媒体库中的媒体，比如iCloud中有了新的歌曲，需要更新到媒体库中
    //目前只更新iCloud媒体库
    //返回值：(新的媒体库列表, 是否有数据更新)
    fileprivate func updateLibrarys(_ originLibs: [MPMediaLibraryModel], completion: @escaping (([MPMediaLibraryModel], Bool) -> Void))
    {
        for lib in originLibs {
            if lib.type == .iCloud
            {
                //查询所有iCloud中的歌曲
                self.queryAlliCloudSongs { songs in
                    //有新增歌曲则增加，有删除歌曲则减少
                    let hasUpdate = lib.diffSongs(songs)
                    g_async {
                        completion(originLibs, hasUpdate)
                    }
                }
            }
        }
    }
    
    //获取某一个媒体库
    fileprivate func getLibrary(_ type: MPLibraryType) -> MPMediaLibraryModel?
    {
        if let libs = self.get(key: MPDataKey.librarys) as? [MPMediaLibraryModel]
        {
            for lib in libs {
                if lib.type == type
                {
                    return lib
                }
            }
        }
        
        return nil
    }
    
    ///查询所有iCloud中的歌曲
    fileprivate func queryAlliCloudSongs(completion: @escaping ([MPSongModel]) -> Void)
    {
        ia.setFilter(files: FMUTIs.audioGroup, dirs: [.Music])
        ia.queryDocuments { files in
            let songs = files.map { file in
                MPSongModel(name: file.displayName, url: file.url)
            }
            completion(songs)
        }
    }
    
    //在iCloud中创建一个新文件，返回是否创建成功
    fileprivate func createFileIniCloud(_ data: Data, fileName: String, completion: @escaping (Bool) -> Void)
    {
        if let libDir = self.libDir
        {
            let fileUrl = ia.getFileUrl(in: libDir, fileName: fileName)
            ia.createDocument(data, targetUrl: fileUrl) { success in
                completion(success)
            }
        }
        else    //不存在库文件，比如模拟器，返回nil
        {
            completion(false)
        }
    }
    
    //从iCloud中打开一个文件，返回文件handler
    fileprivate func openFileFromiCloud(_ fileName: String, completion: @escaping (iCloudAccessor.IADocumentHandlerType?) -> Void)
    {
        if let libDir = self.libDir
        {
            let fileUrl = ia.getFileUrl(in: libDir, fileName: fileName)
            ia.openDocument(fileUrl) { fileId in
                completion(fileId)
            }
        }
        else    //不存在库文件，比如模拟器，返回nil
        {
            completion(nil)
        }
    }
    
    //从iCloud中读取一个文件，返回data
    fileprivate func readFileFromiCloud(_ fileName: String, completion: @escaping (Data?) -> Void)
    {
        if let libDir = self.libDir
        {
            let fileUrl = ia.getFileUrl(in: libDir, fileName: fileName)
            ia.openDocument(fileUrl) { [weak self] fileId in
                if let id = fileId
                {
                    //读取文件
                    if let data = self?.ia.readDocument(id)
                    {
                        completion(data)
                    }
                    else    //读取文件失败
                    {
                        completion(nil)
                    }
                }
                else    //打开文件失败，返回nil
                {
                    completion(nil)
                }
            }
        }
        else    //不存在库文件，比如模拟器，返回nil
        {
            completion(nil)
        }
    }
    
    //提交到iCloud
    override func commit(key: AnyHashable, value: Any, success: (Any?) -> Void, failure: (NSError) -> Void) {
        
    }
    
}


//通知代理
extension MPContainer: DelegateProtocol
{
    //app已经获得焦点，刷新媒体库
    @objc func applicationDidBecomeActiveNotification(notification: Notification)
    {
        self.initLibrarys(isUpdate: true)
    }
    
}


//内部类型
extension MPContainer: InternalType
{
    ///保存在icloud上的文件名
    //媒体库文件，媒体库对象列表，以`mplib`结尾
    static let libraryFileName = "library.dat"
    //当前播放歌曲文件
    static let currentSongFileName = "currentSong.dat"
    //当前播放列表文件
    static let currentPlaylistFileName = "currentPlaylist.dat"
    //历史播放歌曲列表文件
    static let historySongsFileName = "historySongs.dat"
    //历史播放列表列表文件
    static let historyPlaylistsFileName = "historyPlaylists.dat"
 
    //数据对象的key
    enum MPDataKey: String {
        case librarys                       //媒体库列表
        
        case currentSong                    //当前播放歌曲
        case currentPlaylist                //当前播放列表
        case historySongs                   //历史播放歌曲
        case historyPlaylists               //历史播放列表
        
        //获取key对应的在iCloud中的文件名
        func getiCloudFileName() -> String
        {
            switch self {
            case .librarys:
                return MPContainer.libraryFileName
            case .currentSong:
                return MPContainer.currentSongFileName
            case .currentPlaylist:
                return MPContainer.currentPlaylistFileName
            case .historySongs:
                return MPContainer.historySongsFileName
            case .historyPlaylists:
                return MPContainer.historyPlaylistsFileName
            }
        }
    }
    
}


//外部接口
extension MPContainer: ExternalInterface
{
    ///修改，value必须是NSCoding；key必须是MPDataKey
    ///先保存缓存，然后保存到iCloud
    override func mutate(key: AnyHashable, value: Any, meta: DataModelMeta = DataModelMeta())
    {
        //先保存到缓存
        super.mutate(key: key, value: value, meta: meta)
        
        //写入iCloud文件，如果acrhive失败，什么都不做
        if let k = key as? MPDataKey, let val = value as? NSCoding, let data = ArchiverAdatper.shared.archive(val)
        {
            let fileName = k.getiCloudFileName()
            //尝试打开文件
            openFileFromiCloud(fileName) {[weak self] fileId in
                if let fileId = fileId {
                    //修改文件
                    self?.ia.writeDocument(fileId, data: data, completion: { success in
//                        FSLog("write icloud file \(success) : \(fileName)")
                    })
                }
                else    //创建一个新文件
                {
                    self?.createFileIniCloud(data, fileName: fileName, completion: { success in
                        FSLog("create icloud file \(success) : \(fileName)")
                    })
                }
            }
        }
    }
    
    ///获取所有库
    func getLibrarys(_ completion: @escaping (([MPMediaLibraryModel]?) -> Void))
    {
        if let libs = self.get(key: MPDataKey.librarys) as? [MPMediaLibraryModel]
        {
            completion(libs)
        }
        else
        {
            completion(nil)
        }
    }
    
    ///获取iCloud库
    func getiCloudLibrary(_ completion: @escaping ((MPMediaLibraryModel?) -> Void))
    {
        if let libs = self.get(key: MPDataKey.librarys) as? [MPMediaLibraryModel]
        {
            for lib in libs
            {
                if lib.type == .iCloud
                {
                    completion(lib)
                    return
                }
            }
        }
        else
        {
            completion(nil)
        }
    }
    
    ///获取当前播放歌曲
    func getCurrentSong(_ completion: @escaping (MPSongModel?) -> Void)
    {
        if let song = self.get(key: MPDataKey.currentSong) as? MPSongModel
        {
            completion(song)
        }
        else    //如果缓存中没有，那么尝试从iCloud获取
        {
            readFileFromiCloud(Self.currentSongFileName) {[weak self] data in
                if let data = data {
                    if let song = MPSongModel.unarchive(data)
                    {
                        //先保存到缓存
                        self?.mutate(key: MPDataKey.currentSong, value: song)
                        //返回song
                        completion(song)
                    }
                    else
                    {
                        completion(nil)
                    }
                }
                else
                {
                    completion(nil)
                }
            }
        }
    }
    
    ///获取当前播放列表
    func getCurrentPlaylist(_ completion: @escaping (MPPlaylistModel?) -> Void)
    {
        if let playlist = self.get(key: MPDataKey.currentPlaylist) as? MPPlaylistModel
        {
            completion(playlist)
        }
        else    //如果缓存中没有，那么尝试从iCloud获取
        {
            readFileFromiCloud(Self.currentPlaylistFileName) { [weak self] data in
                if let data = data {
                    if let playlist = MPPlaylistModel.unarchive(data)
                    {
                        self?.mutate(key: MPDataKey.currentPlaylist, value: playlist)
                        completion(playlist)
                    }
                    else
                    {
                        completion(nil)
                    }
                }
                else
                {
                    completion(nil)
                }
            }
        }
    }
    
    ///获取历史播放歌曲列表
    func getHistorySongs(_ completion: @escaping (MPHistorySongModel?) -> Void)
    {
        if let playlist = self.get(key: MPDataKey.historySongs) as? MPHistorySongModel
        {
            completion(playlist)
        }
        else    //如果缓存中没有，那么尝试从iCloud获取
        {
            readFileFromiCloud(Self.historySongsFileName) { [weak self] data in
                if let data = data {
                    if let playlist = MPHistorySongModel.unarchive(data)
                    {
                        self?.mutate(key: MPDataKey.historySongs, value: playlist)
                        completion(playlist)
                    }
                    else
                    {
                        completion(nil)
                    }
                }
                else
                {
                    completion(nil)
                }
            }
        }
    }
    
    ///获取历史播放列表列表
    func getHistoryPlaylists(_ completion: @escaping ([MPHistoryPlaylistModel]?) -> Void)
    {
        if let playlists = self.get(key: MPDataKey.historyPlaylists) as? [MPHistoryPlaylistModel]
        {
            completion(playlists)
        }
        else    //如果缓存中没有，那么尝试从iCloud获取
        {
            readFileFromiCloud(Self.historyPlaylistsFileName) { [weak self] data in
                if let data = data {
                    if let playlists = ArchiverAdatper.shared.unarchive(data) as? [MPHistoryPlaylistModel]
                    {
                        self?.mutate(key: MPDataKey.historyPlaylists, value: playlists)
                        completion(playlists)
                    }
                    else
                    {
                        completion(nil)
                    }
                }
                else
                {
                    completion(nil)
                }
            }
        }
    }
    
    
    
    
    
    
}
