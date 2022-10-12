//
//  MPHistoryPlaylistModel.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/10/5.
//

/**
 播放列表历史记录，包括播放列表、专辑、歌单等
 可记录播放过的播放列表，方便返回之前的播放列表继续播放
 */
import UIKit

class MPHistoryPlaylistModel: OriginModel, Archivable
{
    //MARK: 属性
    var id: String
    var name: String
    var listIds: Array<String>
    var type: MPPlaylistType
    
    //MARK: 方法
    init(name: String, type: MPPlaylistType) {
        self.id = g_uuid()
        self.name = name
        self.listIds = []
        self.type = type
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let model = MPHistoryPlaylistModel(name: self.name, type: self.type)
        model.id = self.id
        model.listIds = self.listIds
        
        return model
    }
    
    required init?(coder: NSCoder) {
        guard let id = coder.decodeObject(forKey: PropertyKey.id.rawValue) as? String else { return nil }
        
        self.id = id
        self.name = coder.decodeObject(forKey: PropertyKey.name.rawValue) as! String
        self.listIds = coder.decodeObject(forKey: PropertyKey.listIds.rawValue) as! [String]
        self.type = MPPlaylistType(rawValue: coder.decodeInteger(forKey: PropertyKey.type.rawValue))!
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.id, forKey: PropertyKey.id.rawValue)
        coder.encode(self.name, forKey: PropertyKey.name.rawValue)
        coder.encode(self.listIds, forKey: PropertyKey.listIds.rawValue)
        coder.encode(self.type.rawValue, forKey: PropertyKey.type.rawValue)
    }
    
}


//内部类型
extension MPHistoryPlaylistModel: InternalType
{
    //属性字段key定义
    enum PropertyKey: String {
        case id
        case name
        case listIds
        case type
    }
    
}

