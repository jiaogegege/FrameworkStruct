//
//  MPSongModel.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/10/5.
//

/**
 歌曲信息
 */
import UIKit

class MPSongModel: OriginModel, Archivable
{
    //MARK: 属性
    var id: String
    var name: String
    var url: URL
    var artistIds: Array<String>?
    var albumId: String?
    var artistImgs: Array<URL>?
    var albumImgs: Array<URL>?
    var lyricId: String?
    var musicbookId: String?
    var tagIds: Array<String>?
    var intro: String?
    
    //MARK: 方法
    //初始化一个新的歌曲信息
    init(name: String, url: URL) {
        self.id = g_uuid()
        self.name = name
        self.url = url
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let song = MPSongModel(name: self.name, url: self.url)
        song.id = self.id
        song.artistIds = self.artistIds
        song.albumId = self.albumId
        song.artistImgs = self.artistImgs
        song.albumImgs = self.albumImgs
        song.lyricId = self.lyricId
        song.musicbookId = self.musicbookId
        song.tagIds = self.tagIds
        song.intro = self.intro
        
        return song
    }
    
    required init?(coder: NSCoder) {
        guard let id = coder.decodeObject(forKey: PropertyKey.id.rawValue) as? String else { return nil }
        
        self.id = id
        self.name = coder.decodeObject(forKey: PropertyKey.name.rawValue) as! String
        self.url = coder.decodeObject(forKey: PropertyKey.url.rawValue) as! URL
        self.artistIds = coder.decodeObject(forKey: PropertyKey.artists.rawValue) as? [String]
        self.albumId = coder.decodeObject(forKey: PropertyKey.album.rawValue) as? String
        self.artistImgs = coder.decodeObject(forKey: PropertyKey.artistImgs.rawValue) as? Array<URL>
        self.albumImgs = coder.decodeObject(forKey: PropertyKey.albumImgs.rawValue) as? Array<URL>
        self.lyricId = coder.decodeObject(forKey: PropertyKey.lyric.rawValue) as? String
        self.musicbookId = coder.decodeObject(forKey: PropertyKey.musicbook.rawValue) as? String
        self.tagIds = coder.decodeObject(forKey: PropertyKey.tags.rawValue) as? [String]
        self.intro = coder.decodeObject(forKey: PropertyKey.intro.rawValue) as? String
    }

    func encode(with coder: NSCoder) {
        coder.encode(self.id, forKey: PropertyKey.id.rawValue)
        coder.encode(self.name, forKey: PropertyKey.name.rawValue)
        coder.encode(self.url, forKey: PropertyKey.url.rawValue)
        coder.encode(self.artistIds, forKey: PropertyKey.artists.rawValue)
        coder.encode(self.albumId, forKey: PropertyKey.album.rawValue)
        coder.encode(self.artistImgs, forKey: PropertyKey.artistImgs.rawValue)
        coder.encode(self.albumImgs, forKey: PropertyKey.albumImgs.rawValue)
        coder.encode(self.lyricId, forKey: PropertyKey.lyric.rawValue)
        coder.encode(self.musicbookId, forKey: PropertyKey.musicbook.rawValue)
        coder.encode(self.tagIds, forKey: PropertyKey.tags.rawValue)
        coder.encode(self.intro, forKey: PropertyKey.intro.rawValue)
    }
    
}


//音频信息协议
extension MPSongModel: MPAudioProtocol
{
    var audioId: String {
        id
    }
    
    var audioName: String {
        name
    }
    
    var audioUrl: URL {
        url
    }
    
    var audioArtists: Array<MPArtistModel>? {
        guard let ids = self.artistIds else { return nil }
        return MPLibraryManager.shared.getArtists(ids)
    }
    
    var audioAlbum: MPAlbumModel? {
        guard let id = self.albumId else { return nil }
        return MPLibraryManager.shared.getAlbum(id)
    }
    
    var audioArtistImgs: Array<URL>? {
        artistImgs
    }
    
    var audioAlbumImgs: Array<URL>? {
        albumImgs
    }
    
    var audioLyric: MPLyricModel? {
        guard let id = self.lyricId else { return nil }
        return MPLibraryManager.shared.getLyric(id)
    }
    
    var audioMusicbook: MPMusicbookModel? {
        guard let id = self.musicbookId else { return nil }
        return MPLibraryManager.shared.getMusicbook(id)
    }
    
    var audioTags: Array<MPTagModel>? {
        guard let ids = self.tagIds else { return nil }
        return MPLibraryManager.shared.getTags(ids)
    }
    
    var audioIntro: String? {
        intro
    }
    
}


//内部类型
extension MPSongModel: InternalType
{
    //属性字段key定义
    enum PropertyKey: String {
        case id
        case name
        case url
        case artists
        case album
        case artistImgs
        case albumImgs
        case lyric
        case musicbook
        case tags
        case intro
    }
    
}
