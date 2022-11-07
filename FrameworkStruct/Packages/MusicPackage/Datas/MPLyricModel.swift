//
//  MPLyricModel.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/10/5.
//

/**
 歌词或字幕
 从歌词文件(.lrc)中动态获取
 */
import UIKit

class MPLyricModel: OriginModel
{
    //属性
    var url: URL        //原始歌词文件地址
    var title: String?
    var artist: String?
    var album: String?
    var lyrics: [LineLyricInfo]
    
    //方法
    init(url: URL, title: String?, artist: String?, album: String?, lyrics: [LineLyricInfo]) {
        self.url = url
        self.title = title
        self.artist = artist
        self.album = album
        self.lyrics = lyrics
    }
    
}


//一行歌词，包括时间、时间文本和歌词文本
struct LineLyricInfo {
    var time: TimeInterval
    var timeStr: String
    var lyric: String?
}
