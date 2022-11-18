//
//  MusicPlayViewController.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/10/22.
//

import UIKit

class MusicPlayViewController: BasicViewController {
    //MARK: 属性
    var song: MPAudioProtocol?
    var lyric: MPLyricModel?
    
    fileprivate unowned var mpr = MPManager.shared
    
    //UI组件
    fileprivate var bgImgView: UIImageView!         //背景图
    fileprivate var bgBlurView: UIVisualEffectView! //背景模糊效果
    fileprivate var backBtn: UIButton!      //返回按钮
    fileprivate var songNameLabel: UILabel!     //歌曲名
    fileprivate var artistLabel: UILabel!       //艺术家和专辑名字
    fileprivate var albumView: InfiniteRotateView!      //专辑旋转动画
    fileprivate var bottomContainerView: UIView!        //底部控制组件容器
    fileprivate var playPauseBtn: UIButton!     //播放暂停按钮
    fileprivate var previousBtn: UIButton!      //上一首
    fileprivate var nextBtn: UIButton!  //下一首
    fileprivate var loadingView: UIActivityIndicatorView!       //正在加载提示
    fileprivate var playModeBtn: UIButton!      //播放模式
    fileprivate var playlistBtn: UIButton!      //播放列表
    fileprivate var progressBar: UISlider!      //进度条
    fileprivate var pastTimeLabel: UILabel!     //经过时间
    fileprivate var totalTimeLabel: UILabel!    //所有时间
    fileprivate var favoriteBtn: UIButton!      //我喜欢按钮
    fileprivate var addSonglistBtn: UIButton!   //添加到歌单
    fileprivate lazy var lyricView: MPLyricView = {  //歌词视图
        let v = MPLyricView()
        v.isHidden = true
        v.alpha = 0.0
        view.addSubview(v)
        v.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(backBtn.snp.bottom).offset(fitX(20))
            make.bottom.equalTo(favoriteBtn.snp.top).offset(fitX(-20))
        }
        return v
    }()
    
    //是否在拖动进度条，拖动的时候不应该修改进度条数值
    fileprivate var isDragProgress: Bool = false
    
    //MARK: 方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ApplicationManager.shared.screenIdle = true
        mpr.hideMiniPlayer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ApplicationManager.shared.screenIdle = false
    }
    
    override func customConfig() {
        self.hideNavBar = true
        self.statusBarStyle = .light
    }
    
    override func initData() {
        super.initData()
        mpr.addDelegate(self)
        if mpr.isPlaying
        {
            self.song = mpr.currentSong
        }
        else
        {
            mpr.getLastSong {[weak self] song in
                if let song = song {
                    self?.song = song
                }
            }
        }
        self.tryShowLyric() //尝试获取歌词
    }
    
    override func createUI() {
        super.createUI()
        //背景
        bgImgView = UIImageView()
        view.addSubview(bgImgView)
        bgImgView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
        //背景模糊
        bgBlurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        view.addSubview(bgBlurView)
        bgBlurView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalTo(self.bgImgView)
        }
        //返回按钮
        backBtn = UIButton(type: .custom)
        view.addSubview(backBtn)
        backBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(fitX(10))
            make.width.equalTo(fitX(40))
            make.height.equalTo(fitX(40))
            make.top.equalToSuperview().offset(kStatusHeight + fitX(4))
        }
        //歌名
        songNameLabel = UILabel()
        view.addSubview(songNameLabel)
        songNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kStatusHeight + fitX(4))
            make.height.equalTo(fitX(18))
            make.left.equalToSuperview().offset(fitX(54))
            make.right.equalToSuperview().offset(fitX(-54))
        }
        //艺术家和专辑名字
        artistLabel = UILabel()
        view.addSubview(artistLabel)
        artistLabel.snp.makeConstraints { make in
            make.top.equalTo(songNameLabel.snp.bottom).offset(fitX(5))
            make.height.equalTo(fitX(14))
            make.centerX.equalToSuperview()
            make.left.right.equalTo(songNameLabel)
        }
        //专辑图
        albumView = InfiniteRotateView(frame: CGRect(x: fitX(30), y: artistLabel.y + artistLabel.height + fitX(150), width: kScreenWidth - fitX(30 * 2), height: kScreenWidth - fitX(30 * 2)), bgImage: .iDiscImage, contentImage: .iDefaultDisc)
        view.addSubview(albumView)
        //底部容器
        bottomContainerView = UIView()
        view.addSubview(bottomContainerView)
        bottomContainerView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kSafeBottomHeight + fitX(-10))
            make.height.equalTo(fitX(60))
        }
        //播放暂停按钮
        playPauseBtn = UIButton(type: .custom)
        bottomContainerView.addSubview(playPauseBtn)
        playPauseBtn.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(fitX(60))
        }
        //加载提示
        loadingView = UIActivityIndicatorView(style: .large)
        bottomContainerView.addSubview(loadingView)
        loadingView.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalTo(playPauseBtn)
        }
        //下一首
        nextBtn = UIButton(type: .custom)
        bottomContainerView.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(playPauseBtn.snp.right).offset(fitX(30))
            make.width.height.equalTo(fitX(40))
        }
        //上一首
        previousBtn = UIButton(type: .custom)
        bottomContainerView.addSubview(previousBtn)
        previousBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(playPauseBtn.snp.left).offset(fitX(-30))
            make.width.height.equalTo(fitX(40))
        }
        //播放列表
        playlistBtn = UIButton(type: .custom)
        bottomContainerView.addSubview(playlistBtn)
        playlistBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(fitX(30))
            make.right.equalToSuperview().offset(fitX(-25))
        }
        //播放模式
        playModeBtn = UIButton(type: .custom)
        bottomContainerView.addSubview(playModeBtn)
        playModeBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(fitX(30))
            make.left.equalToSuperview().offset(fitX(25))
        }
        //时间
        pastTimeLabel = UILabel()
        view.addSubview(pastTimeLabel)
        pastTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(fitX(8))
            make.height.equalTo(fitX(13))
            make.bottom.equalTo(bottomContainerView.snp.top).offset(fitX(-10))
            make.width.equalTo(fitX(48))
        }
        totalTimeLabel = UILabel()
        view.addSubview(totalTimeLabel)
        totalTimeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(fitX(-8))
            make.height.equalTo(fitX(13))
            make.centerY.equalTo(pastTimeLabel)
            make.width.equalTo(fitX(48))
        }
        //进度条
        progressBar = UISlider()
        view.addSubview(progressBar)
        progressBar.snp.makeConstraints { (make) in
            make.left.equalTo(pastTimeLabel.snp.right).offset(fitX(5))
            make.right.equalTo(totalTimeLabel.snp.left).offset(fitX(-5))
            make.height.equalTo(fitX(13))
            make.centerY.equalTo(pastTimeLabel)
        }
        //我喜欢按钮
        favoriteBtn = UIButton(type: .custom)
        view.addSubview(favoriteBtn)
        favoriteBtn.snp.makeConstraints { make in
            make.left.equalTo(progressBar.snp.left).offset(fitX(-10))
            make.bottom.equalTo(progressBar.snp.top).offset(fitX(-20))
            make.width.equalTo(fitX(39))
            make.height.equalTo(fitX(35))
        }
        //添加到歌单
        addSonglistBtn = UIButton(type: .custom)
        view.addSubview(addSonglistBtn)
        addSonglistBtn.snp.makeConstraints { make in
            make.left.equalTo(favoriteBtn.snp.right).offset(fitX(30))
            make.centerY.equalTo(favoriteBtn)
            make.width.equalTo(fitX(37))
            make.height.equalTo(fitX(36))
        }
        
    }
    
    override func configUI() {
        super.configUI()
        view.backgroundColor = .lightGray
        
        bgImgView.contentMode = .scaleAspectFill
        bgImgView.clipsToBounds = true
        bgImgView.image = UIImage.iMiku_0
        
        bgBlurView.alpha = 0.95
        
        backBtn.setImage(UIImage.iBackLightAlways, for: .normal)
        backBtn.addTarget(self, action: #selector(backAction(sender:)), for: .touchUpInside)
        
        songNameLabel.textColor = .white
        songNameLabel.textAlignment = .center
        songNameLabel.font = .systemFont(ofSize: fitX(16))
        artistLabel.textColor = .cGray_E7E7E7
        artistLabel.textAlignment = .center
        artistLabel.font = .systemFont(ofSize: fitX(13))
        
        albumView.clickCallback = {[weak self] in
            self?.showLyricView()
        }
        
        playPauseBtn.setImage(.iPlayBtn, for: .normal)
        playPauseBtn.setImage(.iPauseBtn, for: .selected)
        playPauseBtn.addTarget(self, action: #selector(playPauseAction(sender:)), for: .touchUpInside)
        
        loadingView.color = .white
        
        nextBtn.setImage(.iNextBtn, for: .normal)
        nextBtn.addTarget(self, action: #selector(nextAction(sender:)), for: .touchUpInside)
        previousBtn.setImage(.iPreviousBtn, for: .normal)
        previousBtn.addTarget(self, action: #selector(previousAction(sender:)), for: .touchUpInside)
        
        playlistBtn.setImage(.iPlaylistBtn, for: .normal)
        playlistBtn.addTarget(self, action: #selector(playlistAction(sender:)), for: .touchUpInside)
        
        playModeBtn.setImage(.iRandomBtn, for: .normal)
        playModeBtn.addTarget(self, action: #selector(playModeAction(sender:)), for: .touchUpInside)
        
        pastTimeLabel.text = "00:00"
        pastTimeLabel.textColor = .lightGray
        pastTimeLabel.font = .systemFont(ofSize: fitX(12))
        pastTimeLabel.textAlignment = .right
        
        totalTimeLabel.text = "00:00"
        totalTimeLabel.textColor = .lightGray
        totalTimeLabel.font = .systemFont(ofSize: fitX(12))
        totalTimeLabel.textAlignment = .left
        
        progressBar.value = 0.0
        progressBar.setThumbImage(.iPlayProgressBtn, for: .normal)
        progressBar.minimumTrackTintColor = .white
        progressBar.maximumTrackTintColor = .gray.withAlphaComponent(0.4)
        progressBar.addTarget(self, action: #selector(progressBarAction(sender:)), for: .touchUpInside)
        progressBar.addTarget(self, action: #selector(progressBarAction(sender:)), for: .touchUpOutside)
        progressBar.addTarget(self, action: #selector(progressBeginDrag(sender:)), for: .touchDown)
        progressBar.addTarget(self, action: #selector(progressCancelDrag(sender:)), for: .touchCancel)
        
        favoriteBtn.setImage(.iPlayUnfavoriteBtn, for: .normal)
        favoriteBtn.setImage(.iPlayFavoriteBtn, for: .selected)
        favoriteBtn.addTarget(self, action: #selector(favoriteAction(sender:)), for: .touchUpInside)
        
        addSonglistBtn.setImage(.iPlayAddSonglistBtn, for: .normal)
        addSonglistBtn.addTarget(self, action: #selector(addSonglistAction(sender:)), for: .touchUpInside)
    }
    
    override func updateUI() {
        //更新歌曲显示信息
        if let song = song as? MPSongModel, let asset = song.asset {
            bgImgView.image = asset[.artwork] as? UIImage ?? UIImage.iMiku_0
            //调整模糊图层的色调
            if let img = asset[.artwork] as? UIImage {
                img.getMainHue {[weak self] color in
                    if let color = color {
                        self?.bgBlurView.backgroundColor = color.withAlphaComponent(0.5)
                    }
                    else
                    {
                        self?.bgBlurView.backgroundColor = .clear
                    }
                }
            }
            else
            {
                bgBlurView.backgroundColor = .clear
            }
            songNameLabel.text = song.name
            artistLabel.text = (asset[.artist] as? String ?? "") + " - " + (asset[.albumName] as? String ?? "")
            favoriteBtn.isSelected = song.isFavorite
            totalTimeLabel.text = TimeEmbellisher.shared.convertSecondsToMinute(Int(mpr.currentTotalTime))
            pastTimeLabel.text = TimeEmbellisher.shared.convertSecondsToMinute(Int(mpr.currentPastTime))
            progressBar.minimumValue = 0.0
            progressBar.maximumValue = Float(mpr.currentTotalTime)
            progressBar.setValue(Float(mpr.currentPastTime), animated: false)
            if let albumImg = asset[.artwork] as? UIImage {
                albumView.contentImage = albumImg
            }
            else
            {
                albumView.contentImage = .iDefaultDisc
            }
            albumView.updateView()
        }
        //控制界面显示状态
        playPauseBtn.isSelected = mpr.isPlaying
        if mpr.isPlaying
        {
            albumView.startAnimation()
        }
        else
        {
            albumView.stopAnimation()
        }
        self.playModeBtn.setImage(getPlayModeImage(), for: .normal)
        if mpr.isPlaying
        {
            startRotateAnimation()
        }
        else
        {
            stopRotateAnimation()
        }
    }
    
    //根据播放模式获取图片
    fileprivate func getPlayModeImage() -> UIImage?
    {
        switch mpr.playMode {
        case .random:
            return .iRandomBtn
        case .singleCycle:
            return .iSingleBtn
        case .sequence:
            return .iSequenceBtn
        }
    }
    
    //播放暂停按钮
    @objc func playPauseAction(sender: UIButton)
    {
        if playPauseBtn.isSelected
        {
            mpr.pause()
        }
        else
        {
            mpr.wantPlayCurrent { (succeed) in
                
            }
        }
    }
    
    //下一首
    @objc func nextAction(sender: UIButton)
    {
        mpr.playNext()
    }
    
    //上一首
    @objc func previousAction(sender: UIButton)
    {
        mpr.playPrevious()
    }
    
    //播放列表
    @objc func playlistAction(sender: UIButton)
    {
        DialogManager.shared.wantShowPlaylist()
    }

    //播放模式
    @objc func playModeAction(sender: UIButton)
    {
        switch mpr.playMode {
        case .random:
            mpr.playMode = .sequence
        case .sequence:
            mpr.playMode = .singleCycle
        case .singleCycle:
            mpr.playMode = .random
        }
        playModeBtn.setImage(getPlayModeImage(), for: .normal)
    }
    
    //收藏按钮
    @objc func favoriteAction(sender: UIButton)
    {
        if let song = song as? MPSongModel {
            g_loading()
            mpr.setFavoriteSong(!song.isFavorite, song: song) { succeed in
                g_endLoading()
                //保存成功则刷新列表
                if succeed
                {
                    self.favoriteBtn.isSelected = !self.favoriteBtn.isSelected
                }
            }
        }
    }
    
    //添加歌单
    @objc func addSonglistAction(sender: UIButton)
    {
        if let song = song as? MPSongModel {
            mpr.getAllSonglists { songlists in
                if let songlists = songlists {
                    DialogManager.shared.wantShowAddToSonglist(song: song, songlists: songlists)
                }
            }
        }
    }
    
    //开始拖动进度条
    @objc func progressBeginDrag(sender: UISlider)
    {
        self.isDragProgress = true
    }
    
    //取消拖动进度条
    @objc func progressCancelDrag(sender: UISlider)
    {
        self.isDragProgress = false
    }

    //进度条拖动
    @objc func progressBarAction(sender: UISlider)
    {
        mpr.setCurrentTime(TimeInterval(sender.value)) {[weak self] (succeed) in
            self?.isDragProgress = false
        }
    }
    
    //播放时专辑图旋转动画
    fileprivate func startRotateAnimation()
    {
        albumView.startAnimation()
    }
    
    //停止旋转动画
    fileprivate func stopRotateAnimation()
    {
        albumView.stopAnimation()
    }
    
    //尝试获取歌词
    fileprivate func tryShowLyric()
    {
        if let song = song {
            mpr.getLyric(song) {[weak self] lyric in
                self?.lyric = lyric
                if self?.albumView.isHidden ?? false
                {
                    self?.lyricView.lyricModel = lyric
                    g_after(0.11) {
                        self?.lyricView.setCurrentTime(self?.mpr.currentPastTime ?? 0)
                    }
                }
            }
        }
    }
    
    //显示歌词view
    fileprivate func showLyricView()
    {
        if lyric == nil
        {
            tryShowLyric()
        }
        if lyricView.lyricModel == nil
        {
            lyricView.lyricModel = lyric
        }
        if lyricView.locateCallback == nil
        {
            lyricView.locateCallback = {[weak self] time in
                self?.mpr.setCurrentTime(time, completion: { succeed in
                    
                })
            }
        }
        if lyricView.tapCallback == nil
        {
            lyricView.tapCallback = {[weak self] in
                self?.hideLyricView()
            }
        }
        lyricView.isHidden = false
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
            self.albumView.alpha = 0.0
            self.lyricView.alpha = 1.0
        } completion: { finished in
            self.albumView.isHidden = true
            self.albumView.stopAnimation()
        }
    }
    
    //隐藏歌词view
    fileprivate func hideLyricView()
    {
        if mpr.isPlaying
        {
            albumView.startAnimation()
        }
        albumView.isHidden = false
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
            self.albumView.alpha = 1.0
            self.lyricView.alpha = 0.0
        } completion: { finished in
            self.lyricView.isHidden = true
        }
    }
    
}


extension MusicPlayViewController: DelegateProtocol, MPManagerDelegate
{
    func mpManagerDidInitCompleted() {
        //初始化完成则尝试显示当前播放歌曲，不一定有，也不一定会调用
        mpr.getLastSong {[weak self] song in
            if let song = song {
                self?.song = song
                self?.updateUI()
            }
        }
    }
    
    func mpManagerDidUpdated() {
        
    }
    
    func mpManagerWaitToPlay(_ song: MPAudioProtocol) {
        self.song = song
        updateUI()
        loadingView.startAnimating()
        playPauseBtn.isHidden = true
        lyric = nil //清除上一首歌词
        lyricView.lyricModel = nil
    }
    
    func mpManagerStartPlay(_ song: MPAudioProtocol) {
        self.song = song
        updateUI()
        loadingView.stopAnimating()
        playPauseBtn.isHidden = false
        tryShowLyric()
    }
    
    func mpManagerPausePlay(_ song: MPAudioProtocol) {
        playPauseBtn.isSelected = false
        stopRotateAnimation()
    }
    
    func mpManagerResumePlay(_ song: MPAudioProtocol) {
        playPauseBtn.isSelected = true
        startRotateAnimation()
    }
    
    func mpManagerFailedPlay(_ song: MPAudioProtocol) {
        playPauseBtn.isSelected = false
        stopRotateAnimation()
        loadingView.stopAnimating()
        playPauseBtn.isHidden = false
    }
    
    func mpManagerProgressChange(_ progress: TimeInterval) {
        pastTimeLabel.text = TimeEmbellisher.shared.convertSecondsToMinute(Int(mpr.currentPastTime))
        if !isDragProgress
        {
            progressBar.setValue(Float(progress), animated: false)
        }
        if albumView.isHidden == true   //如果专辑图隐藏了，说明在显示歌词
        {
            lyricView.setCurrentTime(progress)
        }
    }
    
    func mpManagerBufferProgressChange(_ progress: TimeInterval) {
        
    }
    
    func mpManagerDidUpdateFavoriteSongs(_ favoriteSongs: MPFavoriteModel) {
        
    }
    
    func mpManagerDidUpdateCurrentPlaylist(_ currentPlaylist: MPPlaylistModel) {
        
    }
    
    func mpManagerDidUpdateHistorySongs(_ history: MPHistoryAudioModel) {
        
    }
    
    func mpManagerDidUpdateSonglists(_ songlists: [MPSonglistModel]) {
        
    }
    
}
