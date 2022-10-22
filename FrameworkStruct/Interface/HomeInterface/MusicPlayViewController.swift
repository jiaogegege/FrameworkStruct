//
//  MusicPlayViewController.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/10/22.
//

import UIKit

class MusicPlayViewController: BasicViewController {
    //MARK: 属性
    var song: MPSongModel?
    
    //UI组件
    fileprivate var bgImgView: UIImageView!         //背景图
    fileprivate var bgBlurView: UIVisualEffectView! //背景模糊效果
    fileprivate var backBtn: UIButton!      //返回按钮
    fileprivate var songNameLabel: UILabel!     //歌曲名
    fileprivate var artistLabel: UILabel!       //艺术家和专辑名字
    fileprivate var discImgView: UIImageView!       //圆形唱片图案
    fileprivate var albumImgView: UIImageView!  //专辑图片
    fileprivate var playPauseBtn: UIButton!     //播放暂停按钮
    fileprivate var previousBtn: UIButton!      //上一首
    fileprivate var nextBtn: UIButton!  //下一首
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
    
    override func customConfig() {
        self.hideNavBar = true
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
        //唱片图
        discImgView = UIImageView()
        view.addSubview(discImgView)
        discImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalTo(fitX(30))
            make.right.equalTo(fitX(-30))
            make.width.equalTo(discImgView.snp.height)
            make.top.equalTo(artistLabel.snp.bottom).offset(fitX(100))
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
        songNameLabel.font = .systemFont(ofSize: fitX(16))
        artistLabel.textColor = .cGray_E7E7E7
        artistLabel.font = .systemFont(ofSize: fitX(12))
        
        discImgView.image = .iDiscImage
        
    }
    
    override func updateUI() {
        
    }
    

}
