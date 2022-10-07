//
//  MPPlaylistModel.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/10/5.
//

/**
 标准播放列表
 */
import UIKit

class MPPlaylistModel: OriginModel
{
    //MARK: 属性
    var id: String
    var name: String
    var songs: Array<MPAudioProtocol>
    var type: MPPlaylistType
    var tags: Array<MPTagModel>?
    var intro: String?
    
    //MARK:  方法
    //创建一个新的空播放列表
    init(name: String) {
        self.id = g_uuid()
        self.name = name
        self.songs = []
        self.type = .playlist
    }
    
    //根据现有数据创建一个播放列表
    init(name: String, songs: Array<MPAudioProtocol>, type: MPPlaylistType, tags: Array<MPTagModel>?, intro: String?) {
        self.id = g_uuid()
        self.name = name
        self.songs = songs
        self.type = type
        self.tags = tags
        self.intro = intro
    }
    
    //加载一个现有的播放列表
    
}


extension MPPlaylistModel: MPPlaylistProtocol
{
    var playlistId: String {
        id
    }
    
    var playlistName: String {
        name
    }
    
    var playlistAudios: Array<MPAudioProtocol> {
        songs
    }
    
    var playlistType: MPPlaylistType {
        type
    }
    
    var playlistTags: Array<MPTagModel>? {
        tags
    }
    
    var playlistIntro: String? {
        intro
    }
    
    func getPlaylist() -> MPPlaylistModel {
        self
    }
    
}
