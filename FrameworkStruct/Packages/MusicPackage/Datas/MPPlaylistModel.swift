//
//  MPPlaylistModel.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/10/5.
//

/**
 标准播放列表
 */
import UIKit

class MPPlaylistModel: OriginModel, Archivable
{
    //MARK: 属性
    var id: String
    var name: String
    var songs: Array<MPAudioProtocol>
    var type: MPPlaylistType
    var tags: Array<MPTagModel>?
    var intro: String?
    
    //MARK:  方法
    //创建一个新的空播放列表
    init(name: String) {
        self.id = g_uuid()
        self.name = name
        self.songs = []
        self.type = .playlist
    }
    
    //根据现有数据创建一个播放列表，通常是从其他类型的列表转换为播放列表
    init(name: String, songs: Array<MPAudioProtocol>, type: MPPlaylistType, intro: String?) {
        self.id = g_uuid()
        self.name = name
        self.songs = songs
        self.type = type
        self.intro = intro
    }
    
    required init?(coder: NSCoder) {
        guard let id = coder.decodeObject(forKey: PropertyKey.id.rawValue) as? String else { return nil }
        
        self.id = id
        self.name = coder.decodeObject(forKey: PropertyKey.name.rawValue) as! String
        self.songs = coder.decodeObject(forKey: PropertyKey.songs.rawValue) as! [MPAudioProtocol]
        self.type = MPPlaylistType(rawValue: coder.decodeInteger(forKey: PropertyKey.type.rawValue))!
        self.tags = coder.decodeObject(forKey: PropertyKey.tags.rawValue) as? [MPTagModel]
        self.intro = coder.decodeObject(forKey: PropertyKey.intro.rawValue) as? String
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.id, forKey: PropertyKey.id.rawValue)
        coder.encode(self.name, forKey: PropertyKey.name.rawValue)
        coder.encode(self.songs, forKey: PropertyKey.songs.rawValue)
        coder.encode(self.type.rawValue, forKey: PropertyKey.type.rawValue)
        coder.encode(self.tags, forKey: PropertyKey.tags.rawValue)
        coder.encode(self.intro, forKey: PropertyKey.intro.rawValue)
    }
    
}


extension MPPlaylistModel: MPPlaylistProtocol
{
    var playlistId: String {
        id
    }
    
    var playlistName: String {
        name
    }
    
    var playlistAudios: Array<MPAudioProtocol> {
        songs
    }
    
    var playlistType: MPPlaylistType {
        type
    }

    var playlistIntro: String? {
        intro
    }
    
    func getPlaylist() -> MPPlaylistModel {
        self
    }
    
}


//内部类型
extension MPPlaylistModel: InternalType
{
    //属性字段key定义
    enum PropertyKey: String {
        case id
        case name
        case songs
        case type
        case tags
        case intro
    }
    
}
