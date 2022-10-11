//
//  MPMediaLibraryModel.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/10/7.
//

/**
 音乐媒体库对象，保存某个媒体源的媒体数据，比如iCloud媒体源，保存所有iCloud中的媒体数据，包括歌曲、图片、专辑等
 目前功能比较简单，因为只做iCloud媒体库，所以只有iCloud的媒体数据
 */
import UIKit

class MPMediaLibraryModel: OriginModel, Archivable
{
    //MARK: 属性
    var id: String
    var type: MPLibraryType
    var songs: Array<MPSongModel>
    var albums: Array<MPAlbumModel>
    var artists: Array<MPArtistModel>
    var lyrics: Array<MPLyricModel>
    var musicbooks: Array<MPMusicbookModel>
    
    //MARK: 方法
    //创建一个新的空媒体库对象
    init(type: MPLibraryType) {
        self.id = g_uuid()
        self.type = type
        self.songs = []
        self.albums = []
        self.artists = []
        self.lyrics = []
        self.musicbooks = []
    }
    
    //用获取的数据初始化一个新的媒体库对象
    init(type: MPLibraryType, songs: [MPSongModel], albums: [MPAlbumModel], artists: [MPArtistModel], lyrics: [MPLyricModel], musicbooks: [MPMusicbookModel]) {
        self.id = g_uuid()
        self.type = type
        self.songs = songs
        self.albums = albums
        self.artists = artists
        self.lyrics = lyrics
        self.musicbooks = musicbooks
    }
    
    required init?(coder: NSCoder) {
        guard let id = coder.decodeObject(forKey: PropertyKey.id.rawValue) as? String else { return nil }
        
        self.id = id
        self.type = MPLibraryType(rawValue: coder.decodeInteger(forKey: PropertyKey.type.rawValue))!
        self.songs = coder.decodeObject(forKey: PropertyKey.songs.rawValue) as! [MPSongModel]
        self.albums = coder.decodeObject(forKey: PropertyKey.albums.rawValue) as! [MPAlbumModel]
        self.artists = coder.decodeObject(forKey: PropertyKey.artists.rawValue) as! [MPArtistModel]
        self.lyrics = coder.decodeObject(forKey: PropertyKey.artists.rawValue) as! [MPLyricModel]
        self.musicbooks = coder.decodeObject(forKey: PropertyKey.musicbooks.rawValue) as! [MPMusicbookModel]
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.id, forKey: PropertyKey.id.rawValue)
        coder.encode(self.type.rawValue, forKey: PropertyKey.type.rawValue)
        coder.encode(self.songs, forKey: PropertyKey.songs.rawValue)
        coder.encode(self.albums, forKey: PropertyKey.albums.rawValue)
        coder.encode(self.artists, forKey: PropertyKey.artists.rawValue)
        coder.encode(self.lyrics, forKey: PropertyKey.lyrics.rawValue)
        coder.encode(self.musicbooks, forKey: PropertyKey.musicbooks.rawValue)
    }
    
}


//内部类型
extension MPMediaLibraryModel: InternalType
{
    //属性字段定义
    enum PropertyKey: String {
        case id
        case type
        case songs
        case albums
        case artists
        case lyrics
        case musicbooks
    }
    
}


//接口方法
extension MPMediaLibraryModel: ExternalInterface
{
    ///diff songs，返回是否有更新
    func diffSongs(_ newSongs: [MPSongModel]) -> Bool
    {
        var hasUpdate = false
        //检查新增
        for newSong in newSongs {
            var exist = false   //新歌曲是否存在，如果在旧列表中不存在，那么添加到列表中
            for oldSong in self.songs {
                if oldSong.url.absoluteString == newSong.url.absoluteString
                {
                    //如果已经存在了，那么不需要添加，直接跳过
                    exist = true
                    break
                }
            }
            if exist == false
            {
                self.songs.append(newSong)
                hasUpdate = true
            }
        }
        //检查删除
        for oldSong in self.songs {
            var exist = false
            for newSong in newSongs {
                if newSong.url.absoluteString == oldSong.url.absoluteString
                {
                    exist = true
                    break
                }
            }
            if exist == false
            {
                self.songs.removeObject(oldSong)
                hasUpdate = true
            }
        }
        //排序，根据name
        self.songs.sort { lhs, rhs in
            return lhs.name < rhs.name
        }
        return hasUpdate
    }
    
}
