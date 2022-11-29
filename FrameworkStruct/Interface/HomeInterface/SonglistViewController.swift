//
//  SonglistViewController.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/11/4.
//

/**
 歌单界面，包括歌曲列表
 */
import UIKit

class SonglistViewController: BasicViewController {
    //歌单对象
    var songlist: MPSonglistModel?
    //音乐管理器
    fileprivate unowned var mpr = MPManager.shared
    //当前播放歌曲
    fileprivate var currentSong: MPAudioProtocol?
    
    //MARK: 属性
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tagsView: UIView!
    @IBOutlet weak var playAllBtn: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    fileprivate lazy var tagLabels: [UILabel] = []
    @IBOutlet weak var descField: UITextField!
    @IBOutlet weak var headViewTop: NSLayoutConstraint!
    
    
    //MARK: 方法
    override class func getViewController() -> Self {
        getVC(from: gMainSB)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func customConfig() {
        navBackgroundColor = .darkGray
        backStyle = .lightAlways
        navTitleColor = .white
        statusBarStyle = .light
    }
    
    override func initData() {
        mpr.addDelegate(self)
        currentSong = mpr.currentSong
    }
    
    //播放全部
    @IBAction func playAllAction(_ sender: UIButton) {
        if let songlist = songlist, let song = songlist.songs.first {
            mpr.playSong(song, in: songlist.getPlaylist()) {[weak self] succeed in
                if succeed
                {
                    self?.push(MusicPlayViewController.getViewController())
                }
            }
        }
    }
    
    override func configUI() {
        super.configUI()
        self.descField.attributedPlaceholder = NSAttributedString(string: descField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        tableView.register(UINib(nibName: MusicSongListCell.className, bundle: nil), forCellReuseIdentifier: MusicSongListCell.reuseId)
        tableView.separatorStyle = .none
    }
    
    override func updateUI() {
        if let songlist = songlist {
            //先设置大图
            if let imgPath = songlist.images?.first?.path {
                imgView.image = UIImage(named: (imgPath as NSString).lastPathComponent)
            }
            //如果有歌曲，那么尝试获取第一个歌曲的专辑图
            if let img = songlist.songs.first?.asset?[.artwork] as? UIImage
            {
                imgView.image = img
            }
            nameLabel.text = songlist.name
            if let desc = songlist.intro
            {
                descField.text = desc
            }
            //标签列表
            if let tagIds = songlist.tagIds
            {
                let tags = mpr.getTags(tagIds)
                if tags.count > 0
                {
                    for tag in tags {
                        //创建标签
                        var totalLength: CGFloat = 0.0
                        let tagHeight: CGFloat = 16
                        let label = UILabel(frame: CGRect(x: totalLength, y: 2, width: tag.name.calcWidth(font: .systemFont(ofSize: 14), size: CGSize(width: 10, height: tagHeight)), height: tagHeight))
                        label.text = tag.name
                        label.textColor = .lightGray
                        label.font = .systemFont(ofSize: 14)
                        tagsView.addSubview(label)
                        tagLabels.append(label)
                        totalLength += label.width + 5
                    }
                }
            }
            //数量
            countLabel.text = "(\(songlist.songs.count))"
            tableView.reloadData()
        }
    }
    
    //将一首歌添加到歌单
    fileprivate func addSongToSonglist(_ song: MPSongModel)
    {
        mpr.getAllSonglists { songlists in
            if let songlists = songlists {
                DialogManager.shared.wantShowAddToSonglist(song: song, songlists: songlists)
            }
        }
    }
    
}


extension SonglistViewController: DelegateProtocol, UITableViewDelegate, UITableViewDataSource, MPManagerDelegate, UITextFieldDelegate
{
    /**************************************** uitableview delegate Section Begin ***************************************/
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        songlist?.intro = textField.text
        textField.resignFirstResponder()
        //保存到缓存和iCloud
        mpr.setSonglist(songlist!) { succeed in
            
        }
        return true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offsetY = scrollView.contentOffset.y
        if offsetY < 0
        {
            offsetY = 0
        }
        if offsetY > 160
        {
            offsetY = 160
        }
        if offsetY >= 0 && offsetY <= 160
        {
            headViewTop.constant = -offsetY
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        songlist?.songs.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        64.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MusicSongListCell.reuseId, for: indexPath) as! MusicSongListCell
        cell.number = indexPath.row + 1
        let song = songlist!.songs[indexPath.row]
        cell.songData = song
        cell.isCurrent = (currentSong?.audioId == song.id) && mpr.currentPlaylist?.playlistId == songlist?.id
        cell.favoriteCallback = {[weak self] song in
            self?.mpr.setFavoriteSong(!song.isFavorite, song: song) { succeed in
                //保存成功则刷新列表
                if succeed
                {
                    self?.tableView.reloadData()
                }
            }
        }
        cell.addSonglistCallback = {[weak self] song in
            self?.addSongToSonglist(song)
        }
        cell.updateView()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //生成播放列表并播放歌曲
        if mpr.currentSong?.audioId != songlist?.songs[indexPath.row].id || mpr.currentPlaylist?.playlistId != songlist?.id //歌曲id不一样，或者播放列表名字不一样
        {
            mpr.playSong(songlist!.songs[indexPath.row], in: songlist!.getPlaylist()) {[weak self] succeed in
                if succeed
                {
                    self?.push(MusicPlayViewController.getViewController())
                }
            }
        }
        else
        {
            push(MusicPlayViewController.getViewController())
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete  //删除操作
        {
            let song = songlist!.songs[indexPath.row]
            AlertManager.shared.wantPresentAlert(title: String.sureDelete, message: song.name) {
                
            } rightBlock: {[weak self] text in
                self?.mpr.deleteSongsInSonglist([song], songlistId: (self?.songlist?.id)!, success: { succeed in
                    self?.updateUI()
                })
            }
        }
    }
    
    /**************************************** uitableview delegate Section End ***************************************/
    
    /**************************************** MPManager delegate Section Begin ***************************************/
    //音乐库初始化完成
    func mpManagerDidInitCompleted() {
        
    }
    
    //音乐库更新
    func mpManagerDidUpdated() {
        //如果有歌曲，那么尝试获取第一个歌曲的专辑图
        if let img = songlist?.songs.first?.asset?[.artwork] as? UIImage
        {
            imgView.image = img
        }
    }
    
    func mpManagerWaitToPlay(_ song: MPAudioProtocol) {
        
    }
    
    func mpManagerStartPlay(_ song: MPAudioProtocol) {
        currentSong = song
        tableView.reloadData()
    }
    
    func mpManagerPausePlay(_ song: MPAudioProtocol) {
        
    }
    
    func mpManagerResumePlay(_ song: MPAudioProtocol) {
        
    }
    
    func mpManagerFailedPlay(_ song: MPAudioProtocol) {
        
    }
    
    func mpManagerProgressChange(_ progress: TimeInterval) {
        
    }
    
    func mpManagerBufferProgressChange(_ progress: TimeInterval) {
        
    }
    
    //我喜欢更新
    func mpManagerDidUpdateFavoriteSongs(_ favoriteSongs: MPFavoriteModel) {
        tableView.reloadData()
    }
    
    func mpManagerDidUpdateCurrentPlaylist(_ currentPlaylist: MPPlaylistModel) {
        
    }
    
    func mpManagerDidUpdateHistorySongs(_ history: MPHistoryAudioModel) {
        
    }
    
    //歌单更新
    func mpManagerDidUpdateSonglists(_ songlists: [MPSonglistModel]) {
        for songlist in songlists {
            if songlist.id == self.songlist?.id
            {
                self.songlist = songlist
                self.updateUI()
                break
            }
        }
    }
    
    /**************************************** MPmanager delegate Section End ***************************************/
    
}
