//
//  MPFavoriteListModel.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/10/8.
//

/**
 收藏其他列表，比如歌单、播客单、专辑等
 暂时不做
 */
import UIKit

class MPFavoriteListModel: OriginModel, Archivable
{
    //MARK: 属性
    var id: String
    var name: String    //`我收藏的歌单`等
    var listIds: Array<String>
    var type: MPPlaylistType
    var intro: String?
    
    //MARK: 方法
    //创建一个空的列表
    init(name: String, type: MPPlaylistType, intro: String?) {
        self.id = g_uuid()
        self.name = name
        self.listIds = []
        self.type = type
        self.intro = intro
    }
    
    required init?(coder: NSCoder) {
        guard let id = coder.decodeObject(forKey: PropertyKey.id.rawValue) as? String else { return nil }
        
        self.id = id
        self.name = coder.decodeObject(forKey: PropertyKey.name.rawValue) as! String
        self.listIds = coder.decodeObject(forKey: PropertyKey.listIds.rawValue) as! [String]
        self.type = MPPlaylistType(rawValue: coder.decodeInteger(forKey: PropertyKey.type.rawValue))!
        self.intro = coder.decodeObject(forKey: PropertyKey.intro.rawValue) as? String
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.id, forKey: PropertyKey.id.rawValue)
        coder.encode(self.name, forKey: PropertyKey.name.rawValue)
        coder.encode(self.listIds, forKey: PropertyKey.listIds.rawValue)
        coder.encode(self.type.rawValue, forKey: PropertyKey.type.rawValue)
        coder.encode(self.intro, forKey: PropertyKey.intro.rawValue)
    }
    
}


//内部类型
extension MPFavoriteListModel: InternalType
{
    //属性字段key定义
    enum PropertyKey: String {
        case id
        case name
        case listIds
        case type
        case intro
    }
    
}
