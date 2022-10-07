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

class MPSongModel: OriginModel, NSCoding
{
    //MARK: 属性
    var id: String
    var name: String
    var url: URL
    var artists: Array<MPArtistModel>?
    var album: MPAlbumModel?
    var artistImgs: Array<URL>?
    var albumImgs: Array<URL>?
    var lyric: MPLyricModel?
    var musicbook: MPMusicbookModel?
    var tags: Array<MPTagModel>?
    var intro: String?
    
    //MARK: 方法
    //初始化一个新的歌曲信息
    init(name: String, url: URL) {
        self.id = g_uuid()
        self.name = name
        self.url = url
    }
    
    required init?(coder: NSCoder) {
        guard let id = coder.decodeObject(forKey: PropertyKey.id.rawValue) as? String else { return nil }
        
        self.id = id
        self.name = coder.decodeObject(forKey: PropertyKey.name.rawValue) as! String
        self.url = URL(string: coder.decodeObject(forKey: PropertyKey.url.rawValue) as! String)!
        self.artists = coder.decodeObject(forKey: PropertyKey.artists.rawValue) as? Array<MPArtistModel>
        self.album = coder.decodeObject(forKey: PropertyKey.album.rawValue) as? MPAlbumModel
        self.artistImgs = coder.decodeObject(forKey: PropertyKey.artistImgs.rawValue) as? Array<URL>
        self.albumImgs = coder.decodeObject(forKey: PropertyKey.albumImgs.rawValue) as? Array<URL>
        self.lyric = coder.decodeObject(forKey: PropertyKey.lyric.rawValue) as? MPLyricModel
        self.musicbook = coder.decodeObject(forKey: PropertyKey.musicbook.rawValue) as? MPMusicbookModel
        self.tags = coder.decodeObject(forKey: PropertyKey.tags.rawValue) as? Array<MPTagModel>
        self.intro = coder.decodeObject(forKey: PropertyKey.intro.rawValue) as? String
    }

    func encode(with coder: NSCoder) {
        coder.encode(self.id, forKey: PropertyKey.id.rawValue)
        coder.encode(self.name, forKey: PropertyKey.name.rawValue)
        coder.encode(self.url.absoluteString, forKey: PropertyKey.url.rawValue)
        coder.encode(self.artists, forKey: PropertyKey.artists.rawValue)
        coder.encode(self.album, forKey: PropertyKey.album.rawValue)
        coder.encode(self.artistImgs, forKey: PropertyKey.artistImgs.rawValue)
        coder.encode(self.albumImgs, forKey: PropertyKey.albumImgs.rawValue)
        coder.encode(self.lyric, forKey: PropertyKey.lyric.rawValue)
        coder.encode(self.musicbook, forKey: PropertyKey.musicbook.rawValue)
        coder.encode(self.tags, forKey: PropertyKey.tags.rawValue)
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
        artists
    }
    
    var audioAlbum: MPAlbumModel? {
        album
    }
    
    var audioArtistImgs: Array<URL>? {
        artistImgs
    }
    
    var audioAlbumImgs: Array<URL>? {
        albumImgs
    }
    
    var audioLyric: MPLyricModel? {
        lyric
    }
    
    var audioMusicbook: MPMusicbookModel? {
        musicbook
    }
    
    var audioTags: Array<MPTagModel>? {
        tags
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


//接口方法
extension MPSongModel: ExternalInterface
{
    
}
