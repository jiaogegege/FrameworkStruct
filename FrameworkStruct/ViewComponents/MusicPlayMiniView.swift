//
//  MusicPlayMiniView.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/10/28.
//

/**
 mini音乐播放器界面
 */
import UIKit

class MusicPlayMiniView: UIView
{
    //MARK: 属性
    var bgColor: UIColor = .white       //整体背景色
    var bgImage: UIImage? {       //可以设置一个背景图
        willSet {
            self.bgImgView.image = newValue
        }
    }
    
    fileprivate(set) weak var currentSong: MPSongModel?      //当前播放歌曲
    
    fileprivate lazy var mpr: MPManager = MPManager.shared
    
    //UI
    fileprivate var bgImgView: UIImageView!     //底图
    fileprivate var albumView: InfiniteRotateView!  //唱片专辑动图
    fileprivate var textContainerView: UIView!      //歌名文本容器
    fileprivate var textScrollView: UIView!     //文本滚动view
    fileprivate var songLabel: UILabel!         //歌名label
    fileprivate var artistlabel: UILabel!       //歌手和专辑
    fileprivate var playlistBtn: UIButton!      //播放列表按钮
    fileprivate var nextBtn: UIButton!      //下一首按钮
    fileprivate var playPauseBtn: UIButton!     //播放暂停按钮
    fileprivate var progressBar: UIProgressView!        //进度
    
    //MARK: 方法
    //固定尺寸
    init() {
        super.init(frame: CGRect(x: 0, y: kScreenHeight, width: Self.vWidth, height: Self.vHeight))
        self.mpr.addDelegate(self)
        createView()
        configView()
        updateView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createView() {
        bgImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height))
        addSubview(bgImgView)
        
        playlistBtn = UIButton(type: .custom)
        playlistBtn.frame = CGRect(x: self.width - 12 - 24, y: (self.height - 22) / 2.0, width: 24, height: 22)
        addSubview(playlistBtn)
        
        nextBtn = UIButton(type: .custom)
        nextBtn.frame = CGRect(x: playlistBtn.x - 20 - 17.6, y: (self.height - 22.4) / 2.0, width: 17.6, height: 22.4)
        addSubview(nextBtn)
        
        playPauseBtn = UIButton(type: .custom)
        playPauseBtn.frame = CGRect(x: nextBtn.x - 20 - 33, y: (self.height - 33) / 2.0, width: 33, height: 33)
        addSubview(playPauseBtn)
        
        albumView = InfiniteRotateView(frame: CGRect(x: 9, y: -12, width: 55, height: 55), bgImage: .iMiniDiscBg, contentImage: nil)
        addSubview(albumView)
        
        textContainerView = UIView(frame: CGRect(x: 9 + 55 + 10, y: 0, width: playPauseBtn.x - (9 + 55 + 10) - 8, height: self.height))
        addSubview(textContainerView)
        
        textScrollView = UIView(frame: textContainerView.bounds)
        textContainerView.addSubview(textScrollView)
        
        songLabel = UILabel(frame: CGRect(x: 0, y: 6, width: 0, height: 15))
        textScrollView.addSubview(songLabel)
        
        artistlabel = UILabel(frame: CGRect(x: 0, y: songLabel.y + songLabel.height + 6, width: 0, height: 12))
        textScrollView.addSubview(artistlabel)
        
