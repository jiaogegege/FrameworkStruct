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
    
    fileprivate unowned var mpr: MPManager = MPManager.shared
    
    //UI
    fileprivate var bgImgView: UIImageView!     //底图
    fileprivate var albumView: InfiniteRotateView!  //唱片专辑动图
    fileprivate var textContainerView: ScrollAnimationView!      //歌名文本容器
    fileprivate var textScrollView: UIView!     //文本滚动view
    fileprivate var songLabel: UILabel!         //歌名label
    fileprivate var artistlabel: UILabel!       //歌手和专辑
    fileprivate var playlistBtn: UIButton!      //播放列表按钮
    fileprivate var nextBtn: UIButton!      //下一首按钮
    fileprivate var playPauseBtn: UIButton!     //播放暂停按钮
    fileprivate var loadingView: UIActivityIndicatorView!       //加载提示
    fileprivate var progressBar: UIProgressView!        //进度
    
    //MARK: 方法
    //固定尺寸
    init() {
        super.init(frame: CGRect(x: 0, y: kScreenHeight, width: Self.vWidth, height: Self.vHeight))
        self.mpr.addDelegate(self)
        if mpr.isPlaying
        {
            self.currentSong = mpr.currentSong as? MPSongModel
        }
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
        playlistBtn.frame = CGRect(x: self.width - 10 - 35, y: (self.height - 35) / 2.0, width: 35, height: 35)
        addSubview(playlistBtn)
        
        nextBtn = UIButton(type: .custom)
        nextBtn.frame = CGRect(x: playlistBtn.x - 4 - 35, y: (self.height - 35) / 2.0, width: 35, height: 35)
        addSubview(nextBtn)
        
        playPauseBtn = UIButton(type: .custom)
        playPauseBtn.frame = CGRect(x: nextBtn.x - 6 - 35, y: (self.height - 35) / 2.0, width: 35, height: 35)
        addSubview(playPauseBtn)
        
        loadingView = UIActivityIndicatorView(style: .medium)
        loadingView.frame = playPauseBtn.frame
        addSubview(loadingView)
        
        albumView = InfiniteRotateView(frame: CGRect(x: 8, y: -12, width: 55, height: 55), bgImage: .iMiniDiscBg, contentImage: nil)
        addSubview(albumView)
        
        textContainerView = ScrollAnimationView(frame: CGRect(x: 8 + 55 + 10, y: 0, width: playPauseBtn.x - (8 + 55 + 10) - 8, height: self.height))
        addSubview(textContainerView)
        
        textScrollView = UIView(frame: textContainerView.bounds)
//        textContainerView.addSubview(textScrollView)
        
        songLabel = UILabel(frame: CGRect(x: 0, y: 6, width: 0, height: 15))
        textScrollView.addSubview(songLabel)
        
        artistlabel = UILabel(frame: CGRect(x: 0, y: songLabel.y + songLabel.height + 6, width: 0, height: 12))
        textScrollView.addSubview(artistlabel)
        
        progressBar = UIProgressView(frame: CGRect(x: 0, y: self.height - 3, width: self.width, height: 3))
        addSubview(progressBar)
    }
    
    override func configView() {
        self.backgroundColor = bgColor
        self.addPathShadow(color: .cBlack_5, opacity: 0.3)
        
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
        
        loadingView.color = .cBlack_5
        
        albumView.animationTime = 60.0
        albumView.ratio = 0.818
        albumView.clickCallback = {[weak self] in
            self?.gotoMusicPlayVC()
        }
        
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
        DialogManager.shared.wantShowPlaylist()
    }
    
    @objc func nextAction(sender: UIButton)
    {
        mpr.playNext()
    }
    
    @objc func playPauseAction(sender: UIButton)
    {
        if playPauseBtn.isSelected  //暂停
        {
            mpr.pause()
        }
        else    //开始或继续播放
        {
            sender.isEnabled = false
            mpr.performPlayCurrent { (succeed) in
                sender.isEnabled = true
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
        mpr.getLastSong {[weak self] song in
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
            loadingView.startAnimating()
            playPauseBtn.isHidden = true
        }
    }
    
    func mpManagerStartPlay(_ song: MPAudioProtocol) {
        if let song = song as? MPSongModel {
            currentSong = song
            updateView()
            loadingView.stopAnimating()
            playPauseBtn.isHidden = false
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
            loadingView.stopAnimating()
            playPauseBtn.isHidden = false
        }
    }
    
    func mpManagerProgressChange(_ progress: TimeInterval) {
        progressBar.setProgress(Float(progress / mpr.currentTotalTime), animated: false)
    }
    
    func mpManagerBufferProgressChange(_ progress: TimeInterval) {
        
    }
    
    func mpManagerDidUpdateFavoriteSongs(_ favoriteSongs: MPFavoriteModel) {
        
    }
    
    func mpManagerDidUpdateCurrentPlaylist(_ currentPlaylist: MPPlaylistModel) {
        
    }
    
    func mpManagerDidUpdateHistorySongs(_ history: MPHistoryAudioModel) {
        
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
                albumView.contentImage = .iDefaultDisc
            }
            albumView.updateView()
            //歌名和歌手名
            songLabel.text = song.name
            songLabel.sizeToFit()
            artistlabel.text = (asset[.artist] as? String ?? "") + " - " + (asset[.albumName] as? String ?? "")
            artistlabel.sizeToFit()
            textScrollView.width = maxBetween(songLabel.width, artistlabel.width)
            textContainerView.slotView = textScrollView
            textContainerView.updateView()
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
        self.y = kScreenHeight + 12
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
            self.y = kScreenHeight + 12
        } completion: { finished in
            self.isHidden = true
        }

    }
    
}
