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
    
    fileprivate var mpr = MPManager.shared
    
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
        self.song = mpr.currentSong
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
            make.height.equalTo(fitX(16))
            make.left.equalToSuperview().offset(fitX(54))
            make.right.equalToSuperview().offset(fitX(-54))
        }
        //艺术家和专辑名字
        artistLabel = UILabel()
        view.addSubview(artistLabel)
        artistLabel.snp.makeConstraints { make in
            make.top.equalTo(songNameLabel.snp.bottom).offset(fitX(5))
            make.height.equalTo(fitX(12))
            make.centerX.equalToSuperview()
            make.left.right.equalTo(songNameLabel)
        }
        //专辑图
        albumView = InfiniteRotateView(frame: CGRect(x: fitX(30), y: artistLabel.y + artistLabel.height + fitX(150), width: kScreenWidth - fitX(30 * 2), height: kScreenWidth - fitX(30 * 2)), bgImage: .iDiscImage, contentImage: .iMiku_0)
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
            make.width.equalTo(fitX(50))
        }
        totalTimeLabel = UILabel()
        view.addSubview(totalTimeLabel)
        totalTimeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(fitX(-8))
            make.height.equalTo(fitX(13))
            make.centerY.equalTo(pastTimeLabel)
            make.width.equalTo(fitX(50))
        }
        //进度条
        progressBar = UISlider()
        view.addSubview(progressBar)
        progressBar.snp.makeConstraints { (make) in
            make.left.equalTo(pastTimeLabel.snp.right).offset(fitX(3))
            make.right.equalTo(totalTimeLabel.snp.left).offset(fitX(-3))
            make.height.equalTo(fitX(13))
            make.centerY.equalTo(pastTimeLabel)
        }
        
    }
    
    override func configUI() {
        super.configUI()
        view.backgroundColor = .lightGray
        
        bgImgView.image = UIImage.iMiku_0
        bgBlurView.alpha = 0.95
        
        backBtn.setImage(UIImage.iBackLightAlways, for: .normal)
        backBtn.addTarget(self, action: #selector(backAction(sender:)), for: .touchUpInside)
        
        songNameLabel.textColor = .white
        songNameLabel.textAlignment = .center
        songNameLabel.font = .systemFont(ofSize: fitX(16))
        artistLabel.textColor = .cGray_E7E7E7
        artistLabel.textAlignment = .center
        artistLabel.font = .systemFont(ofSize: fitX(12))
        
        albumView.clickCallback = {
            
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
        progressBar.maximumTrackTintColor = .gray
        progressBar.addTarget(self, action: #selector(progressBarAction(sender:)), for: .touchUpInside)
        progressBar.addTarget(self, action: #selector(progressBarAction(sender:)), for: .touchUpOutside)
    }
    
    override func updateUI() {
        //更新歌曲显示信息
        if let song = song as? MPSongModel, let asset = song.asset {
            songNameLabel.text = song.name
            artistLabel.text = (asset[.artist] as? String ?? "") + " - " + (asset[.albumName] as? String ?? "")
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
                albumView.contentImage = .iMiku_0
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
            mpr.performPlayCurrent { (succeed) in
                
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

    //进度条拖动
    @objc func progressBarAction(sender: UISlider)
    {
        mpr.setCurrentTime(TimeInterval(sender.value)) { (succeed) in
            
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
    
}


extension MusicPlayViewController: DelegateProtocol, MPManagerDelegate
{
    func mpManagerDidInitCompleted() {
        
    }
    
    func mpManagerDidUpdated() {
        
    }
    
    func mpManagerWaitToPlay(_ song: MPAudioProtocol) {
        self.song = song
        updateUI()
        loadingView.startAnimating()
        playPauseBtn.isHidden = true
    }
    
    func mpManagerStartPlay(_ song: MPAudioProtocol) {
        self.song = song
        updateUI()
        loadingView.stopAnimating()
        playPauseBtn.isHidden = false
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
        progressBar.setValue(Float(progress), animated: false)
    }
    
    func mpManagerBufferProgressChange(_ progress: TimeInterval) {
        
    }
    
    
}
