//
//  MPEmbellisher.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/10/17.
//

/**
 MusicManager相关资源的处理，比如歌词解析、歌曲信息处理等
 */
import UIKit
import AVFoundation

class MPEmbellisher: OriginEmbellisher, SingletonProtocol
{
    typealias Singleton = MPEmbellisher
    
    //MARK: 属性
    //单例
    static let shared = MPEmbellisher()
    
    
    //MARK: 方法
    //私有化初始化方法
    private override init()
    {
        super.init()
    }
    
    override func copy() -> Any
    {
        return self
    }
    
    override func mutableCopy() -> Any
    {
        return self
    }

}


//内部类型
extension MPEmbellisher: InternalType
{
    //获取的歌曲元数据，可能有些值没有
    enum SongMetaDataKey: String {
        case id                             //歌曲的id
        case url                            //地址
        case title                          //标题
        case creator                        //创建者
        case subject                        //主题
        case description                    //注释
        case publisher                      //发布者
        case contributor                    //贡献者
        case createDate                     //创建时间
        case lastModifiedDate               //最后修改时间
        case type                           //流派
        case format                         //格式
        case identifier                     //标志符
        case source                         //源
        case language                       //语言
        case relation                       //关系
        case location                       //地区
        case copyrights                     //版权
        case albumName                      //专辑名
        case author                         //作者
        case artist                         //艺术家
        case artwork                        //封面
        case make                           //
        case model                          //
        case software                       //制作软件
        case accessibilityDescription       //
    }
    
}


//接口方法
extension MPEmbellisher: ExternalInterface
{
    ///解析歌曲文件中的元数据
    func parseSongMeta(_ audio: MPAudioProtocol) -> [SongMetaDataKey: Any]
    {
        var metaDatas = [SongMetaDataKey: Any]()
        metaDatas[.id] = audio.audioId
        metaDatas[.url] = audio.audioUrl
        let asset = AVURLAsset(url: audio.audioUrl)
        for format in asset.availableMetadataFormats
        {
            for item in asset.metadata(forFormat: format)
            {
                if item.commonKey == .commonKeyTitle
                {
                    if let title = item.stringValue {
                        metaDatas[.title] = title
                    }
                    else
                    {
                        metaDatas[.title] = audio.audioName
                    }
                }
                else if item.commonKey == .commonKeyCreator
                {
                    if let creator = item.stringValue {
                        metaDatas[.creator] = creator
                    }
                }
                else if item.commonKey == .commonKeySubject
                {
                    if let subject = item.stringValue {
                        metaDatas[.subject] = subject
                    }
                }
                else if item.commonKey == .commonKeyDescription
                {
                    if let desc = item.stringValue {
                        metaDatas[.description] = desc
                    }
                    else if let des = audio.audioIntro
                    {
                        metaDatas[.description] = des
                    }
                }
                else if item.commonKey == .commonKeyPublisher
                {
                    if let publisher = item.stringValue {
                        metaDatas[.publisher] = publisher
                    }
                    else if let artist = audio.audioArtists?.first?.fullName
                    {
                        metaDatas[.publisher] = artist
                    }
                }
                else if item.commonKey == .commonKeyContributor
                {
                    if let con = item.stringValue {
                        metaDatas[.contributor] = con
                    }
                }
                else if item.commonKey == .commonKeyCreationDate
                {
                    if let createDate = item.dateValue {
                        metaDatas[.createDate] = createDate
                    }
                }
                else if item.commonKey == .commonKeyLastModifiedDate
                {
                    if let modify = item.dateValue {
                        metaDatas[.lastModifiedDate] = modify
                    }
                }
                else if item.commonKey == .commonKeyType
                {
                    if let type = item.stringValue {
                        metaDatas[.type] = type
                    }
                }
                else if item.commonKey == .commonKeyFormat
                {
                    if let format = item.stringValue {
                        metaDatas[.format] = format
                    }
                }
                else if item.commonKey == .commonKeyIdentifier
                {
                    if let id = item.stringValue {
                        metaDatas[.identifier] = id
                    }
                    else
                    {
                        metaDatas[.identifier] = audio.audioId
                    }
                }
                else if item.commonKey == .commonKeySource
                {
                    if let source = item.stringValue {
                        metaDatas[.source] = source
                    }
                }
                else if item.commonKey == .commonKeyLanguage
                {
                    if let lag = item.stringValue {
                        metaDatas[.language] = lag
                    }
                }
                else if item.commonKey == .commonKeyRelation
                {
                    if let rela = item.stringValue {
                        metaDatas[.relation] = rela
                    }
                }
                else if item.commonKey == .commonKeyLocation
                {
                    if let loc = item.stringValue {
                        metaDatas[.location] = loc
                    }
                }
                else if item.commonKey == .commonKeyCopyrights
                {
                    if let cp = item.stringValue {
                        metaDatas[.copyrights] = cp
                    }
                }
                else if item.commonKey == .commonKeyAlbumName
                {
                    if let al = item.stringValue {
                        metaDatas[.albumName] = al
                    }
                    else if let album = audio.audioAlbum?.name
                    {
                        metaDatas[.albumName] = album
                    }
                }
                else if item.commonKey == .commonKeyAuthor
                {
                    if let author = item.stringValue {
                        metaDatas[.author] = author
                    }
                    else if let artist = audio.audioArtists?.first?.fullName
                    {
                        metaDatas[.author] = artist
                    }
                }
                else if item.commonKey == .commonKeyArtist
                {
                    if let artist = item.stringValue {
                        metaDatas[.artist] = artist
                    }
                    else if let artist = audio.audioArtists?.first?.fullName
                    {
                        metaDatas[.artist] = artist
                    }
                }
                else if item.commonKey == .commonKeyArtwork
                {
                    if let artwork = item.dataValue, let img = UIImage(data: artwork) {
                        metaDatas[.artwork] = img
                    }
                }
                else if item.commonKey == .commonKeyMake
                {
                    if let make = item.stringValue {
                        metaDatas[.make] = make
                    }
                }
                else if item.commonKey == .commonKeyModel
                {
                    if let model = item.stringValue {
                        metaDatas[.model] = model
                    }
                }
                else if item.commonKey == .commonKeySoftware
                {
                    if let soft = item.stringValue {
                        metaDatas[.software] = soft
                    }
                }
            }
        }
        
        return metaDatas
    }
    
    ///获取某一首歌曲的原始文件信息
    func getSongFileInfo(_ song: MPSongModel) -> IADocumentSearchResult?
    {
        guard let info = MPContainer.shared.getSongFileInfo(song) else { return nil }
        
        song.fileInfo = info
        return info
    }
    
    ///随机获取一个歌单的图标文件路径
    func getSonglistIcon() -> URL
    {
        //随机计算文件名
        let index = randomIn(0, 3)
        let path = SandBoxAccessor.shared.getBundleFilePath("mp_songlist_icon_\(index)", ext: "jpg")
        return URL(fileURLWithPath: path!)
    }
    
}
