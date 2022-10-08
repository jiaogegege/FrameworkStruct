//
//  MPAlbumModel.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/10/5.
//

/**
 专辑，歌曲相关
 */
import UIKit

class MPAlbumModel: OriginModel, Archivable
{
    //MARK: 属性
    var id: String
    var name: String
    var songIds: Array<String>
    var type: MPPlaylistType
    var artistIds: Array<String>
    var tagIds: Array<String>?
    var albumImgs: Array<URL>?
    var title: String?
    var detail: String?
    
    //MARK: 方法
    //创建一个新的空专辑
    init(name: String, artistIds: [String]) {
        self.id = g_uuid()
        self.name = name
        self.songIds = []
        self.type = .album
        self.artistIds = artistIds
    }
    
    required init?(coder: NSCoder) {
        guard let id = coder.decodeObject(forKey: PropertyKey.id.rawValue) as? String else { return nil }
        
        self.id = id
        self.name = coder.decodeObject(forKey: PropertyKey.name.rawValue) as! String
        self.songIds = coder.decodeObject(forKey: PropertyKey.songs.rawValue) as! [String]
        self.type = MPPlaylistType(rawValue: coder.decodeInteger(forKey: PropertyKey.type.rawValue))!
        self.artistIds = coder.decodeObject(forKey: PropertyKey.artists.rawValue) as! [String]
        self.tagIds = coder.decodeObject(forKey: PropertyKey.tags.rawValue) as? [String]
        self.albumImgs = coder.decodeObject(forKey: PropertyKey.albumImgs.rawValue) as? [URL]
        self.title = coder.decodeObject(forKey: PropertyKey.title.rawValue) as? String
        self.detail = coder.decodeObject(forKey: PropertyKey.detail.rawValue) as? String
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.id, forKey: PropertyKey.id.rawValue)
        coder.encode(self.name, forKey: PropertyKey.name.rawValue)
        coder.encode(self.songIds, forKey: PropertyKey.songs.rawValue)
        coder.encode(self.type.rawValue, forKey: PropertyKey.type.rawValue)
        coder.encode(self.artistIds, forKey: PropertyKey.artists.rawValue)
        coder.encode(self.tagIds, forKey: PropertyKey.tags.rawValue)
        coder.encode(self.albumImgs, forKey: PropertyKey.albumImgs.rawValue)
        coder.encode(self.title, forKey: PropertyKey.title.rawValue)
        coder.encode(self.detail, forKey: PropertyKey.detail.rawValue)
    }
    
}


extension MPAlbumModel: MPPlaylistProtocol
{
    var playlistId: String {
        id
    }
    
    var playlistName: String {
        name
    }
    
    var playlistAudios: Array<MPAudioProtocol> {
        MPLibraryManager.shared.getSongs(self.songIds)
    }
    
    var playlistType: MPPlaylistType {
        type
    }

    var playlistIntro: String? {
        title
    }
    
    func getPlaylist() -> MPPlaylistModel {
        MPPlaylistModel(name: name, songs: playlistAudios, type: type, intro: title)
    }
    
}


//内部类型
extension MPAlbumModel: InternalType
{
    //属性字段key定义
    enum PropertyKey: String {
        case id
        case name
        case songs
        case type
        case artists
        case tags
        case albumImgs
        case title
        case detail
    }
    
}
