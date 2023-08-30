//
//  MPContainer.swift
//  FrameworkStruct
//
//  Created by jggg on 2022/10/7.
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
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActiveNotification(notification:)), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    //初始化媒体库列表，包括所有的来源：本地/iCloud/其他，目前只有iCloud
    fileprivate func initLibrarys()
    {
        g_async { queue in
            //尝试获取保存在icloud上的媒体库文件，包含一个媒体库列表
            if let libDir = self.libDir
            {
                let libFileUrl = self.ia.getFileUrl(in: libDir, fileName: Self.libraryFileName)
                //尝试打开媒体库文件，如果失败则创建一个新的；如果媒体库文件在iCloud中没有下载到本地则打开失败
                //不能通过FileManager判断媒体库文件是否存在，因为如果没有下载到本地会返回false，但是实际存在iCloud上
                self.ia.openDocument(libFileUrl) {[weak self] handler in
                    if let had = handler
                    {
                        //读取文件
                        if let data = self?.ia.readDocument(had)
                        {
                            //序列化data为MPMediaLibraryModel数组
                            ArchiverAdapter.shared.unarchive(data) { (obj) in
                                if let libs = obj as? [MPMediaLibraryModel]
                                {
                                    //读取文件后先保存到缓存中
                                    self?.mutate(key: MPDataKey.librarys, value: libs, meta: DataModelMeta(needCopy: false, canCommit: true))
                                    //关闭文件
                                    self?.ia.closeDocument(had, completion: { succeed in
                                        queue.async {
                                            //发出初始化完成的通知
                                            NotificationCenter.default.post(name: FSNotification.mpContainerInitFinished.name, object: nil)
                                        }
                                        //尝试更新媒体库，目前只有iCloud
                                        self?.updateLibrarys()
                                    })
                                }
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
    }
    
    //创建一个新的媒体库
    fileprivate func createLibrarys(_ libFileUrl: URL)
    {
        g_async { queue in
            //先删除旧文件，如果有的话
            self.ia.deleteDocument(libFileUrl) {[weak self] error in
                //不管是否删除成功都创建新的
                self?.queryAlliCloudSongs { songs in
                    //创建一个iCloud媒体库
                    let iCloudLib = MPMediaLibraryModel(type: .iCloud, songs: songs, albums: [], artists: [], lyrics: [], musicbooks: [])
                    self?.mutate(key: MPDataKey.librarys, value: [iCloudLib], meta: DataModelMeta(needCopy: false, canCommit: true))
                    //写入iCloud文件
                    ArchiverAdapter.shared.archive([iCloudLib] as NSCoding) { (data) in
                        if let data = data {
                            self?.ia.createDocument(data, targetUrl: libFileUrl)
                            queue.async {
                                NotificationCenter.default.post(name: FSNotification.mpContainerInitFinished.name, object: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    //update媒体库中的媒体，比如iCloud中有了新的歌曲，需要更新到媒体库中
    //目前只更新iCloud媒体库
    //参数：originLibs：本地库列表；handler：打开的本地库文件句柄
    fileprivate func updateLibrarys()
    {
        g_async { queue in
            self.getLibrarys { (libs) in
                if let libs = libs {
                    for lib in libs {
                        if lib.type == .iCloud
                        {
                            //查询所有iCloud中的歌曲
                            self.queryAlliCloudSongs {[weak self] songs in
                                g_async(onMain: false) {
                                    //有新增歌曲则增加，有删除歌曲则减少
                                    let hasUpdate = lib.diffSongs(songs)
                                    //读取文件后先保存到缓存中
                                    self?.mutate(key: MPDataKey.librarys, value: libs, meta: DataModelMeta(needCopy: false, canCommit: true))
                                    //如果有数据更新，那么需要更新iCloud库文件
                                    if hasUpdate, let libDir = self?.libDir, let libFileUrl = self?.ia.getFileUrl(in: libDir, fileName: Self.libraryFileName)
                                    {
                                        ArchiverAdapter.shared.archive(libs as NSCoding) { (data) in
                                            if let data = data {
                                                self?.ia.openDocument(libFileUrl, completion: { (handler) in
                                                    if let had = handler
                                                    {
                                                        self?.ia.writeDocument(had, data: data, completion: { success in
                                                            //关闭文件
                                                            self?.ia.closeDocument(had, completion: { succeed in
                                                                //读取文件后先保存到缓存中
                                                                self?.mutate(key: MPDataKey.librarys, value: libs, meta: DataModelMeta(needCopy: false, canCommit: true))
                                                                queue.async {
                                                                    //发出更新完成的通知
                                                                    NotificationCenter.default.post(name: FSNotification.mpContainerUpdated.name, object: nil)
                                                                }
                                                            })
                                                        })
                                                    }
                                                })
                                            }
                                        }
                                    }
                                    else    //如果没有数据更新
                                    {
                                        queue.async {
                                            //发出更新完成的通知
                                            NotificationCenter.default.post(name: FSNotification.mpContainerUpdated.name, object: nil)
                                        }
                                    }
                                }
                            }
                        }
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
    
    ///查询所有iCloud中的歌曲，查询的是原始歌曲文件信息，比如mp3，返回`[MPSongModel]`
    fileprivate func queryAlliCloudSongs(completion: @escaping GnClo<[MPSongModel]>)
    {
        ia.setFilter(files: FMUTIs.audioGroup, dirs: [.MusicSong])
        ia.queryDocuments { files in
            g_async { queue in
                //先将原始文件信息保存到内存中
                self.mutate(key: MPDataKey.iCloudSongFileInfo, value: files, meta: DataModelMeta(needCopy: false, canCommit: false))
                //转换文件为歌曲信息
                let songs = files.map { file in
                    MPSongModel(name: file.displayName, url: file.url)
                }
                queue.async {
                    completion(songs)
                }
            }
        }
    }
    
    //在iCloud中创建一个新文件，返回是否创建成功
    fileprivate func createFileIniCloud(_ data: Data, fileName: String, completion: @escaping BoClo)
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
    fileprivate func openFileFromiCloud(_ fileName: String, completion: @escaping OpGnClo<iCloudAccessor.IADocumentHandlerType>)
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
    fileprivate func readFileFromiCloud(_ fileName: String, completion: @escaping OpDataClo)
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
                    //关闭文件
                    self?.ia.closeDocument(id)
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
    
    //提交数据到持久性数据源，目前都保存到iCloud文件
    override func commit(key: AnyHashable, value: Any, success: @escaping OpAnyClo, failure: @escaping NSErrClo) {
        if let k = key as? MPDataKey, let val = value as? NSCoding, self.canCommit(key: key)
        {
            ArchiverAdapter.shared.archive(val, completion: {[weak self] (data) in
                if let data = data, let fileName = k.getiCloudFileName() {
                    //尝试打开文件
                    self?.openFileFromiCloud(fileName) {fileId in
                        if let fileId = fileId {
                            //修改文件
                            self?.ia.writeDocument(fileId, data: data, completion: { succeed in
                                if succeed
                                {
                                    //关闭文件
                                    self?.ia.closeDocument(fileId)
                                    success(nil)
                                }
                                else
                                {
                                    failure(FSError.saveToiCloudError.getError())
                                }
                            })
                        }
                        else    //创建一个新文件
                        {
                            self?.createFileIniCloud(data, fileName: fileName, completion: { succeed in
                                if succeed
                                {
                                    success(nil)
                                }
                                else
                                {
                                    failure(FSError.saveToiCloudError.getError())
                                }
                            })
                        }
                    }
                }
            })
        }
    }
    
}


//通知代理
extension MPContainer: DelegateProtocol
{
    //app已经获得焦点，刷新媒体库
    @objc func applicationDidBecomeActiveNotification(notification: Notification)
    {
        self.updateLibrarys()
    }
    
    //app失去焦点，停止更新媒体库
    @objc func applicationWillResignActiveNotification(notification: Notification)
    {
        if ia.isQuerying
        {
            self.ia.stopQuery()
        }
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
    //我喜欢歌曲列表文件
    static let favoriteSongsFileName = "favoriteSongs.dat"
    //历史播放列表列表文件
    static let historyPlaylistsFileName = "historyPlaylists.dat"
    //歌单列表
    static let songlistsFileName = "songlists.dat"
 
    //数据对象的key
    enum MPDataKey: String {
        case librarys                       //媒体库列表
        case currentSong                    //当前播放歌曲
        case currentPlaylist                //当前播放列表
        case historySongs                   //历史播放歌曲
        case favoriteSongs                  //我喜欢歌曲列表
        case historyPlaylists               //历史播放列表
        case songlists                      //歌单列表
        
        case iCloudSongFileInfo             //所有iCloud歌曲原始文件信息，只存在内存中
        
        //获取key对应的在iCloud中的文件名，并非所有key都有文件名
        func getiCloudFileName() -> String?
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
            case .favoriteSongs:
                return MPContainer.favoriteSongsFileName
            case .historyPlaylists:
                return MPContainer.historyPlaylistsFileName
            case .songlists:
                return MPContainer.songlistsFileName
            default:
                return nil
            }
        }
    }
    
}


//外部接口
extension MPContainer: ExternalInterface
{
    ///获取所有库
    func getLibrarys(_ completion: @escaping OpGnClo<[MPMediaLibraryModel]>)
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
    func getiCloudLibrary(_ completion: @escaping OpGnClo<MPMediaLibraryModel>)
    {
        if let libs = self.get(key: MPDataKey.librarys) as? [MPMediaLibraryModel]
        {
            for lib in libs
            {
                if lib.type == .iCloud
                {
                    completion(lib)
                    break
                }
            }
        }
        else
        {
            completion(nil)
        }
    }
    
    ///保存iCloud库
    func setiCloudLibrary(_ iCloudLib: MPMediaLibraryModel, success: BoClo? = nil)
    {
        getLibrarys {[weak self] libs in
            if var libs = libs {
                for (index, lib) in libs.enumerated()
                {
                    if lib.type == .iCloud
                    {
                        libs[index] = iCloudLib
                        break
                    }
                }
                //保存到内存
                self?.mutate(key: MPDataKey.librarys, value: libs, meta: DataModelMeta(needCopy: false, canCommit: true))
                //保存到iCloud
                self?.commit(key: MPDataKey.librarys, value: libs, success: { obj in
                    if let success = success {
                        success(true)
                    }
                }, failure: { error in
                    FSLog("MPContainer save icloud library : \(error.localizedDescription)")
                    if let success = success {
                        success(false)
                    }
                })
            }
            else
            {
                if let success = success {
                    success(false)
                }
            }
        }
    }
    
    ///获取当前播放歌曲
    func getCurrentSong(_ completion: @escaping OpGnClo<MPSongModel>)
    {
        if let song = self.get(key: MPDataKey.currentSong) as? MPSongModel
        {
            completion(song)
        }
        else    //如果缓存中没有，那么尝试从iCloud获取
        {
            readFileFromiCloud(Self.currentSongFileName) {[weak self] data in
                if let data = data {
                    MPSongModel.unarchive(data) { (song) in
                        if let song = song {
                            //先保存到缓存
                            self?.mutate(key: MPDataKey.currentSong, value: song, meta: DataModelMeta(needCopy: false, canCommit: true))
                            //返回song
                            completion(song)
                        }
                        else
                        {
                            completion(nil)
                        }
                    }
                }
                else
                {
                    completion(nil)
                }
            }
        }
    }
    
    ///保存当前播放歌曲
    func setCurrentSong(_ song: MPSongModel)
    {
        self.mutate(key: MPDataKey.currentSong, value: song, meta: DataModelMeta(needCopy: false, canCommit: true))
        //保存到iCloud
        self.commit(key: MPDataKey.currentSong, value: song) { obj in
            
        } failure: { error in
            FSLog("MPContainer save current song : \(error.localizedDescription)")
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
                    MPPlaylistModel.unarchive(data) { (obj) in
                        if let playlist = obj {
                            //查询缓存中iCloud中所有歌曲，做diff
                            self?.getiCloudLibrary({ lib in
                                if let songs = lib?.songs {
                                    //做diff，用媒体库中的歌曲对象替换播放列表中的，节省内存
                                    playlist.updateAudios(songs)
                                    //更新完成后保存到缓存中，此时，playlist中的歌曲都是iCloud歌曲库的引用
                                    self?.mutate(key: MPDataKey.currentPlaylist, value: playlist, meta: DataModelMeta(needCopy: false, canCommit: true))
                                    completion(playlist)
                                }
                                else    //如果没有查询到，直接保存，应该不会出现这种情况，一定会有iCloud库
                                {
                                    self?.mutate(key: MPDataKey.currentPlaylist, value: playlist, meta: DataModelMeta(needCopy: false, canCommit: true))
                                    completion(playlist)
                                }
                            })
                        }
                        else
                        {
                            completion(nil)
                        }
                    }
                }
                else
                {
                    completion(nil)
                }
            }
        }
    }
    
    ///保存当前播放列表
    func setCurrentPlaylist(_ playlist: MPPlaylistModel)
    {
        self.mutate(key: MPDataKey.currentPlaylist, value: playlist, meta: DataModelMeta(needCopy: false, canCommit: true))
        //保存到iCloud
        self.commit(key: MPDataKey.currentPlaylist, value: playlist) { obj in
            
        } failure: { error in
            FSLog("MPContainer save current playlist : \(error.localizedDescription)")
        }
    }
    
    ///获取历史播放歌曲列表
    func getHistorySongs(_ completion: @escaping OpGnClo<MPHistoryAudioModel>)
    {
        if let playlist = self.get(key: MPDataKey.historySongs) as? MPHistoryAudioModel
        {
            completion(playlist)
        }
        else    //如果缓存中没有，那么尝试从iCloud获取
        {
            readFileFromiCloud(Self.historySongsFileName) { [weak self] data in
                if let data = data {
                    MPHistoryAudioModel.unarchive(data) { (obj) in
                        if let playlist = obj {
                            //查询缓存中iCloud中所有歌曲，做diff
                            self?.getiCloudLibrary({ lib in
                                if let songs = lib?.songs {
                                    //做diff，用媒体库中的歌曲对象替换播放列表中的，节省内存
                                    playlist.updateAudios(songs)
                                    //更新完成后保存到缓存中，此时，historySongs中的歌曲都是iCloud歌曲库的引用
                                    self?.mutate(key: MPDataKey.historySongs, value: playlist, meta: DataModelMeta(needCopy: false, canCommit: true))
                                    completion(playlist)
                                }
                                else    //如果没有查询到，直接保存，应该不会出现这种情况，一定会有iCloud库
                                {
                                    self?.mutate(key: MPDataKey.historySongs, value: playlist, meta: DataModelMeta(needCopy: false, canCommit: true))
                                    completion(playlist)
                                }
                            })
                        }
                        else
                        {
                            completion(nil)
                        }
                    }
                }
                else
                {
                    completion(nil)
                }
            }
        }
    }
    
    ///保存历史播放歌曲列表
    func setHistorySongs(_ historySongs: MPHistoryAudioModel)
    {
        self.mutate(key: MPDataKey.historySongs, value: historySongs, meta: DataModelMeta(needCopy: false, canCommit: true))
        //保存到iCloud
        self.commit(key: MPDataKey.historySongs, value: historySongs) { obj in
            
        } failure: { error in
            FSLog("MPContainer save historySongs : \(error.localizedDescription)")
        }
    }
    
    ///获取我喜欢歌曲列表
    func getFavoriteSongs(_ completion: @escaping OpGnClo<MPFavoriteModel>)
    {
        if let favorite = self.get(key: MPDataKey.favoriteSongs) as? MPFavoriteModel
        {
            completion(favorite)
        }
        else    //如果缓存中没有，那么尝试从iCloud获取
        {
            readFileFromiCloud(Self.favoriteSongsFileName) { [weak self] data in
                if let data = data {
                    MPFavoriteModel.unarchive(data) { obj in
                        if let favoriteSongs = obj {
                            //查询缓存中iCloud中所有歌曲，做diff
                            self?.getiCloudLibrary({ lib in
                                if let songs = lib?.songs {
                                    //做diff，用媒体库中的歌曲对象替换播放列表中的，节省内存
                                    favoriteSongs.updateAudios(songs)
                                    //更新完成后保存到缓存中，此时，favoriteSongs中的歌曲都是iCloud歌曲库的引用
                                    self?.mutate(key: MPDataKey.favoriteSongs, value: favoriteSongs, meta: DataModelMeta(needCopy: false, canCommit: true))
                                    completion(favoriteSongs)
                                }
                                else    //如果没有查询到，直接保存，应该不会出现这种情况，一定会有iCloud库
                                {
                                    self?.mutate(key: MPDataKey.favoriteSongs, value: favoriteSongs, meta: DataModelMeta(needCopy: false, canCommit: true))
                                    completion(favoriteSongs)
                                }
                            })
                        }
                        else
                        {
                            completion(nil)
                        }
                    }
                }
                else
                {
                    completion(nil)
                }
            }
        }
    }
    
    ///保存我喜欢歌曲列表
    func setFavoriteSongs(_ favoriteSongs: MPFavoriteModel, success: BoClo? = nil)
    {
        self.mutate(key: MPDataKey.favoriteSongs, value: favoriteSongs, meta: DataModelMeta(needCopy: false, canCommit: true))
        //保存到iCloud
        self.commit(key: MPDataKey.favoriteSongs, value: favoriteSongs) { obj in
            if let success = success {
                success(true)
            }
        } failure: { error in
            FSLog("MPContainer save favoriteSongs : \(error.localizedDescription)")
            if let success = success {
                success(false)
            }
        }
    }
    
    ///获取歌单列表
    func getSonglists(_ completion: @escaping OpGnClo<[MPSonglistModel]>)
    {
        if let songlists = self.get(key: MPDataKey.songlists) as? [MPSonglistModel]
        {
            completion(songlists)
        }
        else //如果缓存中没有，那么尝试从iCloud获取
        {
            readFileFromiCloud(Self.songlistsFileName) { [weak self] data in
                if let data = data {
                    ArchiverAdapter.shared.unarchive(data) { obj in
                        if let songlists = obj as? [MPSonglistModel] {
                            //查询icloud中所有歌曲，做diff
                            self?.getiCloudLibrary({ lib in
                                if let songs = lib?.songs {
                                    //做diff，用媒体库中的歌曲对象替换播放列表中的，节省内存
                                    for songlist in songlists {
                                        songlist.updateSongs(songs)
                                    }
                                    //更新完成后保存到缓存中，此时，songlists中的歌曲都是iCloud歌曲库的引用
                                    self?.mutate(key: MPDataKey.songlists, value: songlists, meta: DataModelMeta(needCopy: false, canCommit: true))
                                    completion(songlists)
                                }
                                else    //如果没有查询到，直接保存，应该不会出现这种情况，一定会有iCloud库
                                {
                                    self?.mutate(key: MPDataKey.songlists, value: songlists, meta: DataModelMeta(needCopy: false, canCommit: true))
                                    completion(songlists)
                                }
                            })
                        }
                        else
                        {
                            completion(nil)
                        }
                    }
                }
                else
                {
                    completion(nil)
                }
            }
        }
    }
    
    ///保存歌单列表
    func setSonglists(_ songlists: [MPSonglistModel], success: BoClo? = nil)
    {
        self.mutate(key: MPDataKey.songlists, value: songlists, meta: DataModelMeta(needCopy: false, canCommit: true))
        //保存到iCloud
        self.commit(key: MPDataKey.songlists, value: songlists) { obj in
            if let success = success {
                success(true)
            }
        } failure: { error in
            FSLog("MPContainer save songlists : \(error.localizedDescription)")
            if let success = success {
                success(false)
            }
        }
    }
    
    ///获取历史播放列表列表，还未设计好，待定
    func getHistoryPlaylists(_ completion: @escaping OpGnClo<[MPHistoryPlaylistModel]>)
    {
        if let playlists = self.get(key: MPDataKey.historyPlaylists) as? [MPHistoryPlaylistModel]
        {
            completion(playlists)
        }
        else    //如果缓存中没有，那么尝试从iCloud获取
        {
            readFileFromiCloud(Self.historyPlaylistsFileName) { [weak self] data in
                if let data = data {
                    ArchiverAdapter.shared.unarchive(data) { (obj) in
                        if let playlists = obj as? [MPHistoryPlaylistModel] {
                            self?.mutate(key: MPDataKey.historyPlaylists, value: playlists, meta: DataModelMeta(needCopy: false, canCommit: true))
                            completion(playlists)
                        }
                        else
                        {
                            completion(nil)
                        }
                    }
                }
                else
                {
                    completion(nil)
                }
            }
        }
    }
    
    ///保存历史播放列表列表，还未设计好，待定
    func setHistoryPlaylists(_ historyPlaylists: [MPHistoryPlaylistModel])
    {
        self.mutate(key: MPDataKey.historyPlaylists, value: historyPlaylists, meta: DataModelMeta(needCopy: false, canCommit: true))
        //保存到iCloud
        self.commit(key: MPDataKey.historyPlaylists, value: historyPlaylists) { obj in
            
        } failure: { error in
            FSLog("MPContainer save historyPlaylists : \(error.localizedDescription)")
        }
    }
    
    ///获取某一首歌曲的原始文件信息
    func getSongFileInfo(_ song: MPSongModel) -> IADocumentSearchResult?
    {
        if let results = get(key: MPDataKey.iCloudSongFileInfo) as? [IADocumentSearchResult]
        {
            for result in results {
                if result.url.absoluteString == song.url.absoluteString
                {
                    return result
                }
            }
        }
        return nil
    }
    
    ///修改某一首歌曲的原始文件信息
    func setSongFileInfo(_ newFile: IADocumentSearchResult)
    {
        if let fileInfos = get(key: MPDataKey.iCloudSongFileInfo) as? [IADocumentSearchResult]
        {
            var newFiles = fileInfos
            for (index, file) in fileInfos.enumerated()
            {
                if file.url.absoluteString == newFile.url.absoluteString
                {
                    newFiles.remove(at: index)
                    newFiles.insert(newFile, at: index)
                    break
                }
            }
            //保存到缓存中
            self.mutate(key: MPDataKey.iCloudSongFileInfo, value: newFiles, meta: DataModelMeta(needCopy: false, canCommit: false))
        }
    }
    
}
