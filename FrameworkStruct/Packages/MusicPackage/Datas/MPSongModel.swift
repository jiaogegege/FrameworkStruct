//
//  MPSongModel.swift
//  FrameworkStruct
//
//  Created by jggg on 2022/10/5.
//

/**
 歌曲信息
 */
import UIKit

class MPSongModel: OriginModel, Archivable
{
    //MARK: 属性
    var id: String                          //歌曲在媒体库中的id
    var name: String                        //歌曲名
    var url: URL                            //歌曲地址
    var isFavorite: Bool                    //是否收藏
    var isExist: Bool                       //是否存在
    var artistIds: Array<String>?           //艺术家ids
    var albumId: String?                    //专辑id
    var artistImgs: Array<URL>?             //艺术家头像地址
    var albumImgs: Array<URL>?              //专辑图片地址
    var lyricId: String?                    //歌词对象id
    var musicbookId: String?                //乐谱对象id
    var tagIds: Array<String>?              //标签ids
    var intro: String?                      //详细介绍
    
    //非持久化属性
    var asset: [MPEmbellisher.SongMetaDataKey: Any]?    //歌曲文件的一些信息
    var fileInfo: IADocumentSearchResult?       //文件系统信息
    
    
    //MARK: 方法
    //初始化一个新的歌曲信息
    init(name: String, url: URL) {
        self.id = g_uuid()
        self.name = name
        self.url = url
        self.isFavorite = false
        self.isExist = true
        super.init()
        self.asset = MPEmbellisher.shared.parseSongMeta(self)
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let song = MPSongModel(name: self.name, url: self.url)
        song.id = self.id
        song.isFavorite = self.isFavorite
        song.isExist = self.isExist
        song.artistIds = self.artistIds
        song.albumId = self.albumId
        song.artistImgs = self.artistImgs
        song.albumImgs = self.albumImgs
        song.lyricId = self.lyricId
        song.musicbookId = self.musicbookId
        song.tagIds = self.tagIds
        song.intro = self.intro
        song.asset = MPEmbellisher.shared.parseSongMeta(self)
        return song
    }
    
    required init?(coder: NSCoder) {
        guard let id = coder.decodeObject(forKey: PropertyKey.id.rawValue) as? String else { return nil }
        
        self.id = id
        self.name = coder.decodeObject(forKey: PropertyKey.name.rawValue) as! String
        self.url = coder.decodeObject(forKey: PropertyKey.url.rawValue) as! URL
        self.isFavorite = coder.decodeBool(forKey: PropertyKey.isFavorite.rawValue)
        self.isExist = coder.decodeBool(forKey: PropertyKey.isExist.rawValue)
        self.artistIds = coder.decodeObject(forKey: PropertyKey.artists.rawValue) as? [String]
        self.albumId = coder.decodeObject(forKey: PropertyKey.album.rawValue) as? String
        self.artistImgs = coder.decodeObject(forKey: PropertyKey.artistImgs.rawValue) as? Array<URL>
        self.albumImgs = coder.decodeObject(forKey: PropertyKey.albumImgs.rawValue) as? Array<URL>
        self.lyricId = coder.decodeObject(forKey: PropertyKey.lyric.rawValue) as? String
        self.musicbookId = coder.decodeObject(forKey: PropertyKey.musicbook.rawValue) as? String
        self.tagIds = coder.decodeObject(forKey: PropertyKey.tags.rawValue) as? [String]
        self.intro = coder.decodeObject(forKey: PropertyKey.intro.rawValue) as? String
        super.init()
        asset = MPEmbellisher.shared.parseSongMeta(self)
    }

    func encode(with coder: NSCoder) {
        coder.encode(self.id, forKey: PropertyKey.id.rawValue)
        coder.encode(self.name, forKey: PropertyKey.name.rawValue)
        coder.encode(self.url, forKey: PropertyKey.url.rawValue)
        coder.encode(self.isFavorite, forKey: PropertyKey.isFavorite.rawValue)
        coder.encode(self.isExist, forKey: PropertyKey.isExist.rawValue)
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
    
    var isAvailable: Bool {
        get {
            isExist
        }
        set {
            isExist = newValue
        }
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
        case isFavorite
        case isExist
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
    ///组合了歌曲名/艺术家名/专辑名的字符串，用于搜索
    var fullDescription: String {
        self.name + (self.asset?[.artist] as? String ?? "") + (self.asset?[.albumName] as? String ?? "") + (self.intro ?? "")
    }
    
    ///更新mp3文件信息
    func updateAsset()
    {
        self.asset = MPEmbellisher.shared.parseSongMeta(self)
    }
    
    ///是否已经下载
    var isDownloaded: Bool {
        if let info = self.fileInfo
        {
            //如果是没有下载的，那么从媒体库更新信息
            if info.downloadingStatus == NSMetadataUbiquitousItemDownloadingStatusNotDownloaded
            {
                guard let info = MPEmbellisher.shared.getSongFileInfo(self) else {
                    return false
                }
                return info.downloadingStatus == NSMetadataUbiquitousItemDownloadingStatusDownloaded || self.fileInfo?.downloadingStatus == NSMetadataUbiquitousItemDownloadingStatusCurrent
            }
            else
            {
                return info.downloadingStatus == NSMetadataUbiquitousItemDownloadingStatusDownloaded || self.fileInfo?.downloadingStatus == NSMetadataUbiquitousItemDownloadingStatusCurrent
            }
        }
        else
        {
            guard let info = MPEmbellisher.shared.getSongFileInfo(self) else {
                return false
            }
            return info.downloadingStatus == NSMetadataUbiquitousItemDownloadingStatusDownloaded || self.fileInfo?.downloadingStatus == NSMetadataUbiquitousItemDownloadingStatusCurrent
        }
    }
    
}
