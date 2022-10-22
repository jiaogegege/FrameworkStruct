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
import MediaPlayer


protocol MPManagerDelegate: NSObjectProtocol {
    ///初始化完成
    func mpManagerDidInitCompleted()
    ///更新完成
    func mpManagerDidUpdated()
    ///加载歌曲，缓冲
    func mpManagerWaitToPlay(_ song: MPAudioProtocol)
    ///开始播放歌曲
    func mpManagerStartPlay(_ song: MPAudioProtocol)
    ///播放歌曲失败
    func mpManagerFailedPlay(_ song: MPAudioProtocol)
    ///播放进度变化，每秒变化
    func mpManagerProgressChange(_ progress: TimeInterval)
    ///缓冲进度变化
    func mpManagerBufferProgressChange(_ progress: TimeInterval)
}


extension FSNotification {
    //加载歌曲，缓冲
    static let mpWaitToPlay = FSNotification(value: "mpWaitToPlay", paramKey: "MPAudioProtocol")
    //开始播放歌曲
    static let mpStartPlay = FSNotification(value: "mpStartPlay", paramKey: "MPAudioProtocol")
    //播放歌曲失败
    static let mpFailedPlay = FSNotification(value: "mpFailedPlay", paramKey: "MPAudioProtocol")
    //播放进度改变，每秒变化
    static let mpProgressChange = FSNotification(value: "mpProgressChange", paramKey: "TimeInterval")
    //缓冲进度改变，每秒变化
    static let mpBufferProgressChange = FSNotification(value: "mpBufferProgressChange", paramKey: "TimeInterval")
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
    
    //快进快退时间：单位秒
    @LimitNumRange(min: 1.0, max: 99.0) var skipTime: TimeInterval = 10.0
    
    //上一次播放时中断时的进度，app启动播放时设置一次
    fileprivate(set) var lastTime: TimeInterval?
    
    
    //MARK: 方法
    //私有化初始化方法
    private override init()
    {
        super.init()
        self.stMgr.set(MPStatus.isIniting, key: StatusKey.currentStatus)
        self.stMgr.set(false, key: StatusKey.updated)
        self.stMgr.set(false, key: StatusKey.inBackground)
        self.libMgr.delegate = self
        self.player.delegate = self
        if let t = ia.getDouble(.mpProgress) {
            self.lastTime = t
        }
        //接受远程控制，不管前台还是后台
        self.addEventControl()
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
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive(notify:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(audioSessionInterrupt(notify:)), name: AVAudioSession.interruptionNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(audioSessionOutputChange(notify:)), name: AVAudioSession.routeChangeNotification, object: nil)
    }
    
