//
//  MPPlaylistModel.swift
//  FrameworkStruct
//
//  Created by jggg on 2022/10/5.
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
    var audioType: MPAudioType
    var tagIds: Array<String>?
    var intro: String?
    
    //MARK:  方法
    //创建一个新的空播放列表
    init(name: String, audioType: MPAudioType) {
        self.id = g_uuid()
        self.name = name
        self.audios = []
        self.type = .playlist
        self.audioType = audioType
    }
    
    //根据现有数据创建一个播放列表，通常是从其他类型的列表转换为播放列表
    init(id: String?, name: String, audios: Array<MPAudioProtocol>, type: MPPlaylistType, audioType: MPAudioType, intro: String?) {
        self.id = id ?? g_uuid()
        self.name = name
        self.audios = audios
        self.type = type
        self.audioType = audioType
        self.intro = intro
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let playlist = MPPlaylistModel(name: self.name, audioType: self.audioType)
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
        self.audioType = MPAudioType(rawValue: coder.decodeInteger(forKey: PropertyKey.audioType.rawValue))!
        self.tagIds = coder.decodeObject(forKey: PropertyKey.tagIds.rawValue) as? [String]
        self.intro = coder.decodeObject(forKey: PropertyKey.intro.rawValue) as? String
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.id, forKey: PropertyKey.id.rawValue)
        coder.encode(self.name, forKey: PropertyKey.name.rawValue)
        coder.encode(self.audios, forKey: PropertyKey.audios.rawValue)
        coder.encode(self.type.rawValue, forKey: PropertyKey.type.rawValue)
        coder.encode(self.audioType.rawValue, forKey: PropertyKey.audioType.rawValue)
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
    
    func deleteAudio(_ audio: MPAudioProtocol) -> Bool {
        var ret = false
        let index = self.getIndexOf(audio: audio)
        if index >= 0   //找到了，可以删除
        {
            self.audios.remove(at: index)
            ret = true
        }
        return ret
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
        case audioType
        case tagIds
        case intro
    }
    
}


//外部接口
extension MPPlaylistModel: ExternalInterface
{
    ///diff歌曲对象，已经存在库中则替换，没有则标记为不可用
    func updateAudios(_ audios: [MPAudioProtocol])
    {
        let libAudioIds = audios.map { audio in
            audio.audioId
        }
        let playlistAudioIds = self.audios.map { audio in
            audio.audioId
        }
        for (index, audioId) in playlistAudioIds.enumerated()
        {
            if libAudioIds.contains(audioId) //如果库中存在该歌曲，那么用库中的歌曲替换
            {
                if let libIndex = libAudioIds.firstIndex(of: audioId), libIndex >= 0, libIndex < audios.count
                {
                    self.audios[index] = audios[libIndex]
                }
                else    //没找到则标记为不可用
                {
                    self.audios[index].isAvailable = false
                }
            }
            else    //不存在，则标记为不可用
            {
                self.audios[index].isAvailable = false
            }
        }
    }
    
}
