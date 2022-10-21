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
import AVKit


protocol MPPlayerDelegate: NSObjectProtocol {
    ///准备播放，需要外部管理器处理一下这个文件，比如下载iCloud文件到本地
    ///audio：要播放的音频；success：外部管理器处理完后执行是否成功的回调，如果成功，player将尝试播放该音频
    func mpPlayerPrepareToPlay(_ audio: MPAudioProtocol, success: @escaping BoolClosure)
    
    ///等待播放某个音频
    func mpPlayerWaitToPlay(_ audio: MPAudioProtocol, playlist: MPPlaylistProtocol)
    
    ///开始播放某个音频
    func mpPlayerStartToPlay(_ audio: MPAudioProtocol, playlist: MPPlaylistProtocol)
    
    ///暂停播放某个音频
    func mpPlayerPauseToPlay(_ audio: MPAudioProtocol, playlist: MPPlaylistProtocol)
    
    ///恢复播放某个音频
    func mpPlayerResumeToPlay(_ audio: MPAudioProtocol, playlist: MPPlaylistProtocol)
    
    ///完成播放某个音频
    func mpPlayerFinishPlay(_ audio: MPAudioProtocol, playlist: MPPlaylistProtocol)
    
    ///停止播放某个音频，可能是中途停止
    func mpPlayerStopToPlay(_ audio: MPAudioProtocol, playlist: MPPlaylistProtocol)
    
    ///播放某个音频失败
    func mpPlayerFailToPlay(_ audio: MPAudioProtocol, playlist: MPPlaylistProtocol)
    
    ///播放列表更新
    func mpPlayerPlaylistChanged(_ audio: MPAudioProtocol, playlist: MPPlaylistProtocol)
    
    ///播放进度改变
    func mpPlayerTimeChange(_ time: TimeInterval)
    
    ///播放速率改变
    func mpPlayerRateChange(_ rage: Float)
}

class MPPlayer: OriginWorker
{
    //MARK: 属性
    //当前正在播放的音频
    fileprivate(set) var currentAudio: MPAudioProtocol?
    
    //当前播放列表
    fileprivate(set) var currentPlaylist: MPPlaylistProtocol?
    
    //当前播放歌曲在播放列表中的位置，如果没有就是-1
    fileprivate(set) var currentIndex: Int = -1
    
    //随机播放模式下保存的播放列表歌曲序号列表
    fileprivate var playlistIndexArray: [Int] = []
    
    //如果用户点了下一首播放，那么记住这个位置，不管何种播放模式，都会按最新到最旧的加入顺序播放下一首
    fileprivate var indexsOfIfNextPlay: [Int] = []
    
    //一个播放列表的中已播放歌曲列表，当切换播放列表时被清空
    fileprivate var elapsedAudioArray: [MPAudioProtocol] = []
    
    //播放模式
    var playMode: PlayMode = .random
    
    //播放速率，默认1.0，可设置为0.0～3.0
    @LimitNumRange(min: 0.0, max: 3.0) fileprivate(set) var playRate: Float = 1.0
    
    //代理对象
    weak var delegate: MPPlayerDelegate?
    
    //播放器
    fileprivate var player: AVPlayer
    //播放器资源
    fileprivate var playerItem: AVPlayerItem?
    //资源信息
    fileprivate var itemAsset: AVURLAsset?
    //播放器观察者，记录时间
    fileprivate var timeObserver: Any?
    
    //播放音乐是否成功的回调，一般用于外部第一次播放一首乐曲时
    fileprivate var playResultCallback: BoolClosure?
    
    
    //MARK: 方法
    override init() {
        //初始化一个空的播放器
        self.player = AVPlayer(playerItem: nil)
        super.init()
        self.addNotification()
    }
    
    //结束工作
    override func finishWork() {
        stop()
        NotificationCenter.default.removeObserver(self)
        
        super.finishWork()
    }
    
