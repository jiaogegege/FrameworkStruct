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
    
}

class MPManager: OriginManager
{
    //MARK: 属性
    //单例
    static let shared = MPManager()
    
    //媒体库管理器
    fileprivate var libMgr = MPLibraryManager.shared
    
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
        for i in 0..<delegates.count
        {
            let delegate = delegates.object(at: i) as! MPManagerDelegate
            delegate.mpManagerDidInitCompleted()
        }
    }
    
}


//外部接口
extension MPManager: ExternalInterface
{
    ///添加代理
    func addDelegate(_ obj: MPManagerDelegate)
    {
        self.delegates.add(obj)
    }
    
    ///获取所有iCloud歌曲
    func getAlliCloudSongs(completion: @escaping ([MPSongModel]) -> Void)
    {
        libMgr.getResource(libraryType: .iCloud, resourceType: .songs) { songs in
            completion(songs as! [MPSongModel])
        }
    }
    
    ///播放一首歌曲
    ///参数：song：要播放的歌曲，libraryType：所在的库，playlistType：播放列表类型，playlistId：播放列表id，completion：播放是否成功
    ///libraryType和playlistType互斥
    ///playlistType和playlistId必须同时出现
    func playSong(_ song: MPSongModel, libraryType: MPLibraryType?, playlistType: MPPlaylistType?, playlistId: String?, completion: BoolClosure? = nil)
    {
        
    }
    
    
    
    
}
