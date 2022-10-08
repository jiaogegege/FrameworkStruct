//
//  MPFavoriteModel.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/10/5.
//

/**
 我的收藏列表，指收藏的单独的歌曲、播客、有声书等
 对于一种媒体类型只会有一个我的收藏列表，且由系统默认创建，用户无法删除和创建
 */
import UIKit

class MPFavoriteModel: OriginModel, Archivable
{
    //MARK: 属性
    var id: String
    var name: String    //`我喜欢`、`我的收藏`或者其他
    var songIds: Array<String>
    var type: MPPlaylistType
    var mediaType: MPMediaType
    var images: Array<URL>?
    var intro: String?
    
    //MARK: 方法
    //创建一个空歌单
    init(name: String, mediaType: MPMediaType) {
        self.id = g_uuid()
        self.name = name
        self.songIds = []
        self.type = .favorite
        self.mediaType = mediaType
    }
    
    required init?(coder: NSCoder) {
        guard let id = coder.decodeObject(forKey: PropertyKey.id.rawValue) as? String else { return nil }
        
        self.id = id
        self.name = coder.decodeObject(forKey: PropertyKey.name.rawValue) as! String
        self.songIds = coder.decodeObject(forKey: PropertyKey.songIds.rawValue) as! [String]
        self.type = MPPlaylistType(rawValue: coder.decodeInteger(forKey: PropertyKey.type.rawValue))!
        self.mediaType = MPMediaType(rawValue: coder.decodeInteger(forKey: PropertyKey.mediaType.rawValue))!
        self.images = coder.decodeObject(forKey: PropertyKey.images.rawValue) as? [URL]
        self.intro = coder.decodeObject(forKey: PropertyKey.intro.rawValue) as? String
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.id, forKey: PropertyKey.id.rawValue)
        coder.encode(self.name, forKey: PropertyKey.name.rawValue)
        coder.encode(self.songIds, forKey: PropertyKey.songIds.rawValue)
        coder.encode(self.type.rawValue, forKey: PropertyKey.type.rawValue)
        coder.encode(self.mediaType.rawValue, forKey: PropertyKey.mediaType.rawValue)
        coder.encode(self.images, forKey: PropertyKey.images.rawValue)
        coder.encode(self.intro, forKey: PropertyKey.intro.rawValue)
    }
    
}


extension MPFavoriteModel: MPPlaylistProtocol
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
        intro
    }
    
    func getPlaylist() -> MPPlaylistModel {
        MPPlaylistModel(name: name, songs: playlistAudios, type: type, intro: intro)
    }
    
}


//内部类型
extension MPFavoriteModel: InternalType
{
    //属性字段key定义
    enum PropertyKey: String {
        case id
        case name
        case songIds
        case type
        case mediaType
        case images
        case intro
    }
    
}
