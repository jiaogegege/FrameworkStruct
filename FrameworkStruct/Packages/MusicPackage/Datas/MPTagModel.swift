//
//  MPTagModel.swift
//  FrameworkStruct
//
//  Created by jggg on 2022/10/5.
//

/**
 音乐标签，比如摇滚、现代、轻音乐、日系、国风、悲伤、喜悦等
 */
import UIKit

class MPTagModel: OriginModel, Archivable
{
    //MARK: 属性
    var id: String
    var name: String
    var intro: String?
    
    //MARK: 方法
    //创建一个新标签
    init(name: String, intro: String?) {
        self.id = g_uuid()
        self.name = name
        self.intro = intro
    }
    
    required init?(coder: NSCoder) {
        guard let id = coder.decodeObject(forKey: PropertyKey.id.rawValue) as? String else { return nil }
        
        self.id = id
        self.name = coder.decodeObject(forKey: PropertyKey.name.rawValue) as! String
        self.intro = coder.decodeObject(forKey: PropertyKey.intro.rawValue) as? String
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.id, forKey: PropertyKey.id.rawValue)
        coder.encode(self.name, forKey: PropertyKey.name.rawValue)
        coder.encode(self.intro, forKey: PropertyKey.intro.rawValue)
    }
    
}


//内部类型
extension MPTagModel: InternalType
{
    //属性字段key定义
    enum PropertyKey: String {
        case id
        case name
        case intro
    }
    
}
