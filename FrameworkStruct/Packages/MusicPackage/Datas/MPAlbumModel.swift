//
//  MPAlbumModel.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/10/5.
//

/**
 专辑
 */
import UIKit

class MPAlbumModel: OriginModel {
    //MARK: 属性
    var id: String
    var name: String
    var songs: Array<MPAudioProtocol>
    var type: MPPlaylistType
    var artists: Array<MPArtistModel>
    var tags: Array<MPTagModel>?
    var title: String?
    var detail: String?
    
    //MARK: 方法
    //创建一个新的空专辑
    init(name: String, artists: [MPArtistModel]) {
        self.id = g_uuid()
        self.name = name
        self.songs = []
        self.type = .album
        self.artists = artists
    }
    
}


extension MPAlbumModel: MPPlaylistProtocol
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
        title
    }
    
    func getPlaylist() -> MPPlaylistModel {
        MPPlaylistModel(name: name, songs: songs, type: type, tags: tags, intro: title)
    }
    
}
