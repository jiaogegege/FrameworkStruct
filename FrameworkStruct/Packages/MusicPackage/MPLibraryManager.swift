//
//  MPLibraryManager.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/10/5.
//

/**
 音乐媒体库管理器，负责管理媒体库资源和播放资源，包括多个源的媒体库，比如iCloud；播放资源，比如播放列表等
 单例
 */
import UIKit

protocol MPLibraryManagerDelegate: NSObjectProtocol {
    ///媒体库管理器初始化完成
    func mpLibraryManagerDidInitCompleted()
    ///媒体库更新完成
    func mpLibraryManagerDidUpdated()
    ///我喜欢歌曲列表更新
    func mpLibraryManagerDidUpdateFavoriteSongs(_ favoriteSongs: MPFavoriteModel)
    ///当前播放列表更新
    func mpLibraryManagerDidUpdateCurrentPlaylist(_ currentPlaylist: MPPlaylistModel)
    ///历史播放记录列表更新
    func mpLibraryManagerDidUpdateHistorySongs(_ history: MPHistoryAudioModel)
    ///歌单列表更新
    func mpLibraryManagerDidUpdateSonglists(_ songlists: [MPSonglistModel])
}

class MPLibraryManager: OriginManager
{
    //MARK: 属性
    //单例
    static let shared = MPLibraryManager()
    
    //数据容器
    fileprivate var container = MPContainer.shared
    
    weak var delegate: MPLibraryManagerDelegate?
    
    
    //MARK: 方法
    //私有化初始化方法
    private override init()
    {
        super.init()
        self.container.subscribe(key: MPContainer.MPDataKey.favoriteSongs, delegate: self)
        self.container.subscribe(key: MPContainer.MPDataKey.currentPlaylist, delegate: self)
        self.container.subscribe(key: MPContainer.MPDataKey.historySongs, delegate: self)
        self.container.subscribe(key: MPContainer.MPDataKey.songlists, delegate: self)
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
    
    func addNotification()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(containerDidInitCompleted(notify:)), name: FSNotification.mpContainerInitFinished.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(containerDidUpdated(notify:)), name: FSNotification.mpContainerUpdated.name, object: nil)
    }
    
}


extension MPLibraryManager: DelegateProtocol, ContainerServices
{
    //媒体库初始化完成
    @objc func containerDidInitCompleted(notify: Notification)
    {
        //通知代理
        if let del = self.delegate
        {
            del.mpLibraryManagerDidInitCompleted()
        }
    }
    
    //媒体库更新
    @objc func containerDidUpdated(notify: Notification)
    {
        //通知代理
        if let del = self.delegate
        {
            del.mpLibraryManagerDidUpdated()
        }
    }
    
    func containerDidUpdateData(key: AnyHashable, value: Any)
    {
        if let k = key as? MPContainer.MPDataKey
        {
            if k == .favoriteSongs, let fav = value as? MPFavoriteModel  //我喜欢列表更新
            {
                if let del = self.delegate
                {
                    del.mpLibraryManagerDidUpdateFavoriteSongs(fav)
                }
            }
            else if k == .currentPlaylist, let pl = value as? MPPlaylistModel   //当前播放列表更新
            {
                if let de = self.delegate
                {
                    de.mpLibraryManagerDidUpdateCurrentPlaylist(pl)
                }
            }
            else if k == .historySongs, let his = value as? MPHistoryAudioModel     //历史播放记录列表更新
            {
                if let de = self.delegate
                {
                    de.mpLibraryManagerDidUpdateHistorySongs(his)
                }
            }
            else if k == .songlists, let songlists = value as? [MPSonglistModel]        //歌单列表
            {
                if let de = self.delegate
                {
                    de.mpLibraryManagerDidUpdateSonglists(songlists)
                }
            }
        }
    }
    
    func containerDidClearData(key: AnyHashable) {
        
    }
    
}


//内部类型
extension MPLibraryManager: InternalType
{
    //插入歌曲的结果
    enum InsertSongToSonglistResult {
        case success            //插入成功
        case exist              //歌曲已经存在
        case partExist          //部分歌曲已经存在
        case failure            //插入失败
        
        func getDesc() -> String
        {
            switch self {
            case .success:
                return String.insertSuccess
            case .exist:
                return String.songExist
            case .partExist:
                return String.partSongExist
            case .failure:
                return String.insertFailure
            }
        }
    }
}


//外部接口
extension MPLibraryManager: ExternalInterface
{
    /**************************************** 播放资源操作 Section Begin ***************************************/
    ///获取某个资源
    func getResource(libraryType: MPLibraryType, resourceType: MPLibraryResourceType, completion: @escaping (([Any]?) -> Void))
    {
        if libraryType == .iCloud
        {
            container.getiCloudLibrary { lib in
                completion(lib?.songs)
            }
        }
        else
        {
            
        }
    }
    
    ///读取当前播放歌曲，可能为nil
    func readCurrentSong(_ completion: @escaping (MPSongModel?) -> Void)
    {
        container.getCurrentSong { song in
            completion(song)
        }
    }
    
