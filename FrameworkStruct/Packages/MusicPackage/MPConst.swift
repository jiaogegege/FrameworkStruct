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
    
    //播放列表标签
    var playlistTags: Array<MPTagModel>? {get}
    
    //播放列表简介
    var playlistIntro: String? {get}
    
    //获取标准播放列表
    func getPlaylist() -> MPPlaylistModel
}

///数据源类型，根据实际需求增减
enum MPMediaSource {
    case iCloud             //来自icloud的音乐资源，可以手动上传
    case local              //来自本地沙盒的音乐资源，可以手动导入或下载
    case iTunes             //来自iTunes的音乐资源，暂时不实现
    case other              //其它音乐资源
}

///播放列表类型，根据实际需求增减
enum MPPlaylistType {
    case playlist               //标准播放列表
    case songlist               //歌单
    case favorite               //我的收藏
    case album                  //专辑
    case podcast                //播客
    case category               //类别
    case stage                  //场景
    case mood                   //心情
}