    //添加通知
    fileprivate func addNotification()
    {
        //监听播放结束
        NotificationCenter.default.addObserver(self, selector: #selector(playFinished(notify:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    //准备播放
    fileprivate func prepareToPlay(_ audio: MPAudioProtocol)
    {
        FSLog("prepare to play")
        //准备播放
        if let delegate = self.delegate {
            delegate.mpPlayerPrepareToPlay(audio) {[weak self] succeed in
                if succeed  //准备播放资源成功，尝试播放
                {
                    self?.performPlay(audio)
                }
                else    //准备失败
                {
                    self?.performPlayCallback(false)
                    if let del = self?.delegate
                    {
                        del.mpPlayerFailToPlay(audio, playlist: (self?.currentPlaylist)!)
                    }
                }
            }
        }
        else    //如果没有代理对象，那么直接尝试播放，可能会失败
        {
            self.performPlay(audio)
        }
    }
    
    //执行播放
    fileprivate func performPlay(_ audio: MPAudioProtocol)
    {
        FSLog("perform play")
        stop()
        
        itemAsset = AVURLAsset(url: audio.audioUrl)
        playerItem = AVPlayerItem(asset: itemAsset!)
        player.replaceCurrentItem(with: playerItem)
        //监听播放状态
        playerItem?.addObserver(self, forKeyPath: PlayerKeyPath.status.rawValue, options: .new, context: nil)
    }
    
    //执行播放是否成功的回调
    fileprivate func performPlayCallback(_ result: Bool)
    {
        FSLog("perform play callback")
        if let cb = playResultCallback
        {
            cb(result)
            playResultCallback = nil    //执行完后清空
        }
    }
    
    ///播放下一首乐曲，根据不同的播放模式
    fileprivate func playNextByMode()
    {
        FSLog("play next by mode")
        //先获取下一首乐曲
        self.currentAudio = self.getNextAudioByMode()
        //准备播放
        self.prepareToPlay(currentAudio!)
    }
    
    //获取下一首乐曲，处理index
    fileprivate func getNextAudioByMode() -> MPAudioProtocol
    {
        switch playMode {
        case .sequence:     //顺序播放
            if indexsOfIfNextPlay.count > 0
            {
                currentIndex = indexsOfIfNextPlay.popLast()!
            }
            else
            {
                currentIndex += 1
                if currentIndex >= currentPlaylist!.playlistAudios.count
                {
                    currentIndex = 0
                }
            }
            return currentPlaylist!.playlistAudios[currentIndex]
        case .singleCycle:  //单曲循环
            if indexsOfIfNextPlay.count > 0
            {
                currentIndex = indexsOfIfNextPlay.popLast()!
            }
            else
            {
                currentIndex += 1
                if currentIndex >= currentPlaylist!.playlistAudios.count
                {
                    currentIndex = 0
                }
            }
            return currentPlaylist!.playlistAudios[currentIndex]
        case .random:       //随机播放
            if indexsOfIfNextPlay.count > 0
            {
                currentIndex = indexsOfIfNextPlay.popLast()!
            }
            else
            {
                let indexOfIndex = Int(randomIn(0, UInt(playlistIndexArray.count - 1)))
                currentIndex = playlistIndexArray[indexOfIndex]     //随机获取一个index
                playlistIndexArray.remove(at: indexOfIndex)     //从序号数组中删除获取的这个序号
                //如果序号数组剩余0个，说明所有歌曲都随机了一遍，那么重新生成序号数组
                if playlistIndexArray.count <= 0
                {
                    for index in 0..<self.currentPlaylist!.playlistAudios.count
                    {
                        self.playlistIndexArray.append(index)
                    }
                }
            }
            return currentPlaylist!.playlistAudios[currentIndex]
        }
    }
    
    ///播放上一首乐曲，根据不同的播放模式
    fileprivate func playPreviousByMode()
    {
        //先获取上一首乐曲
        self.currentAudio = self.getPreviousAudioByMode()
        //准备播放
        self.prepareToPlay(currentAudio!)
    }
    
    ///获取上一首乐曲
    fileprivate func getPreviousAudioByMode() -> MPAudioProtocol
    {
        switch playMode {
        case .sequence:
            if elapsedAudioArray.count > 0
            {
                let audio = elapsedAudioArray.popLast()!
                currentIndex = currentPlaylist!.getIndexOf(audio: audio)
                return audio
            }
            else
            {
                currentIndex -= 1
                if currentIndex < 0
                {
                    currentIndex = 0
                }
                return currentPlaylist!.playlistAudios[currentIndex]
            }
        case .singleCycle:
            if elapsedAudioArray.count > 0
            {
                let audio = elapsedAudioArray.popLast()!
                currentIndex = currentPlaylist!.getIndexOf(audio: audio)
                return audio
            }
            else
            {
                currentIndex -= 1
                if currentIndex < 0
                {
                    currentIndex = 0
                }
                return currentPlaylist!.playlistAudios[currentIndex]
            }
        case .random:
            if elapsedAudioArray.count > 0
            {
                let audio = elapsedAudioArray.popLast()!
                currentIndex = currentPlaylist!.getIndexOf(audio: audio)
                return audio
            }
            else
            {
                let indexOfIndex = Int(randomIn(0, UInt(playlistIndexArray.count - 1)))
                currentIndex = playlistIndexArray[indexOfIndex]     //随机获取一个index
                playlistIndexArray.remove(at: indexOfIndex)     //从序号数组中删除获取的这个序号
                //如果序号数组剩余0个，说明所有歌曲都随机了一遍，那么重新生成序号数组
                if playlistIndexArray.count <= 0
                {
                    for index in 0..<self.currentPlaylist!.playlistAudios.count
                    {
                        self.playlistIndexArray.append(index)
                    }
                }
                return currentPlaylist!.playlistAudios[currentIndex]
            }
        }
    }
    
}


extension MPPlayer: DelegateProtocol
{
    //播放完毕
    @objc fileprivate func playFinished(notify: Notification)
    {
        if let item = notify.object as? AVPlayerItem, item.isEqual(self.playerItem) //必须是发出通知的那个`PlayerItem`
        {
            //保存已经播放的歌曲
            elapsedAudioArray.append(self.currentAudio!)
            //播放完毕通知
            if let del = self.delegate
            {
                del.mpPlayerFinishPlay(self.currentAudio!, playlist: self.currentPlaylist!)
            }
            //尝试播放下一首
            self.playNextByMode()
        }
    }
    
    //播放器状态变化
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let playerItem = object as? AVPlayerItem, playerItem.isEqual(self.playerItem)    //必须是监听的那个PlayerItem
        {
            if keyPath == PlayerKeyPath.status.rawValue
            {
                let status = playerItem.status
                if status == .readyToPlay   //准备播放
                {
                    FSLog("start to play")
                    //添加播放进度观察
                    self.timeObserver = self.player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1.0, preferredTimescale: itemAsset!.duration.timescale), queue: nil) {[weak self] cmtime in
                        //计算已播放时间
                        let time = CMTimeGetSeconds(cmtime)
                        if let delegate = self?.delegate
                        {
                            delegate.mpPlayerTimeChange(time)
                        }
                    }
                    self.resume()
                    self.performPlayCallback(true)
                    if let del = self.delegate
                    {
                        del.mpPlayerStartToPlay(currentAudio!, playlist: currentPlaylist!)
                    }
                }
                else if status == .failed   //播放失败
                {
                    FSLog("play audio failed")
                    self.performPlayCallback(false)
                    if let del = self.delegate
                    {
                        del.mpPlayerFailToPlay(currentAudio!, playlist: currentPlaylist!)
                    }
                }
                else if status == .unknown  //未知，没有在加载播放资源
                {
                    FSLog("player status unknown")
//                    self.performPlayCallback(false)
                    if let del = self.delegate
                    {
                        del.mpPlayerWaitToPlay(currentAudio!, playlist: currentPlaylist!)
                    }
                }
            }
        }
    }
    
}


