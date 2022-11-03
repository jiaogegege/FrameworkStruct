//
//  MPPlaylistSongCell.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/11/2.
//

/**
 播放列表视图中的歌曲cell
 */
import UIKit

class MPPlaylistSongCell: UITableViewCell {
    //MARK: 属性
    var song: MPAudioProtocol? {
        willSet {
            if let song = newValue {
                self.songNameLabel.text = song.audioName
                if let so = song as? MPSongModel, let asset = so.asset {
                    self.artistLabel.text = (asset[.artist] as? String ?? "") + " - " + (asset[.albumName] as? String ?? "")
                }
            }
        }
    }
    
    //当前正在播放的歌曲
    var currentSong: MPAudioProtocol? {
        willSet {
            if newValue?.audioId == song?.audioId   //正在播放
            {
                self.playingImgView.isHidden = false
                self.songNameLabel.textColor = .cAccent
            }
            else
            {
                self.playingImgView.isHidden = true
                self.songNameLabel.textColor = .cBlack_4
            }
        }
    }
    
    //位置
    var number: Int? {
        willSet {
            if let num = newValue {
                self.numberLabel.text = "\(num)"
            }
        }
    }
    
    //删除回调
    var deleteCallback: ((MPAudioProtocol) -> Void)?
    
    fileprivate var numberLabel: UILabel!       //位置序号
    fileprivate var playingImgView: UIImageView!    //正在播放标志
    fileprivate var songNameLabel: UILabel!     //歌曲名
    fileprivate var artistLabel: UILabel!       //艺术家和专辑信息
    fileprivate var deleteBtn: UIButton!        //删除歌曲按钮

    
    //MARK: 方法
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createView()
        configView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createView() {
        numberLabel = UILabel()
        contentView.addSubview(numberLabel)
        numberLabel.snp.makeConstraints { make in
            make.left.equalTo(fitX(8))
            make.top.equalTo(fitX(4))
            make.height.equalTo(fitX(8))
        }
        
        playingImgView = UIImageView()
        contentView.addSubview(playingImgView)
        playingImgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(fitX(8))
            make.width.equalTo(fitX(12))
            make.height.equalTo(fitX(12.85))
        }
        
        songNameLabel = UILabel()
        contentView.addSubview(songNameLabel)
        songNameLabel.snp.makeConstraints { make in
            make.left.equalTo(playingImgView.snp.right).offset(fitX(4))
            make.centerY.equalToSuperview()
            make.height.equalTo(fitX(21))
        }
        
        deleteBtn = UIButton(type: .custom)
        contentView.addSubview(deleteBtn)
        deleteBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(fitX(-12))
            make.width.height.equalTo(fitX(24))
        }
        
        artistLabel = UILabel()
        contentView.addSubview(artistLabel)
        artistLabel.snp.makeConstraints { make in
            make.left.equalTo(songNameLabel.snp.right).offset(fitX(5))
            make.right.lessThanOrEqualTo(deleteBtn.snp.left).offset(fitX(-4))
            make.height.equalTo(fitX(13))
            make.bottom.equalTo(songNameLabel).offset(-1)
        }
    }
    
    override func configView() {
        self.selectionStyle = .none
        
        numberLabel.textColor = .lightGray
        numberLabel.font = .systemFont(ofSize: fitX(8))
        
        playingImgView.isHidden = true
        
        songNameLabel.textColor = .cBlack_4
        songNameLabel.font = .systemFont(ofSize: fitX(17))
        
        deleteBtn.setImage(.iPlaylistDeleteBtn, for: .normal)
        deleteBtn.addTarget(self, action: #selector(deleteAction(sender:)), for: .touchUpInside)
        
        artistLabel.textColor = .lightGray
        artistLabel.font = .systemFont(ofSize: fitX(12))
        
        playingImgView.image = UIImage.iCurrentPlaySong
    }
    
    @objc func deleteAction(sender: UIButton)
    {
        if let deleteCallback = deleteCallback, let so = song {
            deleteCallback(so)
        }
    }
    
}
