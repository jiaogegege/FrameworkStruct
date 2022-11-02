//
//  MPConst.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/10/6.
//


/**
 音乐播放器常量和定义
 */
import Foundation

/**
 音频信息协议，返回歌曲的一些信息，用于播放器播放音频，比如歌曲，播客，有声图书等
 */
protocol MPAudioProtocol {
    //音频id
    var audioId: String {get}
    
    //音频名字
    var audioName: String {get}
    
    //url或文件路径
    var audioUrl: URL {get}
    
    //是否可用
    var isAvailable: Bool {get set}
    
    //艺术家/创作者
    var audioArtists: Array<MPArtistModel>? {get}
    
    //专辑
    var audioAlbum: MPAlbumModel? {get}
    
    //艺术家图片，图片地址列表
    var audioArtistImgs: Array<URL>? {get}
    
    //专辑或歌曲图片，图片地址列表
    var audioAlbumImgs: Array<URL>? {get}
    
    //歌词或字幕
    var audioLyric: MPLyricModel? {get}
    
    //乐谱
    var audioMusicbook: MPMusicbookModel? {get}
    
    //标签
    var audioTags: Array<MPTagModel>? {get}
    
    //描述信息
    var audioIntro: String? {get}
}

/**
 播放列表协议，需要被支持播放列表功能的对象实现，比如标准播放列表、歌单、专辑等
 */
protocol MPPlaylistProtocol {
    //播放列表id
    var playlistId: String {get}
    
    //播放列表name
    var playlistName: String {get}
    
    //音频列表
    var playlistAudios: Array<MPAudioProtocol> {get}
    
    //播放列表类型
    var playlistType: MPPlaylistType {get}
    
    //播放列表简介
    var playlistIntro: String? {get}
    
    //获取某个音频在列表中的位置，没有返回-1
    func getIndexOf(audio: MPAudioProtocol?) -> Int
    
    //在播放列表中插入一首歌曲，有index则插入指定的index，不能超过范围；如果没有则插入到最末尾；返回实际插入的index；返回-1表示插入不成功
    func insertAudio(audio: MPAudioProtocol, index: Int?) -> Int
    
    //删除播放列表中的一首歌曲，没有则什么都不做，返回是否删除成功
    func deleteAudio(_ audio: MPAudioProtocol) -> Bool
    
    //获取标准播放列表
    func getPlaylist() -> MPPlaylistModel
}

///资源库类型，根据实际需求增减
enum MPLibraryType: Int {
    case local = 0                  //来自本地沙盒的音乐资源，可以手动导入或下载
    case iCloud = 1                 //来自icloud的音乐资源，可以手动上传
    case iTunes = 2                 //来自iTunes的音乐资源，暂时不实现
    case others = 3                 //其它音乐资源
}

///播放列表类型，根据实际需求增减
enum MPPlaylistType: Int {
    case playlist = 0               //标准播放列表
    
    case songlist = 1               //歌单
    case favorite = 2               //我喜欢
    case album = 3                  //专辑
    case podcast = 4                //播客
    case stage = 5                  //场景
    case mood = 6                   //心情
}

///媒体类型，比如音乐、播客、有声书等
enum MPAudioType: Int {
    case song = 0                   //乐曲
    case podcast = 1                //播客
    case audioBook = 2              //有声书
}

///资源库资源类型
enum MPLibraryResourceType {
    case songs                  //歌曲
    case albums                 //专辑
    case artists                //艺术家
    case lyrics                 //歌词或字幕
    case musicbooks             //乐谱
    case podcasts               //播客
    case audiobooks             //有声书
}

///播放速率
enum MPPlayRate: Float {
    case quarter = 0.25
    case half = 0.5
    case threeQuarter = 0.75
    case one = 1.0
    case oneQuarter = 1.25
    case oneHalf = 1.5
    case oneThreeQuarter = 1.75
    case two = 2.0
    case twoHalf = 2.5
    case three = 3.0
}

///历史记录最多记录多少歌曲
let MPMaxHistorySongCount: Int = 300
