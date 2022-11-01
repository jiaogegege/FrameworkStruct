//
//  MPSonglistModel.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/10/5.
//

/**
 歌单
 */
import UIKit

class MPSonglistModel: OriginModel, Archivable
{
    //MARK: 属性
    var id: String
    var name: String
    var songs: Array<MPSongModel>
    var type: MPPlaylistType
    var tagIds: Array<String>?
    var images: Array<URL>?
    var intro: String?
    //应该有创建者信息，暂时不做
    
    //MARK: 方法
    //创建一个空歌单
    init(name: String) {
        self.id = g_uuid()
        self.name = name
        self.songs = []
        self.type = .songlist
    }
    
    required init?(coder: NSCoder) {
        guard let id = coder.decodeObject(forKey: PropertyKey.id.rawValue) as? String else { return nil }
        
        self.id = id
        self.name = coder.decodeObject(forKey: PropertyKey.name.rawValue) as! String
        self.songs = coder.decodeObject(forKey: PropertyKey.songs.rawValue) as! [MPSongModel]
        self.type = MPPlaylistType(rawValue: coder.decodeInteger(forKey: PropertyKey.type.rawValue))!
        self.tagIds = coder.decodeObject(forKey: PropertyKey.tagIds.rawValue) as? [String]
        self.images = coder.decodeObject(forKey: PropertyKey.images.rawValue) as? [URL]
        self.intro = coder.decodeObject(forKey: PropertyKey.intro.rawValue) as? String
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.id, forKey: PropertyKey.id.rawValue)
        coder.encode(self.name, forKey: PropertyKey.name.rawValue)
        coder.encode(self.songs, forKey: PropertyKey.songs.rawValue)
        coder.encode(self.type.rawValue, forKey: PropertyKey.type.rawValue)
        coder.encode(self.tagIds, forKey: PropertyKey.tagIds.rawValue)
        coder.encode(self.images, forKey: PropertyKey.images.rawValue)
        coder.encode(self.intro, forKey: PropertyKey.intro.rawValue)
    }
    
}


extension MPSonglistModel: MPPlaylistProtocol
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
    
    func getIndexOf(audio: MPAudioProtocol?) -> Int {
        guard let au = audio else { return -1 }
        
        for (index, item) in self.songs.enumerated()
        {
            if item.audioId == au.audioId
            {
                return index
            }
        }
        
        return -1
    }
    
    func insertAudio(audio: MPAudioProtocol, index: Int?) -> Int {
        var lastIndex: Int = -1
        if let song = audio as? MPSongModel
        {
            if let ind = index
            {
                if ind > songs.count
                {
                    lastIndex = songs.count
                }
                else
                {
                    lastIndex = ind
                }
                songs.insert(song, at: lastIndex)
            }
            else
            {
                songs.append(song)
                lastIndex = songs.count - 1
            }
        }
        return lastIndex
    }
    
    func getPlaylist() -> MPPlaylistModel {
        MPPlaylistModel(name: name, audios: playlistAudios, type: type, audioType: .song, intro: intro)
    }
    
}


//内部类型
extension MPSonglistModel: InternalType
{
    //属性字段key定义
    enum PropertyKey: String {
        case id
        case name
        case songs
        case type
        case tagIds
        case images
        case intro
    }
    
}