    ///读取当前播放列表
    func readCurrentPlaylist(_ completion: @escaping (MPPlaylistModel?) -> Void)
    {
        container.getCurrentPlaylist { playlist in
            completion(playlist)
        }
    }
    
    ///读取历史播放歌曲
    func readHistorySongs(_ completion: @escaping (MPHistoryAudioModel?) -> Void)
    {
        container.getHistorySongs { history in
            completion(history)
        }
    }
    
    ///读取我喜欢歌曲
    func readFavoriteSongs(_ completion: @escaping (MPFavoriteModel?) -> Void)
    {
        container.getFavoriteSongs { favorite in
            completion(favorite)
        }
    }
    
    ///保存当前播放歌曲和播放列表
    func saveCurrent(_ song: MPSongModel, in playlist: MPPlaylistModel)
    {
        //当前歌曲
        container.setCurrentSong(song)
        //当前播放列表
        container.setCurrentPlaylist(playlist)
        
        //如果历史播放歌曲中还没有这首歌，那么在历史播放歌曲中新增一个，在最前位置
        container.getHistorySongs {[weak self] historySongs in
            if let historySongs = historySongs {
                historySongs.addAudio(song)
                //写入文件
                self?.container.setHistorySongs(historySongs)
            }
            else    //如果还没有历史歌曲记录，创建一个历史记录列表，就是个播放列表
            {
                let history = MPHistoryAudioModel(name: String.historyPlay, audioType: .song)
                history.addAudio(song)
                //写入文件
                self?.container.setHistorySongs(history)
            }
        }
        
        //处理历史播放列表记录
        
    }
    
    ///保存iCloud库
    func saveiCloudSongs(_ songs: [MPSongModel], success: @escaping BoolClosure)
    {
        container.getiCloudLibrary {[weak self] lib in
            if let lib = lib {
                lib.songs = songs
                self?.container.setiCloudLibrary(lib, success: { succeed in
                    success(succeed)
                })
            }
            else
            {
                success(false)
            }
        }
    }
    
    ///我喜欢列表新增或删除一首歌曲
    ///参数：favorite：收藏/取消收藏
    func saveSongToFavorite(_ song: MPSongModel, favorite: Bool, success: @escaping BoolClosure)
    {
        //先读取我喜欢列表
        container.getFavoriteSongs {[weak self] favoriteSongs in
            if let favoriteSongs = favoriteSongs {
                let ret = favorite ? favoriteSongs.addAudio(song) : favoriteSongs.deleteAudio(song)
                if ret  //添加成功，保存到icloud
                {
                    self?.container.setFavoriteSongs(favoriteSongs, success: { succeed in
                        success(succeed)
                    })
                }
                else
                {
                    success(false)
                }
            }
            else    //如果还没有我喜欢列表，那么创建一个新的
            {
                let favoriteSongs = MPFavoriteModel(name: String.iLike, audioType: .song)
                let ret = favorite ? favoriteSongs.addAudio(song) : favoriteSongs.deleteAudio(song)
                if ret
                {
                    self?.container.setFavoriteSongs(favoriteSongs, success: { succeed in
                        success(succeed)
                    })
                }
                else
                {
                    success(false)
                }
            }
        }
    }
    
    ///在当前播放列表中删除一首歌
    func deleteSongInCurrentPlaylist(_ song: MPAudioProtocol, success: @escaping BoolClosure)
    {
        readCurrentPlaylist {[weak self] playlist in
            if let playlist = playlist {
                let ret = playlist.deleteAudio(song)
                if ret  //删除成功则更新缓存和icloud文件
                {
                    self?.container.setCurrentPlaylist(playlist)
                }
                success(ret)
            }
            else
            {
                success(false)
            }
        }
    }
    
    ///在历史列表中删除一首歌
    func deleteSongInHistory(_ song: MPAudioProtocol, success: @escaping BoolClosure)
    {
        readHistorySongs { [weak self] history in
            if let his = history {
                let ret = his.deleteAudio(song)
                if ret  //删除成功则更新缓存和iCloud文件
                {
                    self?.container.setHistorySongs(his)
                }
                success(ret)
            }
            else
            {
                success(false)
            }
        }
    }
    
    /**************************************** 播放资源操作 Section End ***************************************/
    
    /**************************************** 歌单操作 Section Begin ***************************************/
    ///创建新歌单
    func createNewSonglist(_ name: String, success: @escaping BoolClosure)
    {
        let songlist = MPSonglistModel(name: name)
        //读取歌单列表
        container.getSonglists {[weak self] songlists in
            if var songlists = songlists {
                //插入到第一个位置
                songlists.insert(songlist, at: 0)
                //保存到缓存和iCloud
                self?.container.setSonglists(songlists, success: { succeed in
                    success(succeed)
                })
            }
            else    //创建一个新的歌单列表
            {
                let songlists = [songlist]
                //保存到缓存和iCloud
                self?.container.setSonglists(songlists, success: { succeed in
                    success(succeed)
                })
            }
        }
    }
    
