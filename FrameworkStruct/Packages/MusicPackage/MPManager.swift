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
import AVFoundation

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
    
    //可以传入一个延时任务，当MPManager初始化完成或者更新完成后执行
    fileprivate var initOrUpdateCallback: VoidClosure?
    
    //媒体库管理器
    fileprivate var libMgr = MPLibraryManager.shared
    //播放器
    fileprivate var player = MPPlayer()
    //后台任务id
    fileprivate var backgroundTaskId: UIBackgroundTaskIdentifier = .invalid
    
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
        //接受远程控制，不管前台还是后台
        UIApplication.shared.beginReceivingRemoteControlEvents()
        self.addNotification()
    }
    
    override func copy() -> Any
    {
        return self
    }
    
    override func mutableCopy() -> Any
    {
        return self
    }
    
    fileprivate func addNotification()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive(notify:)), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground(notify:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(audioSessionInterrupt(notify:)), name: AVAudioSession.interruptionNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(audioSessionOutputChange(notify:)), name: AVAudioSession.routeChangeNotification, object: nil)
    }
    
    //支持后台播放
    fileprivate func startBackgroundPlay()
    {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback)
            try session.setActive(true)
            
            /* 可以后台连续播放，但是经测试发现有时后台时间久了会失效，因为有些app会把自己设置成`firstResponder`考虑用`repeatBackgroundPlay()` */
            ApplicationManager.shared.appDelegate.becomeFirstResponder()
//            self.repeatBackgroundPlay()
        } catch {
            FSLog(error.localizedDescription)
        }
    }
    
    //重复后台任务
    fileprivate func repeatBackgroundPlay()
    {
        self.endBackgroundPlay()
        self.backgroundTaskId = UIApplication.shared.beginBackgroundTask(expirationHandler: {
//            self.repeatBackgroundPlay()   //没什么用，所以注释掉
        })
        
        //不停地开启后台任务，实现连续播放
        g_after(Self.backgroundTaskTime) {
            self.repeatBackgroundPlay()
        }
    }
    
    //结束后台播放
    fileprivate func endBackgroundPlay()
    {
        ApplicationManager.shared.appDelegate.resignFirstResponder()
        if self.backgroundTaskId != .invalid
        {
            UIApplication.shared.endBackgroundTask(self.backgroundTaskId)
            self.backgroundTaskId = .invalid
        }
    }
    
    ///执行延时回调
    fileprivate func performInitOrUpdateCallback()
    {
        if let cb = self.initOrUpdateCallback
        {
            cb()
            self.initOrUpdateCallback = nil
        }
    }
    
}


extension MPManager: DelegateProtocol, MPLibraryManagerDelegate, MPPlayerDelegate
{
    /**************************************** 系统通知 Section Begin ***************************************/
    //app即将进入后台
    @objc func applicationWillResignActive(notify: Notification)
    {
        self.startBackgroundPlay()
    }
    
    //app进入前台
    @objc func applicationWillEnterForeground(notify: Notification)
    {
        self.endBackgroundPlay()
    }
    
    //处理音频打断事件
    @objc func audioSessionInterrupt(notify: Notification)
    {
        if let userInfo = notify.userInfo, let type = userInfo[AVAudioSessionInterruptionTypeKey] as? Int
        {
            print(type)
            if type == 1   //打断开始
            {
                
            }
            else if type == 0  //打断结束，恢复播放
            {
                player.resume()
            }
        }
    }
    
