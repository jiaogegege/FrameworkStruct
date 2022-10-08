//
//  MPPlayer.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/10/5.
//

/**
 音乐播放器
 负责基本音乐播放功能：播放/暂停
 */
import UIKit

class MPPlayer: OriginWorker
{
    //MARK: 属性
    //当前播放列表
    fileprivate var currentPlaylist: MPPlaylistProtocol?
    //当前正在播放的音乐
    fileprivate var currentSong: MPAudioProtocol?
    
    
    //MARK: 方法
    override init() {
        super.init()
    }
    
    override func finishWork() {
        super.finishWork()
    }
    
}


//外部接口
extension MPPlayer: ExternalInterface
{
    
}