    ///读取歌单列表
    func readSonglists(_ completion: @escaping ([MPSonglistModel]?) -> Void)
    {
        container.getSonglists { songlists in
            completion(songlists)
        }
    }
    
    ///删除某个歌单，包括歌单下所有歌曲
    func deleteSonglist(_ songlistId: String, success: @escaping BoolClosure)
    {
        //先查询歌单列表
        container.getSonglists { songlists in
            if var songlists = songlists {
                var succeed = false //是否删除成功
                for (index, songlist) in songlists.enumerated()
                {
                    if songlist.id == songlistId
                    {
                        songlists.remove(at: index)
                        succeed = true
                        break
                    }
                }
                success(succeed)
            }
            else    //没有读取到歌单，返回删除失败
            {
                success(false)
            }
        }
    }
    
    ///向歌单中添加一些歌曲
    func addSongsToSonglist(_ songs: [MPSongModel], songlistId: String, completion: @escaping (InsertSongToSonglistResult) -> Void)
    {
        //先查询所有歌单
        container.getSonglists {[weak self] songlists in
            if let songlists = songlists {
                for songlist in songlists {
                    if songlist.id == songlistId    //找到指定的歌单
                    {
                        var insertSuccess = true //插入是否成功，所有插入成功才算成功
                        var insertFailure = true    //插入是否失败，有一个插入成功就不算失败
                        var allExist = true     //是否所有歌曲都存在
                        var partExist = false    //歌曲部分存在，有一个存在就算true
                        //做diff
                        for song in songs.reversed() {
                            //得到歌单中所有歌曲的id
                            let existSongIds = songlist.songs.map { song in
                                song.id
                            }
                            if !existSongIds.contains(song.id)  //不存在才添加
                            {
                                allExist = false
                                let index = songlist.insertAudio(audio: song, index: 0)  //插入到位置0
                                if index >= 0   //插入成功
                                {
                                    insertFailure = false
                                }
                                else    //插入失败
                                {
                                    insertSuccess = false
                                }
                            }
                            else    //歌曲已经存在
                            {
                                partExist = true
                            }
                        }
                        //只要成功插入一首歌曲，那么保存到缓存和iCloud
                        if insertFailure == false && allExist == false
                        {
                            self?.container.setSonglists(songlists)
                        }
                        //插入完成
                        if insertSuccess
                        {
                            completion(.success)
                        }
                        else if partExist
                        {
                            completion(.partExist)
                        }
                        else if allExist
                        {
                            completion(.exist)
                        }
                        else if insertFailure
                        {
                            completion(.failure)
                        }
                        else
                        {
                            completion(.success)
                        }
                        break
                    }
                }
            }
            else
            {
                completion(.failure)
            }
        }
    }
    
    /**************************************** 歌单操作 Section End ***************************************/
    
    /**************************************** 基础资源操作 Section Begin ***************************************/
    ///根据歌曲id获取歌曲
    func getSong(_ id: String) -> MPSongModel?
    {
        return nil
    }
    
    ///根据歌曲ids获取歌曲s
    func getSongs(_ ids: [String]) -> [MPSongModel]
    {
        var songs = [MPSongModel]()
        for id in ids
        {
            if let song = self.getSong(id)
            {
                songs.append(song)
            }
        }
        return songs
    }
    
    ///修改歌曲的下载状态
    func setSongDownloadStatus(_ downloaded: Bool, song: MPSongModel)
    {
        if let file = container.getSongFileInfo(song)
        {
            var newFile = file
            newFile.downloadingStatus = downloaded ? NSMetadataUbiquitousItemDownloadingStatusCurrent : NSMetadataUbiquitousItemDownloadingStatusNotDownloaded
            container.setSongFileInfo(newFile)
        }
    }
    
    ///根据艺术家id返回艺术家对象
    func getArtist(_ id: String) -> MPArtistModel?
    {
        return nil
    }
    
    ///根据艺术家id数组返回艺术家数组
    func getArtists(_ ids: [String]) -> [MPArtistModel]
    {
        var artists = [MPArtistModel]()
        for id in ids
        {
            if let artist = self.getArtist(id)
            {
                artists.append(artist)
            }
        }
        return artists
    }
    
    ///根据专辑id获取专辑对象
    func getAlbum(_ id: String) -> MPAlbumModel?
    {
        return nil
    }
    
    ///根据歌词或字幕id获取歌词或字幕对象
    func getLyric(_ id: String) -> MPLyricModel?
    {
        return nil
    }
    
    ///根据乐谱id获取乐谱
    func getMusicbook(_ id: String) -> MPMusicbookModel?
    {
        return nil
    }
    
    ///根据标签id获取标签对象
    func getTag(_ id: String) -> MPTagModel?
    {
        return nil
    }
    
    ///根据标签id列表获取标签对象列表
    func getTags(_ ids: [String]) -> [MPTagModel]
    {
        var tags = [MPTagModel]()
        for id in ids
        {
            if let tag = self.getTag(id)
            {
                tags.append(tag)
            }
        }
        return tags
    }
    /**************************************** 基础资源操作 Section End ***************************************/
    
}
