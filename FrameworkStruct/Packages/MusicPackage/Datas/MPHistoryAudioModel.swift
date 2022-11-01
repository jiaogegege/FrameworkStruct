//
//  MPHistoryAudioModel.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/10/5.
//

/**
 音频播放历史记录
 一般由系统创建，可能是音乐、播客、有声书
 是一个队列，有最大容量，总是从头部push，超出容量则最先进入的pop
 */
import UIKit

class MPHistoryAudioModel: OriginModel, Archivable
{
    //MARK: 属性
    var id: String
    var name: String
    var audios: Array<MPAudioProtocol>
    var mediaType: MPAudioType
    var capacity: Int
    
    //MARK: 方法
    init(name: String, mediaType: MPAudioType) {
        self.id = g_uuid()
        self.name = name
        self.audios = []
        self.mediaType = mediaType
        self.capacity = MPMaxHistorySongCount
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let model = MPHistoryAudioModel(name: self.name, mediaType: self.mediaType)
        model.id = self.id
        model.audios = self.audios
        model.capacity = self.capacity
        return model
    }
    
    required init?(coder: NSCoder) {
        guard let id = coder.decodeObject(forKey: PropertyKey.id.rawValue) as? String else { return nil }
        
        self.id = id
        self.name = coder.decodeObject(forKey: PropertyKey.name.rawValue) as! String
        self.audios = coder.decodeObject(forKey: PropertyKey.audios.rawValue) as! [MPAudioProtocol]
        self.mediaType = MPAudioType(rawValue: coder.decodeInteger(forKey: PropertyKey.mediaType.rawValue))!
        self.capacity = coder.decodeInteger(forKey: PropertyKey.capacity.rawValue)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.id, forKey: PropertyKey.id.rawValue)
        coder.encode(self.name, forKey: PropertyKey.name.rawValue)
        coder.encode(self.audios, forKey: PropertyKey.audios.rawValue)
        coder.encode(self.mediaType.rawValue, forKey: PropertyKey.mediaType.rawValue)
        coder.encode(self.capacity, forKey: PropertyKey.capacity.rawValue)
    }
    
}


//内部类型
extension MPHistoryAudioModel: InternalType
{
    //属性字段key定义
    enum PropertyKey: String {
        case id
        case name
        case audios
        case mediaType
        case capacity
    }
    
}


extension MPHistoryAudioModel: ExternalInterface
{
    ///新增一个音频历史记录
    func addAudio(_ audio: MPAudioProtocol)
    {
        var existIndex: Int = -1    //是否已经存在历史记录
        for (index, item) in self.audios.enumerated()
        {
            if audio.audioId == item.audioId
            {
                existIndex = index
                break
            }
        }
        //说明已经存在了，那么提到最前的位置
        if existIndex >= 0 {
            self.audios.remove(at: existIndex)
        }
        //最多不超过最大容量
        if self.audios.count >= self.capacity
        {
            self.audios.removeLast()
        }
        self.audios.insert(audio, at: 0)
    }
    
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