//内部类型
extension MPPlayer: InternalType
{
    //keypath
    enum PlayerKeyPath: String {
        case status                 //AVPlayerItem.status
        
    }
    
    //播放模式
    enum PlayMode {
        case sequence               //列表顺序，播放完毕后从头开始
        case singleCycle            //单曲循环
        case random                 //列表随机，在一次列表随机中，保证每一首乐曲都能播放一次，然后重新随机
    }
    
}


//外部接口
extension MPPlayer: ExternalInterface
{
    ///音量
    var volume: Float {
        get {
            player.volume
        }
        set {
            player.volume = newValue
        }
    }
    
    ///静音
    var silence: Bool {
        get {
            player.isMuted
        }
        set {
            player.isMuted = newValue
        }
    }
    
    ///是否在播放
    var isPlaying: Bool {
        player.timeControlStatus == .playing && self.currentAudio != nil
    }
    
    ///是否是暂停状态，有播放资源
    var isPaused: Bool {
        player.timeControlStatus == .paused && self.currentAudio != nil
    }
    
    ///是否是空闲状态，就是什么播放资源都没有
    var isFree: Bool {
        currentAudio == nil && currentPlaylist == nil && playerItem == nil
    }
    
    ///播放一首音乐，用于从一个新的列表中点击一首歌曲播放，比如音乐库、歌单、历史播放列表、专辑、我喜欢、心情等
    ///参数：audio：歌曲对象；playlist：所在播放列表；completion：播放是否成功
    func play(_ audio: MPAudioProtocol, playlist: MPPlaylistProtocol, completion: @escaping BoolClosure)
    {
        self.playResultCallback = completion
        self.currentAudio = audio
        if playlist.playlistId != currentPlaylist?.playlistId
        {
            self.currentPlaylist = playlist
        }
        self.currentIndex = self.currentPlaylist!.getIndexOf(audio: self.currentAudio)
        self.playlistIndexArray.removeAll()
        for index in 0..<self.currentPlaylist!.playlistAudios.count
        {
            //如果是随机播放，那么去掉这个index
            if playMode == .random && index == self.currentIndex
            {
                
            }
            else
            {
                self.playlistIndexArray.append(index)
            }
        }
        self.elapsedAudioArray.removeAll()      //每次开始一个新的播放列表时，都清空原来的临时播放记录
        self.indexsOfIfNextPlay.removeAll()     //每次开始一个新的播放列表时，都清空下一首播放列表
        self.prepareToPlay(audio)
    }
    
