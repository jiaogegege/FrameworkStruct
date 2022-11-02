//
//  MPPlaylistView.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/11/2.
//

/**
 播放列表视图，包含播放列表标题、详细描述、歌曲列表
 */
import UIKit

class MPPlaylistView: UIView {
    //MARK: 属性
    var playlist: MPPlaylistProtocol? {          //播放列表数据
        didSet {
            updateView()
        }
    }
    
    //点击歌曲的回调，回传播放列表和点击的歌曲
    var clickCallback: ((MPAudioProtocol, MPPlaylistProtocol) -> Void)?
    //删除某一首歌曲的回调
    var deleteSongCallback: ((MPAudioProtocol, MPPlaylistProtocol) -> Void)?
    
    //UI组件
    fileprivate var bgView: UIView!             //背景视图
    fileprivate var headView: UIView!           //顶部容器
    fileprivate var titleLabel: UILabel!        //播放列表标题
    fileprivate var countLabel: UILabel!    //歌曲总数
    fileprivate var detailLabel: UILabel!       //详细描述
    fileprivate var tableView: UITableView!     //歌曲列表
    
    //MARK: 方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        createView()
        configView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createView() {
        bgView = UIView()
        addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        headView = UIView()
        bgView.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(fitX(80))
        }
        
        titleLabel = UILabel()
        headView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(fitX(16))
            make.top.equalTo(fitX(20))
            make.height.equalTo(fitX(22))
        }
        
        countLabel = UILabel()
        headView.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(fitX(4))
            make.bottom.equalTo(titleLabel).offset(-2)
            make.height.equalTo(fitX(12))
        }
        
        detailLabel = UILabel()
        headView.addSubview(detailLabel)
        detailLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.right.equalTo(fitX(-12))
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.height.equalTo(fitX(15))
        }
        
        tableView = UITableView()
        bgView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headView.snp.bottom)
        }
    }
    
    override func configView() {
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 16
        bgView.clipsToBounds = true
        
        titleLabel.textColor = .cBlack_3
        titleLabel.font = .boldSystemFont(ofSize: fitX(22))
        
        countLabel.textColor = .lightGray
        countLabel.font = .systemFont(ofSize: fitX(12))
        
        detailLabel.textColor = .lightGray
        detailLabel.font = .systemFont(ofSize: fitX(15))
        
        tableView.register(MPPlaylistSongCell.self, forCellReuseIdentifier: MPPlaylistSongCell.reuseId)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}


extension MPPlaylistView: DelegateProtocol, UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        playlist?.playlistAudios.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        fitX(50)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MPPlaylistSongCell.reuseId, for: indexPath) as! MPPlaylistSongCell
        cell.song = playlist?.playlistAudios[indexPath.row]
        cell.currentSong = MPManager.shared.currentSong
        cell.number = indexPath.row + 1
        cell.deleteCallback = {[weak self] audio in
            if let cb = self?.deleteSongCallback {
                cb(audio, (self?.playlist)!)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cb = clickCallback {
            cb((playlist?.playlistAudios[indexPath.row])!, playlist!)
        }
    }
    
}


extension MPPlaylistView: ExternalInterface
{
    override func updateView() {
        if let pl = playlist {
            self.titleLabel.text = pl.playlistName
            self.countLabel.text = "(\(pl.playlistAudios.count))"
            self.detailLabel.text = pl.playlistIntro ?? pl.playlistName
            self.tableView.reloadData()
        }
    }
    
    func setTitle(_ title: String)
    {
        self.titleLabel.text = title
    }
    
    //跳转到正在播放
    func jumpCurrentPlay(_ audio: MPAudioProtocol)
    {
        g_after(0.01) {
            if let audios = self.playlist?.playlistAudios {
                for (index, item) in audios.enumerated()
                {
                    if audio.audioId == item.audioId
                    {
                        self.tableView.scrollTo(row: index, section: 0)
                    }
                }
            }
        }
    }
    
}
