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
    var audios: Array<MPAudioProtocol>
    var type: MPPlaylistType
    var tagIds: Array<String>?
    var intro: String?
    
    //MARK:  方法
    //创建一个新的空播放列表
    init(name: String) {
        self.id = g_uuid()
        self.name = name
        self.audios = []
        self.type = .playlist
    }
    
    //根据现有数据创建一个播放列表，通常是从其他类型的列表转换为播放列表
    init(name: String, audios: Array<MPAudioProtocol>, type: MPPlaylistType, intro: String?) {
        self.id = g_uuid()
        self.name = name
        self.audios = audios
        self.type = type
        self.intro = intro
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let playlist = MPPlaylistModel(name: self.name)
        playlist.id = self.id
        playlist.audios = self.audios
        playlist.type = self.type
        playlist.tagIds = self.tagIds
        playlist.intro = self.intro
        
        return playlist
    }
    
    required init?(coder: NSCoder) {
        guard let id = coder.decodeObject(forKey: PropertyKey.id.rawValue) as? String else { return nil }
        
        self.id = id
        self.name = coder.decodeObject(forKey: PropertyKey.name.rawValue) as! String
        self.audios = coder.decodeObject(forKey: PropertyKey.audios.rawValue) as! [MPAudioProtocol]
        self.type = MPPlaylistType(rawValue: coder.decodeInteger(forKey: PropertyKey.type.rawValue))!
        self.tagIds = coder.decodeObject(forKey: PropertyKey.tagIds.rawValue) as? [String]
        self.intro = coder.decodeObject(forKey: PropertyKey.intro.rawValue) as? String
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.id, forKey: PropertyKey.id.rawValue)
        coder.encode(self.name, forKey: PropertyKey.name.rawValue)
        coder.encode(self.audios, forKey: PropertyKey.audios.rawValue)
        coder.encode(self.type.rawValue, forKey: PropertyKey.type.rawValue)
        coder.encode(self.tagIds, forKey: PropertyKey.tagIds.rawValue)
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
        audios
    }
    
    var playlistType: MPPlaylistType {
        type
    }

    var playlistIntro: String? {
        intro
    }
    
    func getIndexOf(audio: MPAudioProtocol?) -> Int {
        guard let au = audio else { return -1 }
        
        for (index, item) in self.audios.enumerated()
        {
            if item.audioId == au.audioId
            {
                return index
            }
        }
        
        return -1
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
        case audios
        case type
        case tagIds
        case intro
    }
    
}
