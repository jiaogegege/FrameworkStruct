//
//  MPHistorySongModel.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/10/5.
//

/**
 歌曲播放历史记录，针对不同的媒体有不同的历史记录列表，比如歌曲、播客、有声书等
 一般由系统创建
 是一个队列，有最大容量，总是从头部push，超出容量则最先进入的pop
 */
import UIKit

class MPHistorySongModel: OriginModel, Archivable
{
    //MARK: 属性
    var id: String
    var name: String
    var mediaIds: Array<String>
    var mediaType: MPMediaType
    
    //MARK: 方法
    init(name: String, mediaType: MPMediaType) {
        self.id = g_uuid()
        self.name = name
        self.mediaIds = []
        self.mediaType = mediaType
    }
    
    required init?(coder: NSCoder) {
        guard let id = coder.decodeObject(forKey: PropertyKey.id.rawValue) as? String else { return nil }
        
        self.id = id
        self.name = coder.decodeObject(forKey: PropertyKey.name.rawValue) as! String
        self.mediaIds = coder.decodeObject(forKey: PropertyKey.mediaIds.rawValue) as! [String]
        self.mediaType = MPMediaType(rawValue: coder.decodeInteger(forKey: PropertyKey.mediaType.rawValue))!
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.id, forKey: PropertyKey.id.rawValue)
        coder.encode(self.name, forKey: PropertyKey.name.rawValue)
        coder.encode(self.mediaIds, forKey: PropertyKey.mediaIds.rawValue)
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
        case mediaIds
        case mediaType
    }
    
}