    //处理蓝牙插拔事件
    @objc func audioSessionOutputChange(notify: Notification)
    {
        if let userInfo = notify.userInfo
        {
            if let reason = userInfo[AVAudioSessionRouteChangeReasonKey] as? Int
            {   //AVAudioSession.RouteChangeReason
                let oldRoute = userInfo[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription
                let oldOutput = oldRoute?.outputs.first?.portType   //AVAudioSession.Port
                let newOutput = AVAudioSession.sharedInstance().currentRoute.outputs.first?.portType    //AVAudioSession.Port
                
                switch reason {
                case 0: //unknown
                    break
                case 1: //newDeviceAvailable
                    if newOutput == .headphones //耳机连上了，尝试恢复
                    {
                        player.resume()
                    }
                    break
                case 2: //oldDeviceUnavailable
                    if oldOutput == .headphones //耳机断了，暂停播放
                    {
                        player.pause()
                    }
                    break
                case 3: //categoryChange
                    break
                case 4: //override
                    break
                case 6: //wakeFromSleep
                    break
                case 7: //noSuitableRouteForCategory
                    break
                case 8: //routeConfigurationChange
                    break
                default:
                    break
                }
            }
        }
    }
    
    /**************************************** 系统通知 Section End ***************************************/
    
    
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
        
        //执行延时回调
        performInitOrUpdateCallback()
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
        
        //执行延时回调
        performInitOrUpdateCallback()
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
    
    //开始播放音乐，记录一些信息
    func mpPlayerStartToPlay(_ audio: MPAudioProtocol, playlist: MPPlaylistProtocol) {
        //播放成功，那么保存当前播放歌曲和当前播放列表
        //目前只有歌曲
        libMgr.saveCurrent(audio as! MPSongModel, in: playlist as! MPPlaylistModel)
    }
    
    //正在等待加载资源
    func mpPlayerLoadingToPlay(_ audio: MPAudioProtocol, playlist: MPPlaylistProtocol) {
        
    }
    
    func mpPlayerPauseToPlay(_ audio: MPAudioProtocol, playlist: MPPlaylistProtocol) {
        
    }
    
    func mpPlayerResumeToPlay(_ audio: MPAudioProtocol, playlist: MPPlaylistProtocol) {
        
    }
    
    func mpPlayerFinishPlay(_ audio: MPAudioProtocol, playlist: MPPlaylistProtocol) {
        
    }
    
    func mpPlayerStopToPlay(_ audio: MPAudioProtocol, playlist: MPPlaylistProtocol) {
        
    }
    
    func mpPlayerFailToPlay(_ audio: MPAudioProtocol, playlist: MPPlaylistProtocol) {
        
    }
    
    /**************************************** MPPlayer代理方法 Section End ***************************************/
    
}


//内部类型
extension MPManager: InternalType
{
    //后台任务时长，到这个时间后要结束后台任务，不然会被系统杀掉；然后再开启一个新的后台任务
    static let backgroundTaskTime: TimeInterval = 30.0
    
}


//外部接口
extension MPManager: ExternalInterface
{
    ///执行一个延时任务,播放当前歌曲，如果有的话
    func performPlayCurrent(_ completion: BoolClosure?)
    {
        //如果是空闲状态，那么执行一个延时操作，播放当前歌曲
        if player.isFree
        {
            self.initOrUpdateCallback = {[weak self] in
                self?.getCurrentSong({ (song) in
                    self?.getCurrentPlaylist({ (playlist) in
                        if let song = song, let playlist = playlist
                        {
                            self?.player.play(song, playlist: playlist, completion: { (succeed) in
                                if let cb = completion
                                {
                                    cb(succeed)
                                }
                            })
                        }
                        else
                        {
                            if let cb = completion
                            {
                                cb(false)
                            }
                        }
                    })
                })
            }
        }
        else if player.isPaused //暂停状态则恢复播放
        {
            player.resume()
        }
    }
    
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
                    let playlist = MPPlaylistModel(name: String.iCloud, audios: songs, type: .playlist, intro: nil)
                    //播放音乐
                    self?.player.play(song, playlist: playlist, completion: { success in
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
    func getHistorySongs(_ completion: @escaping (MPHistoryAudioModel?) -> Void)
    {
        libMgr.readHistorySongs { historySongs in
            completion(historySongs)
        }
    }
    
    
    /**************************************** 播放音乐相关 Section End ***************************************/
    
    ///控制中心操作
    func remoteControl(_ event: UIEvent.EventSubtype)
    {
        print(event.rawValue)
    }
    
}
