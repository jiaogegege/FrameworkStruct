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
    
    fileprivate var ia = iCloudAccessor.shared
    
    //播放器
    fileprivate var player: MPPlayer = MPPlayer()
    
    //弱引用代理数组，一般是UI组件
    fileprivate var delegates: WeakArray = WeakArray.init()
    
    
    //MARK: 方法
    //私有化初始化方法
    private override init()
    {
        super.init()
        self.libMgr.delegate = self
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


extension MPManager: DelegateProtocol, MPLibraryManagerDelegate
{
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
    func playSong(_ song: MPSongModel , in library: MPLibraryType, completion: BoolClosure)
    {
        if library == .iCloud
        {
            libMgr.getResource(libraryType: .iCloud, resourceType: .songs) {[weak self] items in
                if let songs = items as? [MPSongModel] {
                    //生成一个播放列表
                    let playlist = MPPlaylistModel(name: String.iCloud, songs: songs, type: .playlist, intro: nil)
                    //先打开歌曲文件，同时也是从iCloud下载
                    self?.ia.openDocument(song.url) { id in
                        if let id = id {
                            self?.ia.closeDocument(id)
                        }
                        //播放音乐
                        self?.player.play(song, playlist: playlist, completion: { success in
                            
                        })
                    }
                }
            }
        }
        
    }
    
    
    
    /**************************************** 播放音乐相关 Section End ***************************************/
    
    
}
