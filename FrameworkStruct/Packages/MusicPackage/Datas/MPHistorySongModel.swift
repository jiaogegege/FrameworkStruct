//
//  MPHistorySongModel.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/10/5.
//

/**
 歌曲播放历史记录
 一般由系统创建
 是一个队列，有最大容量，总是从头部push，超出容量则最先进入的pop
 */
import UIKit

class MPHistorySongModel: OriginModel, Archivable
{
    //MARK: 属性
    var id: String
    var name: String
    var medias: Array<MPAudioProtocol>
    var mediaType: MPMediaType
    
    //MARK: 方法
    init(name: String, mediaType: MPMediaType) {
        self.id = g_uuid()
        self.name = name
        self.medias = []
        self.mediaType = mediaType
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let model = MPHistorySongModel(name: self.name, mediaType: self.mediaType)
        model.id = self.id
        model.medias = self.medias
        
        return model
    }
    
    required init?(coder: NSCoder) {
        guard let id = coder.decodeObject(forKey: PropertyKey.id.rawValue) as? String else { return nil }
        
        self.id = id
        self.name = coder.decodeObject(forKey: PropertyKey.name.rawValue) as! String
        self.medias = coder.decodeObject(forKey: PropertyKey.medias.rawValue) as! [MPAudioProtocol]
        self.mediaType = MPMediaType(rawValue: coder.decodeInteger(forKey: PropertyKey.mediaType.rawValue))!
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.id, forKey: PropertyKey.id.rawValue)
        coder.encode(self.name, forKey: PropertyKey.name.rawValue)
        coder.encode(self.medias, forKey: PropertyKey.medias.rawValue)
        coder.encode(self.mediaType.rawValue, forKey: PropertyKey.mediaType.rawValue)
    }
    
}


//内部类型
extension MPHistorySongModel: InternalType
{
    //属性字段key定义
    enum PropertyKey: String {
        case id
        case name
        case medias
        case mediaType
    }
    
}