    //控制中心事件绑定
    fileprivate func addEventControl()
    {
        let cmdCenter = MPRemoteCommandCenter.shared()
        //播放
        let playCmd = cmdCenter.playCommand
        playCmd.isEnabled = true
        playCmd.addTarget {[weak self] (event) -> MPRemoteCommandHandlerStatus in
            if self?.currentStatus == .paused
            {
                self?.player.resume()
                return .success
            }
            return .commandFailed
        }
        //暂停
        let pauseCmd = cmdCenter.pauseCommand
        pauseCmd.isEnabled = true
        pauseCmd.addTarget {[weak self] (event) -> MPRemoteCommandHandlerStatus in
            if self?.currentStatus == .playing
            {
                self?.player.pause()
                return .success
            }
            return .commandFailed
        }
        //停止
        let stopCmd = cmdCenter.stopCommand
        stopCmd.isEnabled = true
        stopCmd.addTarget {[weak self] (event) -> MPRemoteCommandHandlerStatus in
            self?.player.stop()
            return .success
        }
        //切换播放和暂停
        let toggleCmd = cmdCenter.togglePlayPauseCommand
        toggleCmd.isEnabled = true
        toggleCmd.addTarget {[weak self] (event) -> MPRemoteCommandHandlerStatus in
            if let player = self?.player
            {
                if player.isPlaying
                {
                    player.pause()
                }
                else if player.isPaused
                {
                    player.resume()
                }
                return .success
            }
            else
            {
                return .commandFailed
            }
        }
        //下一首
        let nextCmd = cmdCenter.nextTrackCommand
        nextCmd.isEnabled = true
        nextCmd.addTarget {[weak self] (event) -> MPRemoteCommandHandlerStatus in
            if self?.currentStatus != .loading && self?.currentStatus != .waiting
            {
                self?.player.next()
                return .success
            }
            return .commandFailed
        }
        //上一首
        let previousCmd = cmdCenter.previousTrackCommand
        previousCmd.isEnabled = true
        previousCmd.addTarget {[weak self] (event) -> MPRemoteCommandHandlerStatus in
            if self?.currentStatus != .loading && self?.currentStatus != .waiting
            {
                self?.player.previous()
                return .success
            }
            return .commandFailed
        }
        //向前跳过几秒
        let skipForwardCmd = cmdCenter.skipForwardCommand
        skipForwardCmd.isEnabled = false
        skipForwardCmd.preferredIntervals = [NSNumber(value: skipTime)]
        skipForwardCmd.addTarget {[weak self] (event) -> MPRemoteCommandHandlerStatus in
            if self?.currentStatus == .playing || self?.currentStatus == .paused
            {
                let forwardEvent = event as! MPSkipIntervalCommandEvent
                self?.player.skip(forwardEvent.interval, success: { (succeed) in
                    
                })
                return .success
            }
            return .commandFailed
        }
        //向后跳过几秒
        let skipBackwardCmd = cmdCenter.skipBackwardCommand
        skipBackwardCmd.isEnabled = false
        skipBackwardCmd.preferredIntervals = [NSNumber(value: skipTime)]
        skipBackwardCmd.addTarget {[weak self] (event) -> MPRemoteCommandHandlerStatus in
            if self?.currentStatus == .playing || self?.currentStatus == .paused
            {
                let backwardEvent = event as! MPSkipIntervalCommandEvent
                self?.player.skip(backwardEvent.interval, backward: true, success: { (succeed) in
                    
                })
                return .success
            }
            return .commandFailed
        }
        //向前跳，具体功能不知
        let seekForwardCmd = cmdCenter.seekForwardCommand
        seekForwardCmd.isEnabled = false
        seekForwardCmd.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            return .success
        }
        //向后跳，具体功能不知
        let seekBackwardCmd = cmdCenter.seekBackwardCommand
        seekBackwardCmd.isEnabled = false
        seekBackwardCmd.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            return .success
        }
        //进度控制
        let progressCmd = cmdCenter.changePlaybackPositionCommand
        progressCmd.isEnabled = true
        progressCmd.addTarget {[weak self] (event) -> MPRemoteCommandHandlerStatus in
            if self?.currentStatus == .playing || self?.currentStatus == .paused
            {
                let playbackPositionEvent = event as! MPChangePlaybackPositionCommandEvent
                let time = playbackPositionEvent.positionTime
                self?.player.seek(time) { (succeed) in
                    
                }
                return .success
            }
            return .commandFailed
        }
        //评分
        let rateCmd = cmdCenter.ratingCommand
        rateCmd.isEnabled = false
        rateCmd.minimumRating = 1.0
        rateCmd.maximumRating = 5.0
        rateCmd.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            let e = event as! MPRatingCommandEvent
            FSLog("\(e.rating)")
            return .success
        }
        //喜欢
        let likeCmd = cmdCenter.likeCommand
        likeCmd.isEnabled = false
        likeCmd.localizedTitle = String.like
        likeCmd.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            return .success
        }
        //不喜欢
        let dislikeCmd = cmdCenter.dislikeCommand
        dislikeCmd.isEnabled = false
        dislikeCmd.localizedTitle = String.dislike
        dislikeCmd.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            return .success
        }
        //书签
        let bookmarkCmd = cmdCenter.bookmarkCommand
        bookmarkCmd.isEnabled = false
        bookmarkCmd.localizedTitle = String.addToBookmark
        bookmarkCmd.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            return .success
        }
    }
    
    ///删除控制中心事件绑定
    fileprivate func removeEventControl()
    {
        let cmdCenter = MPRemoteCommandCenter.shared()
        cmdCenter.playCommand.removeTarget(self)
        cmdCenter.pauseCommand.removeTarget(self)
        cmdCenter.stopCommand.removeTarget(self)
        cmdCenter.togglePlayPauseCommand.removeTarget(self)
        cmdCenter.nextTrackCommand.removeTarget(self)
        cmdCenter.previousTrackCommand.removeTarget(self)
        cmdCenter.skipForwardCommand.removeTarget(self)
        cmdCenter.skipBackwardCommand.removeTarget(self)
        cmdCenter.seekForwardCommand.removeTarget(self)
        cmdCenter.seekBackwardCommand.removeTarget(self)
        cmdCenter.changePlaybackPositionCommand.removeTarget(self)
        cmdCenter.ratingCommand.removeTarget(self)
        cmdCenter.likeCommand.removeTarget(self)
        cmdCenter.dislikeCommand.removeTarget(self)
        cmdCenter.bookmarkCommand.removeTarget(self)
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
        g_after(1) {
            self.backgroundTaskId = UIApplication.shared.beginBackgroundTask(expirationHandler: {
                self.repeatBackgroundPlay()   //没什么用，所以注释掉
            })
            //不停地开启后台任务，实现连续播放
            g_after(Self.backgroundTaskTime) {
                self.repeatBackgroundPlay()
            }
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
    
    ///在控制中心显示信息
    fileprivate func showAudioInfoInControlCenter(_ audio: MPAudioProtocol)
    {
        //生成歌曲的资源
        let info = MPEmbellisher.shared.parseSongMeta(audio)
        var dict = [String: Any]()
        //标题
        dict[MPMediaItemPropertyTitle] = audio.audioName
        //专辑标题
        dict[MPMediaItemPropertyAlbumTitle] = info[.albumName] ?? ""
        //歌手
        dict[MPMediaItemPropertyArtist] = info[.artist] ?? ""
        //专辑歌手
        dict[MPMediaItemPropertyAlbumArtist] = info[.artist] ?? ""
        //作曲家
        dict[MPMediaItemPropertyComposer] = info[.artist] ?? ""
        //总时长
        dict[MPMediaItemPropertyPlaybackDuration] = player.totalTime
        //当前时长
        dict[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player.currentTime
        //媒体类型
        dict[MPMediaItemPropertyMediaType] = MPMediaType.music.rawValue
        //播放倍速
        dict[MPNowPlayingInfoPropertyPlaybackRate] = playRate
        //封面图片，获取一个正方形
        let originImg = info[.artwork] != nil ? info[.artwork] as! UIImage : UIImage.iMiku_0!
        let rect = CGRect(origin: .zero, size: originImg.size)
        dict[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: rect.size, requestHandler: { (size) -> UIImage in
            if let img = originImg.getImageInRect(rect)
            {
                return img
            }
            else
            {
                return originImg
            }
        })
        //歌词，似乎无效
//        dict[MPMediaItemPropertyLyrics] = String
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = dict
    }
    
    ///保存播放进度
    func savePlaybackProgress(_ time: TimeInterval)
    {
        //保存到iCloud，每秒保存性能损耗太大，目前考虑10的整数倍才保存
        if Int(time) % 10 == 0
        {
            ia.saveValue(time, key: .mpProgress)
        }
    }
    
}


extension MPManager: DelegateProtocol, MPLibraryManagerDelegate, MPPlayerDelegate
{
    /**************************************** 系统通知 Section Begin ***************************************/
    //app即将进入后台
    @objc func applicationWillResignActive(notify: Notification)
    {
        stMgr.set(true, key: StatusKey.inBackground)
        self.startBackgroundPlay()
    }
    
    //app进入前台
    @objc func applicationDidBecomeActive(notify: Notification)
    {
        stMgr.set(false, key: StatusKey.inBackground)
        self.endBackgroundPlay()
    }
    
    //处理音频打断事件
    @objc func audioSessionInterrupt(notify: Notification)
    {
        if let userInfo = notify.userInfo, let type = userInfo[AVAudioSessionInterruptionTypeKey] as? Int
        {
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
                    if newOutput == .headphones || newOutput == .bluetoothA2DP  //耳机或蓝牙音箱连上了，尝试恢复
                    {
                        
                        player.resume()
                    }
                    break
                case 2: //oldDeviceUnavailable
                    if oldOutput == .headphones || oldOutput == .bluetoothA2DP //耳机或蓝牙音箱断了，暂停播放
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
        stMgr.set(MPStatus.isInited, key: StatusKey.currentStatus)
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
        stMgr.set(true, key: StatusKey.updated)
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
    //处理和加载播放资源
    func mpPlayerPrepareToPlay(_ audio: MPAudioProtocol, success: @escaping (Bool) -> Void) {
        stMgr.set(MPStatus.loading, key: StatusKey.currentStatus)
        delegates.compact()
        for i in 0..<delegates.count
        {
            if let delegate = delegates.object(at: i) as? MPManagerDelegate
            {
                delegate.mpManagerWaitToPlay(audio)
            }
        }
        NotificationCenter.default.post(name: FSNotification.mpWaitToPlay.name, object: [FSNotification.mpWaitToPlay.paramKey: audio])
        
        //如果是歌曲文件，那么判断有没有下载，如果已经下载了，那么不需要再次打开
        if let song = audio as? MPSongModel, song.isDownloaded
        {
            success(true)
        }
        else
        {
            //如果是iCloud文件，那么先打开
            if ia.isiCloudFile(audio.audioUrl)
            {
                ia.openDocument(audio.audioUrl) {[weak self] id in
                    if let id = id {
                        self?.ia.closeDocument(id, completion: { succeed in
                            if succeed
                            {
                                //打开成功说明下载成功了，那么修改歌曲文件信息和下载信息为已下载
                                if let song = audio as? MPSongModel
                                {
                                    song.updateAsset()
                                    self?.libMgr.setSongDownloadStatus(true, song: song)
                                }
                            }
                            //返回成功
                            success(succeed)
                        })
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
    }
    
    //开始播放音乐，记录一些信息
    func mpPlayerStartToPlay(_ audio: MPAudioProtocol, playlist: MPPlaylistProtocol) {
        stMgr.set(MPStatus.playing, key: StatusKey.currentStatus)
        //在控制中心显示歌曲信息
        showAudioInfoInControlCenter(audio)
        //播放成功，那么保存当前播放歌曲和当前播放列表
        //目前只有歌曲
        libMgr.saveCurrent(audio as! MPSongModel, in: playlist as! MPPlaylistModel)
        
        //将播放信息传出去
        delegates.compact()
        for i in 0..<delegates.count
        {
            if let delegate = delegates.object(at: i) as? MPManagerDelegate
            {
                delegate.mpManagerStartPlay(audio)
            }
        }
        NotificationCenter.default.post(name: FSNotification.mpStartPlay.name, object: nil, userInfo: [FSNotification.mpStartPlay.paramKey: audio])
    }
    
    //正在等待播放资源
    func mpPlayerWaitToPlay(_ audio: MPAudioProtocol, playlist: MPPlaylistProtocol) {
        stMgr.set(MPStatus.waiting, key: StatusKey.currentStatus)
    }
    
    func mpPlayerPauseToPlay(_ audio: MPAudioProtocol, playlist: MPPlaylistProtocol) {
        stMgr.set(MPStatus.paused, key: StatusKey.currentStatus)
        //保存进度
        savePlaybackProgress(player.currentTime)
        //在控制中心显示歌曲信息
        showAudioInfoInControlCenter(audio)
    }
    
    func mpPlayerResumeToPlay(_ audio: MPAudioProtocol, playlist: MPPlaylistProtocol) {
        stMgr.set(MPStatus.playing, key: StatusKey.currentStatus)
        //在控制中心显示歌曲信息
        showAudioInfoInControlCenter(audio)
    }
    
    func mpPlayerFinishPlay(_ audio: MPAudioProtocol, playlist: MPPlaylistProtocol) {
        stMgr.set(MPStatus.playFinished, key: StatusKey.currentStatus)
        //播放完成后，播放进度重置为0
        savePlaybackProgress(0)
        //设置控制中心内容
        showAudioInfoInControlCenter(audio)
    }
    
    func mpPlayerStopToPlay(_ audio: MPAudioProtocol, playlist: MPPlaylistProtocol) {
        stMgr.set(MPStatus.stopped, key: StatusKey.currentStatus)
    }
    
    func mpPlayerFailToPlay(_ audio: MPAudioProtocol, playlist: MPPlaylistProtocol) {
        stMgr.set(MPStatus.stopped, key: StatusKey.currentStatus)
        delegates.compact()
        for i in 0..<delegates.count
        {
            if let delegate = delegates.object(at: i) as? MPManagerDelegate
            {
                delegate.mpManagerFailedPlay(audio)
            }
        }
        NotificationCenter.default.post(name: FSNotification.mpFailedPlay.name, object: nil, userInfo: [FSNotification.mpFailedPlay.paramKey: audio])
        //尝试播放下一首
        player.next()
    }
    
    func mpPlayerPlaylistChanged(_ audio: MPAudioProtocol, playlist: MPPlaylistProtocol) {
        //播放列表更新后保存到iCloud
        libMgr.saveCurrent(audio as! MPSongModel, in: playlist as! MPPlaylistModel)
    }
    
    //播放进度变化
    func mpPlayerTimeChange(_ time: TimeInterval) {
        savePlaybackProgress(time)
        //将信息传出去
        delegates.compact()
        for i in 0..<delegates.count
        {
            if let delegate = delegates.object(at: i) as? MPManagerDelegate
            {
                delegate.mpManagerProgressChange(time)
            }
        }
        NotificationCenter.default.post(name: FSNotification.mpProgressChange.name, object: nil, userInfo: [FSNotification.mpProgressChange.paramKey: time])
    }
    
    //缓冲进度变化
    func mpPlayerBufferTimeChange(_ time: TimeInterval) {
        delegates.compact()
        for i in 0..<delegates.count
        {
            if let delegate = delegates.object(at: i) as? MPManagerDelegate
            {
                delegate.mpManagerBufferProgressChange(time)
            }
        }
        NotificationCenter.default.post(name: FSNotification.mpBufferProgressChange.name, object: nil, userInfo: [FSNotification.mpBufferProgressChange.paramKey: time])
    }
    
    //播放速率变化
    func mpPlayerRateChange(_ rage: Float) {
        //在控制中心显示歌曲信息
        showAudioInfoInControlCenter(player.currentAudio!)
    }
    
    /**************************************** MPPlayer代理方法 Section End ***************************************/
    
}


//内部类型
extension MPManager: InternalType
{
    //后台任务时长，到这个时间后要结束后台任务，不然会被系统杀掉；然后再开启一个新的后台任务
    static let backgroundTaskTime: TimeInterval = 20.0
    
    //状态管理器的key
    enum StatusKey: SMKeyType {
        case currentStatus              //MP当前状态：`MPStatus`
        case inBackground               //是否在后台：`Bool`
        case updated                    //是否更新过，会多次发生更新：Bool
    }
    
    enum MPStatus {
        case isIniting                  //正在初始化
        case isInited                   //初始化完成
        case waiting                    //正在等待播放资源
        case loading                    //正在加载播放资源
        case playing                    //正在播放歌曲
        case paused                     //暂停状态
        case playFinished               //播放完成
        case stopped                    //停止状态
    }
    
}


//外部接口
extension MPManager: ExternalInterface
{
    ///MPManager当前状态
    var currentStatus: MPStatus {
        stMgr.status(StatusKey.currentStatus) as! MPStatus
    }
    
    ///是否完成了初始化，指读取了媒体库
    var isInited: Bool {
        currentStatus == .isInited
    }
    
    ///执行一个延时任务,播放当前歌曲，如果有的话
    ///继续播放上一次app运行中断时播放的歌曲
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
                                //如果播放成功，那么设置进度
                                if succeed, let t = self?.lastTime
                                {
                                    self?.player.seek(t, success: nil)
                                }
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
            //如果已经初始化了，那么直接执行
            if isInited
            {
                performInitOrUpdateCallback()
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
    
    ///控制中心操作，可在AppDelegate中使用，已废弃
    @available(*, deprecated, message: "Don't use this anymore")
//    @available(iOS, introduced: 1.0, deprecated: 1.0, message: "use `MPRemoteCommandCenter`")
    func remoteControl(_ event: UIEvent.EventSubtype)
    {
        switch event {
        case .remoteControlPlay:    //播放
            player.resume()
        case .remoteControlPause:   //暂停
            player.pause()
        case .remoteControlStop:    //停止
            player.stop()
        case .remoteControlTogglePlayPause:     //切换播放和暂停，比如轻点两下蓝牙耳机
            if player.isPlaying
            {
                player.pause()
            }
            else if player.isPaused
            {
                player.resume()
            }
        case .remoteControlNextTrack:   //下一首，操作：按耳机线控中间按钮两下
            player.next()
        case .remoteControlPreviousTrack:   //上一首，操作：按耳机线控中间按钮三下
            player.previous()
        case .remoteControlBeginSeekingBackward:    //开始快退，操作：按耳机线控中间按钮三下不要松开
            break
        case .remoteControlEndSeekingBackward:      //结束快退，操作：按耳机线控中间按钮三下到了快退的位置松开
            break
        case .remoteControlBeginSeekingForward:     //开始快进，操作：按耳机线控中间按钮两下不要松开
            break
        case .remoteControlEndSeekingForward:       //结束快进，操作：按耳机线控中间按钮两下到了快进的位置松开
            break
        default:
            break
        }
    }
    
    /**************************************** 播放音乐相关 Section Begin ***************************************/
    ///是否正在播放音乐
    var isPlaying: Bool {
        player.isPlaying
    }
    
    ///当前正在播放的歌曲
    var currentSong: MPAudioProtocol? {
        player.currentAudio
    }
    
    ///播放模式
    var playMode: MPPlayer.PlayMode {
        get {
            player.playMode
        }
        set {
            player.playMode = newValue
        }
    }
    
    ///播放速率
    var playRate: Float {
        player.playRate
    }
    
    ///设置播放速率
    func setPlayRate(_ rate: MPPlayRate)
    {
        player.setPlayRate(rate.rawValue)
    }
    
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
    
    
    /**************************************** 播放音乐相关 Section End ***************************************/

    /**************************************** 音乐资源相关 Section Begin ***************************************/
    ///获取所有iCloud歌曲
    func getAlliCloudSongs(completion: @escaping ([MPSongModel]) -> Void)
    {
        libMgr.getResource(libraryType: .iCloud, resourceType: .songs) { songs in
            if let songs = songs {
                completion(songs as! [MPSongModel])
            }
        }
    }
    
    ///获取iCloud中当前播放歌曲，可能为nil
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
    
    /**************************************** 音乐资源相关 Section End ***************************************/
    
}
