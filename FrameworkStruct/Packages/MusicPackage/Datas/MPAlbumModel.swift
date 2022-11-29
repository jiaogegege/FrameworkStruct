//
//  MPAlbumModel.swift
//  FrameworkStruct
//
//  Created by jggg on 2022/10/5.
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
    var songs: Array<MPSongModel>
    var type: MPPlaylistType
    var artists: Array<MPArtistModel>?
    var tagIds: Array<String>?
    var albumImgs: Array<URL>?
    var title: String?
    var detail: String?
    
    //MARK: 方法
    //创建一个新的空专辑
    init(name: String) {
        self.id = g_uuid()
        self.name = name
        self.songs = []
        self.type = .album
    }
    
    required init?(coder: NSCoder) {
        guard let id = coder.decodeObject(forKey: PropertyKey.id.rawValue) as? String else { return nil }
        
        self.id = id
        self.name = coder.decodeObject(forKey: PropertyKey.name.rawValue) as! String
        self.songs = coder.decodeObject(forKey: PropertyKey.songs.rawValue) as! [MPSongModel]
        self.type = MPPlaylistType(rawValue: coder.decodeInteger(forKey: PropertyKey.type.rawValue))!
        self.artists = coder.decodeObject(forKey: PropertyKey.artists.rawValue) as? [MPArtistModel]
        self.tagIds = coder.decodeObject(forKey: PropertyKey.tags.rawValue) as? [String]
        self.albumImgs = coder.decodeObject(forKey: PropertyKey.albumImgs.rawValue) as? [URL]
        self.title = coder.decodeObject(forKey: PropertyKey.title.rawValue) as? String
        self.detail = coder.decodeObject(forKey: PropertyKey.detail.rawValue) as? String
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.id, forKey: PropertyKey.id.rawValue)
        coder.encode(self.name, forKey: PropertyKey.name.rawValue)
        coder.encode(self.songs, forKey: PropertyKey.songs.rawValue)
        coder.encode(self.type.rawValue, forKey: PropertyKey.type.rawValue)
        coder.encode(self.artists, forKey: PropertyKey.artists.rawValue)
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
        songs
    }
    
    var playlistType: MPPlaylistType {
        type
    }

    var playlistIntro: String? {
        title
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
    
    func deleteAudio(_ audio: MPAudioProtocol) -> Bool {
        var ret = false
        let index = self.getIndexOf(audio: audio)
        if index >= 0   //找到了，可以删除
        {
            self.songs.remove(at: index)
            ret = true
        }
        return ret
    }
    
    func getPlaylist() -> MPPlaylistModel {
        MPPlaylistModel(id: id, name: name, audios: playlistAudios, type: type, audioType: .song, intro: title)
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
