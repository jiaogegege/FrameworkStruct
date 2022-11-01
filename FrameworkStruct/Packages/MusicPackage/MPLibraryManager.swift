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
    
    func containerDidUpdateData(key: AnyHashable, value: Any) {
        if let k = key as? MPContainer.MPDataKey
        {
            if k == .favoriteSongs, let fav = value as? MPFavoriteModel  //我喜欢列表更新
            {
                if let del = self.delegate
                {
                    del.mpLibraryManagerDidUpdateFavoriteSongs(fav)
                }
            }
        }
    }
    
    func containerDidClearData(key: AnyHashable) {
        
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
                let history = MPHistoryAudioModel(name: String.historyPlay, mediaType: .song)
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
    
    
    /**************************************** 播放资源操作 Section End ***************************************/
    
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
