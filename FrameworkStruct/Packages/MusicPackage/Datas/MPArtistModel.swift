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

class MPArtistModel: OriginModel {
    var id: String
    var firstName: String
    var middleName: String?
    var lastName: String
    var albums: Array<MPAlbumModel>?
    var songs: Array<MPAudioProtocol>?
    var lyrics: Array<MPLyricModel>?
    
    init(firstName: String, middleName: String?, lastName: String) {
        self.id = g_uuid()
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
    }
}