        progressBar = UIProgressView(frame: CGRect(x: 0, y: self.height - 3, width: self.width, height: 3))
        addSubview(progressBar)
    }
    
    override func configView() {
        self.backgroundColor = bgColor
        
        if let img = bgImage {
            bgImgView.image = img
        }
        
        playlistBtn.setImage(.iMiniPlaylistBtn, for: .normal)
        playlistBtn.addTarget(self, action: #selector(playlistAction(sender:)), for: .touchUpInside)
        
        nextBtn.setImage(.iMiniNextBtn, for: .normal)
        nextBtn.addTarget(self, action: #selector(nextAction(sender:)), for: .touchUpInside)
        
        playPauseBtn.setImage(.iMiniPlayBtn, for: .normal)
        playPauseBtn.setImage(.iMiniPauseBtn, for: .selected)
        playPauseBtn.addTarget(self, action: #selector(playPauseAction(sender:)), for: .touchUpInside)
        
        albumView.animationTime = 60.0
        albumView.ratio = 0.818
        albumView.clickCallback = {[weak self] in
            self?.gotoMusicPlayVC()
        }
        
        textContainerView.clipsToBounds = true
        songLabel.numberOfLines = 1
        songLabel.font = .systemFont(ofSize: 14)
        songLabel.textColor = .cBlack_5
        artistlabel.numberOfLines = 1
        artistlabel.font = .systemFont(ofSize: 11)
        artistlabel.textColor = .lightGray
        
        progressBar.tintColor = .cAccent
        progressBar.setProgress(0, animated: false)
        
    }
    
    @objc func playlistAction(sender: UIButton)
    {
        
    }
    
    @objc func nextAction(sender: UIButton)
    {
        mpr.playNext()
    }
    
    @objc func playPauseAction(sender: UIButton)
    {
        if playPauseBtn.isSelected
        {
            mpr.pause()
        }
        else
        {
            if mpr.isFree
            {
                mpr.getCurrentSong {[weak self] song in
                    if let song = song {
                        self?.mpr.getCurrentPlaylist { playlist in
                            if let playlist = playlist {
                                self?.mpr.playSong(song, in: playlist, completion: { succeed in
                                    FSLog("\(succeed)")
                                })
                            }
                        }
                    }
                }
            }
            else
            {
                mpr.resume()
            }
        }
    }
    
    fileprivate func gotoMusicPlayVC()
    {
        ControllerManager.shared.pushController(MusicPlayViewController.getViewController(), animated: true)
    }
    
}


extension MusicPlayMiniView: DelegateProtocol, MPManagerDelegate
{
    func mpManagerDidInitCompleted() {
        //初始化完成则尝试显示当前播放歌曲，不一定有，也不一定会调用
        mpr.getCurrentSong {[weak self] song in
            if let song = song {
                self?.currentSong = song
                self?.updateView()
            }
        }
    }
    
    func mpManagerDidUpdated() {
        
    }
    
    func mpManagerWaitToPlay(_ song: MPAudioProtocol) {
        if let song = song as? MPSongModel {
            currentSong = song
            updateView()
        }
    }
    
    func mpManagerStartPlay(_ song: MPAudioProtocol) {
        if let song = song as? MPSongModel {
            currentSong = song
            updateView()
        }
    }
    
    func mpManagerPausePlay(_ song: MPAudioProtocol) {
        if let song = song as? MPSongModel {
            currentSong = song
            updateView()
        }
    }
    
    func mpManagerResumePlay(_ song: MPAudioProtocol) {
        if let song = song as? MPSongModel {
            currentSong = song
            updateView()
        }
    }
    
    func mpManagerFailedPlay(_ song: MPAudioProtocol) {
        if let song = song as? MPSongModel {
            currentSong = song
            updateView()
        }
    }
    
    func mpManagerProgressChange(_ progress: TimeInterval) {
        progressBar.setProgress(Float(progress / mpr.currentTotalTime), animated: true)
    }
    
    func mpManagerBufferProgressChange(_ progress: TimeInterval) {
        
    }
    
    
}


extension MusicPlayMiniView: InternalType
{
    //高度
    static let vHeight: CGFloat = 48
    //宽度
    static let vWidth: CGFloat = kScreenWidth
    
}


//外部接口
extension MusicPlayMiniView: ExternalInterface
{
    //手动更新UI
    override func updateView() {
        if let song = currentSong, let asset = song.asset {
            //专辑图
            if let albumImg = asset[.artwork] as? UIImage {
                albumView.contentImage = albumImg
            }
            else
            {
                albumView.contentImage = .iMiku_0
            }
            albumView.updateView()
            //歌名和歌手名
            songLabel.text = song.name
            songLabel.sizeToFit()
            artistlabel.text = (asset[.artist] as? String ?? "") + " - " + (asset[.albumName] as? String ?? "")
            artistlabel.sizeToFit()
            //设置播放
            playPauseBtn.isSelected = mpr.isPlaying
            if mpr.isPlaying
            {
                albumView.startAnimation()
            }
            else
            {
                albumView.stopAnimation()
            }
            //进度
            if mpr.currentPastTime > 0 && mpr.currentTotalTime > 0
            {
                progressBar.setProgress(Float(mpr.currentPastTime / mpr.currentTotalTime), animated: false)
            }
        }
    }
    
    //显示
    func show()
    {
        //做一个从屏幕底部往上弹的动画
        self.isHidden = false
        self.y = kScreenHeight
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
            self.y = kScreenHeight - self.height
        } completion: { finished in
            
        }

    }
    
    //隐藏
    func hide()
    {
        //做一个从底部消失的动画
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
            self.y = kScreenHeight
        } completion: { finished in
            self.isHidden = true
        }

    }
    
}
