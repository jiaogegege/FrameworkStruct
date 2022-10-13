//
//  MPManager.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/10/5.
//

/**
 音乐管理器
 管理所有音乐资源和播放功能，是整个音乐播放包和外部程序的接口
 */
import UIKit

protocol MPManagerDelegate: NSObjectProtocol {
    ///初始化完成
    func mpManagerDidInitCompleted()
    ///更新完成
    func mpManagerDidUpdated()
}

class MPManager: OriginManager
{
    //MARK: 属性
    //单例
    static let shared = MPManager()
    
    //媒体库管理器
    fileprivate var libMgr = MPLibraryManager.shared
    //播放器
    fileprivate var player = MPPlayer()
    
    //iCloud交互
    fileprivate var ia = iCloudAccessor.shared
    
    //弱引用代理数组，一般是UI组件
    fileprivate var delegates: WeakArray = WeakArray.init()
    
    
    //MARK: 方法
    //私有化初始化方法
    private override init()
    {
        super.init()
        self.libMgr.delegate = self
        self.player.delegate = self
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


extension MPManager: DelegateProtocol, MPLibraryManagerDelegate, MPPlayerDelegate
{
    /**************************************** 媒体库管理器代理 Section Begin ***************************************/
    //媒体库管理器初始化完成
    func mpLibraryManagerDidInitCompleted() {
        delegates.compact()
        for i in 0..<delegates.count
        {
            if let delegate = delegates.object(at: i) as? MPManagerDelegate
            {
                delegate.mpManagerDidInitCompleted()
            }
        }
    }
    
    //媒体库管理器更新
    func mpLibraryManagerDidUpdated() {
        delegates.compact()
        for i in 0..<delegates.count
        {
            if let delegate = delegates.object(at: i) as? MPManagerDelegate
            {
                delegate.mpManagerDidUpdated()
            }
        }
    }
    
    /**************************************** 媒体库管理器代理 Section End ***************************************/
    
    /**************************************** MPPlayer代理方法 Section Begin ***************************************/
    func mpPlayerPrepareToPlay(_ audio: MPAudioProtocol, success: @escaping (Bool) -> Void) {
        //如果是iCloud文件，那么先打开
        if ia.isiCloudFile(audio.audioUrl)
        {
            ia.openDocument(audio.audioUrl) {[weak self] id in
                if let id = id {
                    self?.ia.closeDocument(id)
                    //返回成功
                    success(true)
                }
                else
                {
                    success(false)
                }
            }
        }
        else    //其他情况，目前先都返回成功
        {
            success(true)
        }
    }
    
    func mpPlayerStartToPlay(_ audio: MPAudioProtocol) {
        
    }
    
    func mpPlayerPauseToPlay(_ audio: MPAudioProtocol) {
        
    }
    
    func mpPlayerResumeToPlay(_ audio: MPAudioProtocol) {
        
    }
    
    func mpPlayerFinishPlay(_ audio: MPAudioProtocol) {
        
    }
    
    func mpPlayerStopToPlay(_ audio: MPAudioProtocol) {
        
    }
    
    func mpPlayerFailToPlay(_ audio: MPAudioProtocol) {
        
    }
    
    /**************************************** MPPlayer代理方法 Section End ***************************************/
    
}


//外部接口
extension MPManager: ExternalInterface
{
    ///添加代理
    func addDelegate(_ obj: MPManagerDelegate)
    {
        delegates.add(obj)
        delegates.compact()
    }
    
    ///获取所有iCloud歌曲
    func getAlliCloudSongs(completion: @escaping ([MPSongModel]) -> Void)
    {
        libMgr.getResource(libraryType: .iCloud, resourceType: .songs) { songs in
            if let songs = songs {
                completion(songs as! [MPSongModel])
            }
        }
    }
    
    /**************************************** 播放音乐相关 Section Begin ***************************************/
    
    ///播放一首媒体库中的音乐
    ///参数：library：媒体库类型，目前只有iCloud；completion：播放是否成功
    ///说明：会生成一个播放列表，包含媒体库中所有歌曲
    func playSong(_ song: MPSongModel , in library: MPLibraryType, completion: @escaping BoolClosure)
    {
        if library == .iCloud
        {
            libMgr.getResource(libraryType: .iCloud, resourceType: .songs) {[weak self] items in
                if let songs = items as? [MPSongModel] {
                    //生成一个播放列表
                    let playlist = MPPlaylistModel(name: String.iCloud, songs: songs, type: .playlist, intro: nil)
                    //播放音乐
                    self?.player.play(song, playlist: playlist, completion: { success in
                        //处理播放结果，如果播放成功，那么保存当前播放歌曲和当前播放列表
                        if success
                        {
                            self?.libMgr.saveCurrent(song, in: playlist)
                        }
                        completion(success)
                    })
                }
                else    //没有查询到媒体库，播放失败
                {
                    completion(false)
                }
            }
        }
        else    //其他媒体库，暂时不开发
        {
            
        }
    }
    
    ///获取当前播放歌曲，可能为nil
    func getCurrentSong(_ completion: @escaping (MPSongModel?) -> Void)
    {
        libMgr.readCurrentSong { song in
            completion(song)
        }
    }
    
    ///获取当前播放列表
    func getCurrentPlaylist(_ completion: @escaping (MPPlaylistModel?) -> Void)
    {
        libMgr.readCurrentPlaylist { playlist in
            completion(playlist)
        }
    }
    
    ///获取历史播放歌曲列表
    func getHistorySongs(_ completion: @escaping (MPHistorySongModel?) -> Void)
    {
        libMgr.readHistorySongs { historySongs in
            completion(historySongs)
        }
    }
    
    
    /**************************************** 播放音乐相关 Section End ***************************************/
    
    
}
