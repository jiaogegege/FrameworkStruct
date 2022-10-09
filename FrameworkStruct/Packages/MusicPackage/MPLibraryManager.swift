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

class MPLibraryManager: OriginManager
{
    //MARK: 属性
    //单例
    static let shared = MPLibraryManager()
    
    //数据容器
    fileprivate lazy var container: MPContainer = {
        let container = MPContainer.shared
        
        return container
    }()
    
    //icloud存取器
    fileprivate lazy var ia: iCloudAccessor = {
        let ia = iCloudAccessor.shared
        return ia
    }()
    
    
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


//外部接口
extension MPLibraryManager: ExternalInterface
{
    ///获取某个资源库的所有歌曲
    func getResource(libraryType: MPLibraryType, resourceType: MPLibraryResourceType, completion: (([Any]) -> Void))
    {
        
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
