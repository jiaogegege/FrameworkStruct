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
    
}

class MPLibraryManager: OriginManager
{
    //MARK: 属性
    //单例
    static let shared = MPLibraryManager()
    
    //数据容器
    fileprivate var container = MPContainer.shared
    
    //媒体库
    fileprivate var librarys: [MPMediaLibraryModel]?
    
    weak var delegate: MPLibraryManagerDelegate?
    
    
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
    
    func addNotification()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(containerDidInitCompleted(notify:)), name: FSNotification.mpContainerInitFinished.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(containerDidUpdated(notify:)), name: FSNotification.mpContainerUpdated.name, object: nil)
    }
    
}


extension MPLibraryManager: DelegateProtocol
{
    //媒体库初始化完成
    @objc func containerDidInitCompleted(notify: Notification)
    {
        //获取媒体库
        container.getLibrarys({[weak self] libs in
            self?.librarys = libs
        })
        //通知代理
        if let del = self.delegate
        {
            del.mpLibraryManagerDidInitCompleted()
        }
    }
    
    //媒体库更新
    @objc func containerDidUpdated(notify: Notification)
    {
        //获取媒体库
        container.getLibrarys({[weak self] libs in
            self?.librarys = libs
        })
        //通知代理
        if let del = self.delegate
        {
            del.mpLibraryManagerDidUpdated()
        }
    }
    
}


//外部接口
extension MPLibraryManager: ExternalInterface
{
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
    
}
