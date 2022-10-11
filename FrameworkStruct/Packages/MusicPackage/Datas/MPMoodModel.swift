//
//  MPMoodModel.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/10/5.
//

/**
 心情，可以将音乐收藏到心情中
 */
import UIKit

class MPMoodModel: OriginModel, Archivable
{
    //MARK: 属性
    var id: String
    var name: String
    var songs: Array<MPSongModel>
    var type: MPPlaylistType
    var images: Array<URL>?
    var intro: String?
    
    //MARK: 方法
    //创建一个空心情
    init(name: String) {
        self.id = g_uuid()
        self.name = name
        self.songs = []
        self.type = .mood
    }
    
    required init?(coder: NSCoder) {
        guard let id = coder.decodeObject(forKey: PropertyKey.id.rawValue) as? String else { return nil }
        
        self.id = id
        self.name = coder.decodeObject(forKey: PropertyKey.name.rawValue) as! String
        self.songs = coder.decodeObject(forKey: PropertyKey.songs.rawValue) as! [MPSongModel]
        self.type = MPPlaylistType(rawValue: coder.decodeInteger(forKey: PropertyKey.type.rawValue))!
        self.images = coder.decodeObject(forKey: PropertyKey.images.rawValue) as? [URL]
        self.intro = coder.decodeObject(forKey: PropertyKey.intro.rawValue) as? String
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.id, forKey: PropertyKey.id.rawValue)
        coder.encode(self.name, forKey: PropertyKey.name.rawValue)
        coder.encode(self.songs, forKey: PropertyKey.songs.rawValue)
        coder.encode(self.type.rawValue, forKey: PropertyKey.type.rawValue)
        coder.encode(self.images, forKey: PropertyKey.images.rawValue)
        coder.encode(self.intro, forKey: PropertyKey.intro.rawValue)
    }
    
}


extension MPMoodModel: MPPlaylistProtocol
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
        MPPlaylistModel(name: name, songs: playlistAudios, type: type, intro: intro)
    }
    
}


//内部类型
extension MPMoodModel: InternalType
{
    //属性字段key定义
    enum PropertyKey: String {
        case id
        case name
        case songs
        case type
        case images
        case intro
    }
    
}
