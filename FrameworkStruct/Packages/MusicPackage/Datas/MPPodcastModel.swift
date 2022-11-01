//
//  MPPodcastModel.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/10/5.
//

/**
 播客信息
 暂时不开发相关功能，先留个占位
 */
import UIKit

class MPPodcastModel: OriginModel, Archivable
{
    //MARK: 属性
    var id: String
    var name: String
    var url: URL
    var isValid: Bool
    var artistIds: Array<String>?
    var artistImgs: Array<URL>?
    var podcastImgs: Array<URL>?
    var subtitleId: String?
    var tagIds: Array<String>?
    var title: String?
    var detail: String?
    
    //MARK: 方法
    //初始化一个新的播客信息
    init(name: String, url: URL) {
        self.id = g_uuid()
        self.name = name
        self.url = url
        self.isValid = true
    }
    
    required init?(coder: NSCoder) {
        guard let id = coder.decodeObject(forKey: PropertyKey.id.rawValue) as? String else { return nil }
        
        self.id = id
        self.name = coder.decodeObject(forKey: PropertyKey.name.rawValue) as! String
        self.url = coder.decodeObject(forKey: PropertyKey.url.rawValue) as! URL
        self.isValid = coder.decodeBool(forKey: PropertyKey.isValid.rawValue)
        self.artistIds = coder.decodeObject(forKey: PropertyKey.artists.rawValue) as? [String]
        self.artistImgs = coder.decodeObject(forKey: PropertyKey.artistImgs.rawValue) as? [URL]
        self.podcastImgs = coder.decodeObject(forKey: PropertyKey.podcastImgs.rawValue) as? [URL]
        self.subtitleId = coder.decodeObject(forKey: PropertyKey.subtitle.rawValue) as? String
        self.tagIds = coder.decodeObject(forKey: PropertyKey.tags.rawValue) as? [String]
        self.title = coder.decodeObject(forKey: PropertyKey.title.rawValue) as? String
        self.detail = coder.decodeObject(forKey: PropertyKey.detail.rawValue) as? String
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.id, forKey: PropertyKey.id.rawValue)
        coder.encode(self.name, forKey: PropertyKey.name.rawValue)
        coder.encode(self.url, forKey: PropertyKey.url.rawValue)
        coder.encode(self.isValid, forKey: PropertyKey.isValid.rawValue)
        coder.encode(self.artistIds, forKey: PropertyKey.artists.rawValue)
        coder.encode(self.artistImgs, forKey: PropertyKey.artistImgs.rawValue)
        coder.encode(self.podcastImgs, forKey: PropertyKey.podcastImgs.rawValue)
        coder.encode(self.subtitleId, forKey: PropertyKey.subtitle.rawValue)
        coder.encode(self.tagIds, forKey: PropertyKey.tags.rawValue)
        coder.encode(self.title, forKey: PropertyKey.title.rawValue)
        coder.encode(self.detail, forKey: PropertyKey.detail.rawValue)
    }

}


//音频信息协议
extension MPPodcastModel: MPAudioProtocol
{
    var audioId: String {
        id
    }
    
    var audioName: String {
        name
    }
    
    var audioUrl: URL {
        url
    }
    
    var isAvailable: Bool {
        get {
            isValid
        }
        set {
            isValid = newValue
        }
    }
    
    var audioArtists: Array<MPArtistModel>? {
        guard let ids = self.artistIds else { return nil }
        return MPLibraryManager.shared.getArtists(ids)
    }
    
    var audioAlbum: MPAlbumModel? {
        nil
    }
    
    var audioArtistImgs: Array<URL>? {
        artistImgs
    }
    
    var audioAlbumImgs: Array<URL>? {
        podcastImgs
    }
    
    var audioLyric: MPLyricModel? {
        guard let id = self.subtitleId else { return nil }
        return MPLibraryManager.shared.getLyric(id)
    }
    
    var audioMusicbook: MPMusicbookModel? {
        nil
    }
    
    var audioTags: Array<MPTagModel>? {
        guard let ids = self.tagIds else { return nil }
        return MPLibraryManager.shared.getTags(ids)
    }
    
    var audioIntro: String? {
        title ?? detail
    }
    
}


//内部类型
extension MPPodcastModel: InternalType
{
    //属性字段定义key
    enum PropertyKey: String {
        case id
        case name
        case url
        case isValid
        case artists
        case artistImgs
        case podcastImgs
        case subtitle
        case tags
        case title
        case detail
    }
    
}
