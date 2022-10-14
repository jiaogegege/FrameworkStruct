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
    
    ///等待播放某个音频，加载中
    func mpPlayerLoadingToPlay(_ audio: MPAudioProtocol, playlist: MPPlaylistProtocol)
    
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
    
    //播放模式，默认顺序播放
    fileprivate var playMode: PlayMode = .sequence
    
    //播放速率，默认1.0，可设置为0.0～2.0
    @LimitNumRange(min: 0.0, max: 3.0) fileprivate var playRate: Float = 1.0 {
        willSet {
            self.player.rate = newValue
        }
    }
    
    //代理对象
    weak var delegate: MPPlayerDelegate?
    
    //播放器
    fileprivate var player: AVPlayer
    //播放器资源
    fileprivate var playerItem: AVPlayerItem?
    //资源信息
    fileprivate var itemAsset: AVURLAsset?
    
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
        if let cb = playResultCallback
        {
            cb(result)
            playResultCallback = nil    //执行完后清空
        }
    }
    
    ///播放下一首乐曲，根据不同的播放模式
    fileprivate func playNextByMode()
    {
        //先获取下一首乐曲
        self.currentAudio = self.getNextAudioByMode()
        //准备播放
        self.prepareToPlay(currentAudio!)
    }
    
    //获取下一首乐曲
    fileprivate func getNextAudioByMode() -> MPAudioProtocol
    {
        switch playMode {
        case .sequence:     //顺序播放
            currentIndex += 1
            if currentIndex >= currentPlaylist!.playlistAudios.count
            {
                currentIndex = 0
            }
            return currentPlaylist!.playlistAudios[currentIndex]
        case .singleCycle:  //单曲循环
            return currentPlaylist!.playlistAudios[currentIndex]
        case .random:       //随机播放
            //稍后开发，当前先返回单曲循环
            return currentPlaylist!.playlistAudios[currentIndex]
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
                else if status == .unknown  //未知，可能在加载网络资源
                {
                    FSLog("player status unknown")
//                    self.performPlayCallback(false)
                    if let del = self.delegate
                    {
                        del.mpPlayerLoadingToPlay(currentAudio!, playlist: currentPlaylist!)
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
    ///播放一首音乐
    ///参数：audio：歌曲对象；playlist：所在播放列表；completion：播放是否成功
    func play(_ audio: MPAudioProtocol, playlist: MPPlaylistProtocol, completion: @escaping BoolClosure)
    {
        self.playResultCallback = completion
        self.currentAudio = audio
        self.currentPlaylist = playlist
        self.currentIndex = self.currentPlaylist!.getIndexOf(audio: self.currentAudio)
        self.prepareToPlay(audio)
    }
    
    ///是否在播放
    var isPlaying: Bool {
        player.timeControlStatus == .playing ? true : false
    }
    
    ///恢复播放，前提是暂停状态
    func resume()
    {
        if player.timeControlStatus == .paused, self.currentAudio != nil
        {
            player.play()
            if let delegate = self.delegate
            {
                delegate.mpPlayerResumeToPlay(currentAudio!, playlist: currentPlaylist!)
            }
        }
    }
    
    ///暂停，前提是正在播放
    func pause()
    {
        if player.timeControlStatus == .playing, self.currentAudio != nil
        {
            player.pause()
            if let delegate = self.delegate
            {
                delegate.mpPlayerPauseToPlay(currentAudio!, playlist: currentPlaylist!)
            }
        }
    }
    
    ///停止播放，清理播放资源，保留播放器
    func stop()
    {
        player.pause()
        playerItem?.removeObserver(self, forKeyPath: PlayerKeyPath.status.rawValue)
        itemAsset = nil
        playerItem = nil
        player.replaceCurrentItem(with: nil)
        
        if let delegate = self.delegate, currentAudio != nil
        {
            delegate.mpPlayerStopToPlay(currentAudio!, playlist: currentPlaylist!)
        }
    }
    
    ///下一首，如果有的话
    func next()
    {
        
    }
    
    ///上一首，如果有的话
    func previous()
    {
        
    }
    
    
    
}