    ///下一首播放，在当前播放列表中插入一首新乐曲并且会在当前歌曲播放完毕后播放，不管是何种播放模式
    func playFollow(_ audio: MPAudioProtocol)
    {
        //将新歌曲插入到当前播放列表
        if let playlist = self.currentPlaylist
        {
            var index = currentIndex + 1
            index = playlist.insertAudio(audio: audio, index: index)
            indexsOfIfNextPlay.append(index)   //记录下一首播放的index
            if let del = self.delegate
            {
                del.mpPlayerPlaylistChanged(self.currentAudio!, playlist: self.currentPlaylist!)
            }
        }
    }
    
    ///恢复播放，前提是暂停状态
    func resume()
    {
        if isPaused
        {
            player.play()
            FSLog("really to play")
            if let delegate = self.delegate
            {
                delegate.mpPlayerResumeToPlay(currentAudio!, playlist: currentPlaylist!)
            }
        }
    }
    
    ///暂停，前提是正在播放
    func pause()
    {
        if isPlaying
        {
            player.pause()
            FSLog("really to pause")
            if let delegate = self.delegate
            {
                delegate.mpPlayerPauseToPlay(currentAudio!, playlist: currentPlaylist!)
            }
        }
    }
    
    ///停止播放，清理播放资源，保留播放器
    func stop()
    {
        FSLog("really to stop")
        player.pause()
        if let ob = timeObserver
        {
            player.removeTimeObserver(ob)
            timeObserver = nil
        }
        playerItem?.removeObserver(self, forKeyPath: PlayerKeyPath.status.rawValue)
        player.replaceCurrentItem(with: nil)
        playerItem = nil
        itemAsset = nil
        
        if let delegate = self.delegate, currentAudio != nil
        {
            delegate.mpPlayerStopToPlay(currentAudio!, playlist: currentPlaylist!)
        }
    }
    
    ///下一首，如果有的话
    func next()
    {
        if currentPlaylist?.playlistAudios.count ?? 0 > 0
        {
            //保存已经播放的歌曲
            self.elapsedAudioArray.append(self.currentAudio!)
            self.playNextByMode()
        }
    }
    
    ///上一首，如果有的话
    func previous()
    {
        if currentPlaylist?.playlistAudios.count ?? 0 > 0
        {
            self.playPreviousByMode()
        }
    }
    
    ///总时间
    var totalTime: TimeInterval {
        if let item = playerItem
        {
            return CMTimeGetSeconds(item.duration)
        }
        return 0
    }
    
    ///当前时间
    var currentTime: TimeInterval {
        if let time = playerItem?.currentTime()
        {
            return CMTimeGetSeconds(time)
        }
        return 0.0
    }
    
    ///拖动进度到某个时刻
    func seek(_ to: TimeInterval, success: BoolClosure?)
    {
        if !isFree
        {
            //将时间限制在歌曲总时长内
            player.seek(to: CMTimeMakeWithSeconds(limitIn(to, min: 0, max: totalTime - 1), preferredTimescale: itemAsset!.duration.timescale), toleranceBefore: .zero, toleranceAfter: .zero) {[weak self] (succeed) in
                if let delegate = self?.delegate
                {
                    delegate.mpPlayerTimeChange(self?.currentTime ?? 0)
                }
                if let cb = success
                {
                    cb(succeed)
                }
            }
        }
        else
        {
            if let cb = success
            {
                cb(false)
            }
        }
    }
    
    ///向前或向后跳过几秒
    ///backward：为true则向后，最小0；为false则向前，最大就是歌曲duration
    func skip(_ by: TimeInterval, backward: Bool = false, success: BoolClosure?)
    {
        if let item = playerItem
        {
            var newTime = currentTime + (backward ? -by : by)
            newTime = limitIn(newTime, min: 0.0, max: CMTimeGetSeconds(item.duration))  //限制范围
            seek(newTime) { (succeed) in
                if let cb = success
                {
                    cb(succeed)
                }
            }
        }
        else
        {
            if let cb = success
            {
                cb(false)
            }
        }
    }
    
    ///改变播放速率
    func setPlayRate(_ rate: Float)
    {
        playRate = rate
        self.player.rate = rate
        if let delegate = self.delegate
        {
            delegate.mpPlayerRateChange(rate)
        }
    }
    
}
