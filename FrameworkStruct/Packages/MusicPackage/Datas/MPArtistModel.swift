//
//  MPArtistModel.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/10/5.
//

/**
 艺术家
 */
import UIKit

class MPArtistModel: OriginModel, Archivable
{
    //MARK: 属性
    var id: String
    var firstName: String
    var middleName: String?
    var lastName: String
    var albumIds: Array<String>?
    var songIds: Array<String>?
    var podcastIds: Array<String>?
    var lyricIds: Array<String>?
    var artistsImgs: Array<URL>?
    var tagIds: Array<String>?
    var intro: String?
    
    //MARK: 方法
    //创建一个新艺术家
    init(firstName: String, middleName: String?, lastName: String) {
        self.id = g_uuid()
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
    }
    
    
    required init?(coder: NSCoder) {
        guard let id = coder.decodeObject(forKey: PropertyKey.id.rawValue) as? String else { return nil }
        
        self.id = id
        self.firstName = coder.decodeObject(forKey: PropertyKey.firstName.rawValue) as! String
        self.middleName = coder.decodeObject(forKey: PropertyKey.middleName.rawValue) as? String
        self.lastName = coder.decodeObject(forKey: PropertyKey.lastName.rawValue) as! String
        self.albumIds = coder.decodeObject(forKey: PropertyKey.albums.rawValue) as? [String]
        self.songIds = coder.decodeObject(forKey: PropertyKey.songs.rawValue) as? [String]
        self.podcastIds = coder.decodeObject(forKey: PropertyKey.podcasts.rawValue) as? [String]
        self.lyricIds = coder.decodeObject(forKey: PropertyKey.lyrics.rawValue) as? [String]
        self.artistsImgs = coder.decodeObject(forKey: PropertyKey.artistsImgs.rawValue) as? [URL]
        self.tagIds = coder.decodeObject(forKey: PropertyKey.tags.rawValue) as? [String]
        self.intro = coder.decodeObject(forKey: PropertyKey.intro.rawValue) as? String
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.id, forKey: PropertyKey.id.rawValue)
        coder.encode(self.firstName, forKey: PropertyKey.firstName.rawValue)
        coder.encode(self.middleName, forKey: PropertyKey.middleName.rawValue)
        coder.encode(self.lastName, forKey: PropertyKey.lastName.rawValue)
        coder.encode(self.albumIds, forKey: PropertyKey.albums.rawValue)
        coder.encode(self.songIds, forKey: PropertyKey.songs.rawValue)
        coder.encode(self.podcastIds, forKey: PropertyKey.podcasts.rawValue)
        coder.encode(self.lyricIds, forKey: PropertyKey.lyrics.rawValue)
        coder.encode(self.artistsImgs, forKey: PropertyKey.artistsImgs.rawValue)
        coder.encode(self.tagIds, forKey: PropertyKey.tags.rawValue)
        coder.encode(self.intro, forKey: PropertyKey.intro.rawValue)
    }
    
}


//内部类型
extension MPArtistModel: InternalType
{
    //属性字段key定义
    enum PropertyKey: String {
        case id
        case firstName
        case middleName
        case lastName
        case albums
        case songs
        case podcasts
        case lyrics
        case artistsImgs
        case tags
        case intro
    }
    
}


extension MPArtistModel: ExternalInterface
{
   ///获取全名
    var fullName: String {
        var full = firstName
        if let mid = middleName {
            full += mid
        }
        full += lastName
        return full
    }
    
}
