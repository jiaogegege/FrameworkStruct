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
    var audios: Array<MPAudioProtocol>
    var type: MPPlaylistType
    var audioType: MPAudioType
    var images: Array<URL>?
    var intro: String?
    
    //MARK: 方法
    //创建一个空收藏列表
    init(name: String, mediaType: MPAudioType) {
        self.id = g_uuid()
        self.name = name
        self.audios = []
        self.type = .favorite
        self.audioType = mediaType
    }
    
    required init?(coder: NSCoder) {
        guard let id = coder.decodeObject(forKey: PropertyKey.id.rawValue) as? String else { return nil }
        
        self.id = id
        self.name = coder.decodeObject(forKey: PropertyKey.name.rawValue) as! String
        self.audios = coder.decodeObject(forKey: PropertyKey.audios.rawValue) as! [MPSongModel]
        self.type = MPPlaylistType(rawValue: coder.decodeInteger(forKey: PropertyKey.type.rawValue))!
        self.audioType = MPAudioType(rawValue: coder.decodeInteger(forKey: PropertyKey.audioType.rawValue))!
        self.images = coder.decodeObject(forKey: PropertyKey.images.rawValue) as? [URL]
        self.intro = coder.decodeObject(forKey: PropertyKey.intro.rawValue) as? String
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.id, forKey: PropertyKey.id.rawValue)
        coder.encode(self.name, forKey: PropertyKey.name.rawValue)
        coder.encode(self.audios, forKey: PropertyKey.audios.rawValue)
        coder.encode(self.type.rawValue, forKey: PropertyKey.type.rawValue)
        coder.encode(self.audioType.rawValue, forKey: PropertyKey.audioType.rawValue)
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
    
    func insertAudio(audio: MPAudioProtocol, index: Int?) -> Int {
        var lastIndex: Int
        if let ind = index
        {
            if ind > audios.count
            {
                lastIndex = audios.count
            }
            else
            {
                lastIndex = ind
            }
            audios.insert(audio, at: lastIndex)
        }
        else
        {
            audios.append(audio)
            lastIndex = audios.count - 1
        }
        return lastIndex
    }
    
    func getPlaylist() -> MPPlaylistModel {
        MPPlaylistModel(name: name, audios: playlistAudios, type: type, audioType: audioType, intro: intro)
    }
    
}


//内部类型
extension MPFavoriteModel: InternalType
{
    //属性字段key定义
    enum PropertyKey: String {
        case id
        case name
        case audios
        case type
        case audioType
        case images
        case intro
    }
    
}
