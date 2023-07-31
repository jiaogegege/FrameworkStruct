//
//  MusicViewController.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/10/10.
//

/**
 音乐库界面
 */
import UIKit

class MusicViewController: BasicViewController
{
    //MARK: 属性
    fileprivate var newSonglistBtn: UIBarButtonItem!
    @IBOutlet weak var libraryBtn: UIButton!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var songListsBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var jumpCurrentBtn: UIButton!
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
    @IBOutlet weak var jumpBtnBottom: NSLayoutConstraint!
    @IBOutlet weak var searchBarHeight: NSLayoutConstraint!
    
    fileprivate unowned var mpr = MPManager.shared
    
    fileprivate var libraryArray: [MPSongModel] = []
    fileprivate var favoriteSongs: MPFavoriteModel?
    fileprivate var favoriteArray: [MPSongModel] = []
    fileprivate var songLists: [MPSonglistModel] = []
    
    fileprivate var searchArray: [MPSongModel] = []
    fileprivate var isSearching: Bool = false
    
    fileprivate var type: ListType = .library
    
    fileprivate var currentBtn: UIButton?
    
    fileprivate var currentSong: MPAudioProtocol?
    
    
    //MARK: 方法
    override class func getViewController() -> Self {
        getVC(from: gMainSB)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mpr.addDelegate(self)
        currentSong = mpr.currentSong
    }
    
    override func configHook() {
        hookViewWillAppear {[unowned self] in
            ApplicationManager.shared.screenIdle = true
            if mpr.isPlaying
            {
                jumpCurrentAction(jumpCurrentBtn)
            }
            mpr.showMiniPlayer()
            tableViewBottom.constant = 48
            jumpBtnBottom.constant = 26 + 48
        }
        
        hookViewWillDisappear {[unowned self] in
            ApplicationManager.shared.screenIdle = false
            mpr.hideMiniPlayer()
        }
    }
    
    override func createUI() {
        super.createUI()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseId)
        tableView.register(UINib(nibName: MusicSongListCell.className, bundle: nil), forCellReuseIdentifier: MusicSongListCell.reuseId)
        tableView.register(UINib(nibName: MPSonglistCell.className, bundle: nil), forCellReuseIdentifier: MPSonglistCell.reuseId)
        self.currentBtn = self.libraryBtn
        
        newSonglistBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newSonglistAction(sender:)))
    }
    
    override func configUI() {
        tableView.tableFooterView = UIView()
        
        jumpCurrentBtn.setImage(.iJumpCurrentSong, for: .normal)
    }
    
    override func initData() {
        if !mpr.isIniting     //不是正在初始化的时候才更新
        {
            mpr.getAlliCloudSongs(completion: {[weak self] songs in
                self?.libraryArray = songs
                if self?.type == .library
                {
                    self?.tableView.reloadData()
                }
            })
            mpr.getFavroiteSongs { [weak self] favorite in
                self?.favoriteSongs = favorite
                if let songs = favorite?.audios as? [MPSongModel] {
                    self?.favoriteArray = songs
                    if self?.type == .favorite
                    {
                        self?.tableView.reloadData()
                    }
                }
            }
            mpr.getAllSonglists { [weak self] songlists in
                if let songlists = songlists {
                    self?.songLists = songlists
                    if self?.type == .songLists
                    {
                        self?.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    //新增歌单
    @objc func newSonglistAction(sender: UIBarButtonItem?)
    {
        AlertManager.shared.wantPresentAlert(title: .newSonglist, needInput: true, inputPlaceHolder: .enterSonglistNameHint, leftTitle: .cancel, leftBlock: {
            
        }, rightTitle: .confirm) { name in
            guard let name = name else {
                g_alert(message: .pleaseEnterName)
                return
            }
            self.createNewSonglist(name)
        }
    }
    
    @IBAction func libraryAction(_ sender: UIButton) {
        if sender != self.currentBtn
        {
            type = .library
            self.currentBtn?.isSelected = false
            sender.isSelected = true
            self.currentBtn = sender
            navigationItem.rightBarButtonItems = []
            searchBar.isHidden = false
            searchBarHeight.constant = 44
            searchArray = []
            isSearching = false
            searchBar.text = nil
            jumpCurrentBtn.isHidden = false
            tableView.reloadData()
        }
    }
    
    @IBAction func favoriteAction(_ sender: UIButton) {
        if sender != self.currentBtn
        {
            type = .favorite
            self.currentBtn?.isSelected = false
            sender.isSelected = true
            self.currentBtn = sender
            navigationItem.rightBarButtonItems = []
            searchBar.isHidden = false
            searchBarHeight.constant = 44
            searchArray = []
            isSearching = false
            searchBar.text = nil
            jumpCurrentBtn.isHidden = false
            tableView.reloadData()
        }
    }
    
    @IBAction func songListAction(_ sender: UIButton) {
        if sender != self.currentBtn
        {
            type = .songLists
            self.currentBtn?.isSelected = false
            sender.isSelected = true
            self.currentBtn = sender
            navigationItem.rightBarButtonItems = [newSonglistBtn]
            searchBar.isHidden = true
            searchBarHeight.constant = 0
            searchArray = []
            isSearching = false
            searchBar.text = nil
            jumpCurrentBtn.isHidden = true
            tableView.reloadData()
        }
    }
    
    @IBAction func jumpCurrentAction(_ sender: UIButton) {
        if let currentSong = currentSong {
            var curIndex = -1
            if isSearching
            {
                for (index ,song) in searchArray.enumerated()
                {
                    if song.id == currentSong.audioId
                    {
                        curIndex = index
                        break
                    }
                }
            }
            else
            {
                if type == .library
                {
                    for (index, song) in libraryArray.enumerated()
                    {
                        if song.id == currentSong.audioId
                        {
                            curIndex = index
                            break
                        }
                    }
                }
                else if type == .favorite
                {
                    for (index, song) in favoriteArray.enumerated()
                    {
                        if song.id == currentSong.audioId
                        {
                            curIndex = index
                            break
                        }
                    }
                }
            }
            if !tableView.isVisible(row: curIndex, secton: 0)
            {
                //跳转
                if curIndex >= 0
                {
                    tableView.scrollTo(row: curIndex, section: 0)
                }
            }
        }
    }
    
    //搜索方法
    fileprivate func search(_ text: String)
    {
        let arr = (type == .library ? libraryArray : favoriteArray)
        if g_validString(text)
        {
            //过滤搜索文本
            self.searchArray = arr.filter({ song in
                song.fullDescription.lowercased().contains(text.lowercased())
            })
        }
        else
        {
            self.searchArray = arr
        }
        tableView.reloadData()
    }
    
    //创建一个新歌单
    fileprivate func createNewSonglist(_ name: String)
    {
        mpr.createNewSonglist(name) { songlist in
            g_toast(text: songlist != nil ? String.createSuccess : String.createFailure)
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


extension MusicViewController: DelegateProtocol, UITableViewDelegate, UITableViewDataSource, MPManagerDelegate, UISearchBarDelegate
{
    /**************************************** MPManager代理 Section Begin ***************************************/
    //音乐库初始化完成
    func mpManagerDidInitCompleted() {
        initData()
    }
    
    //音乐库更新
    func mpManagerDidUpdated() {
        initData()
    }
    
    func mpManagerWaitToPlay(_ song: MPAudioProtocol) {
//        g_loading(interaction: true)
    }
    
    func mpManagerStartPlay(_ song: MPAudioProtocol) {
//        g_endLoading()
        currentSong = song
        tableView.reloadData()
//        jumpCurrentAction(jumpCurrentBtn)
    }
    
    func mpManagerPausePlay(_ song: MPAudioProtocol) {
        
    }
    
    func mpManagerResumePlay(_ song: MPAudioProtocol) {
        
    }
    
    func mpManagerFailedPlay(_ song: MPAudioProtocol) {
        g_endLoading()
        g_toast(text: "歌曲：\(song.audioName) " + String.failToPlay)
    }
    
    func mpManagerProgressChange(_ progress: TimeInterval) {
        
    }
    
    func mpManagerBufferProgressChange(_ progress: TimeInterval) {
        
    }
    
    //我喜欢更新
    func mpManagerDidUpdateFavoriteSongs(_ favoriteSongs: MPFavoriteModel) {
        self.favoriteSongs = favoriteSongs
        favoriteArray = favoriteSongs.audios as? [MPSongModel] ?? []
        if type == .favorite || type == .library
        {
            tableView.reloadData()
        }
    }
    
    func mpManagerDidUpdateCurrentPlaylist(_ currentPlaylist: MPPlaylistModel) {
        
    }
    
    func mpManagerDidUpdateHistorySongs(_ history: MPHistoryAudioModel) {
        
    }
    
    //歌单更新
    func mpManagerDidUpdateSonglists(_ songlists: [MPSonglistModel]) {
        self.songLists = songlists
        if type == .songLists
        {
            tableView.reloadData()
        }
    }
    
    /**************************************** MPManager代理 Section End ***************************************/
    
    /**************************************** 搜索代理 Section Begin ***************************************/
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        isSearching = g_validString(searchBar.text)
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        search(searchBar.text ?? "")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        isSearching = false
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(searchText)
    }
    
    /**************************************** 搜索代理 Section End ***************************************/
    
    /**************************************** tableview代理 Section Begin ***************************************/
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        searchBar.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching
        {
            return searchArray.count
        }
        else
        {
            if type == .library
            {
                return libraryArray.count
            }
            else if type == .favorite
            {
                return favoriteArray.count
            }
            else if type == .songLists
            {
                return songLists.count
            }
            
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isSearching
        {
            return 64
        }
        else
        {
            if type == .library || type == .favorite
            {
                return 64
            }
            else if type == .songLists
            {
                return 70
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         if isSearching
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: MusicSongListCell.reuseId, for: indexPath) as! MusicSongListCell
            cell.number = indexPath.row + 1
            let song = searchArray[indexPath.row]
            cell.songData = song
            cell.isCurrent = (currentSong?.audioId == song.id)
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
        else
        {
            if type == .library
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: MusicSongListCell.reuseId, for: indexPath) as! MusicSongListCell
                cell.number = indexPath.row + 1
                let song = libraryArray[indexPath.row]
                cell.songData = song
                cell.isCurrent = (currentSong?.audioId == song.id)
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
            else if type == .favorite
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: MusicSongListCell.reuseId, for: indexPath) as! MusicSongListCell
                cell.number = indexPath.row + 1
                let song = favoriteArray[indexPath.row]
                cell.songData = song
                cell.isCurrent = (currentSong?.audioId == song.id)
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
            else if type == .songLists
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: MPSonglistCell.reuseId, for: indexPath) as! MPSonglistCell
                cell.songlist = songLists[indexPath.row]
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if isSearching
        {
            if mpr.currentSong?.audioId != searchArray[indexPath.row].id
            {
                mpr.playSong(searchArray[indexPath.row], in: .iCloud) {[weak self] success in
    //                g_toast(text: (success ? "播放成功" : "播放失败"))
                    if success
                    {
                        if ControllerManager.shared.isTopVC(self)
                        {
                            self?.push(MusicPlayViewController.getViewController())
                        }
                    }
                }
            }
            else
            {
                if ControllerManager.shared.isTopVC(self)
                {
                    push(MusicPlayViewController.getViewController())
                }
            }
        }
        else
        {
            if type == .library     //音乐库
            {
                if mpr.currentSong?.audioId != libraryArray[indexPath.row].id
                {
                    mpr.playSong(libraryArray[indexPath.row], in: .iCloud) {[weak self] success in
    //                    g_toast(text: (success ? "播放成功" : "播放失败"))
                        if success
                        {
                            if ControllerManager.shared.isTopVC(self)
                            {
                                self?.push(MusicPlayViewController.getViewController())
                            }
                        }
                    }
                }
                else
                {
                    if ControllerManager.shared.isTopVC(self)
                    {
                        push(MusicPlayViewController.getViewController())
                    }
                }
            }
            else if type == .favorite   //我喜欢
            {
                if mpr.currentSong?.audioId != favoriteArray[indexPath.row].id
                {
                    mpr.playSong(favoriteArray[indexPath.row], in: favoriteSongs!) {[weak self] success in
    //                    g_toast(text: (success ? "播放成功" : "播放失败"))
                        if success
                        {
                            if ControllerManager.shared.isTopVC(self)
                            {
                                self?.push(MusicPlayViewController.getViewController())
                            }
                        }
                    }
                }
                else
                {
                    if ControllerManager.shared.isTopVC(self)
                    {
                        push(MusicPlayViewController.getViewController())
                    }
                }
            }
            else if type == .songLists      //歌单
            {
                let vc = SonglistViewController.getViewController()
                vc.songlist = songLists[indexPath.row]
                push(vc)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        //非搜索状态的 我喜欢 和 歌单 可以删除
        if (type == .favorite && !isSearching) || type == .songLists
        {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete  //删除操作
        {
            if !isSearching
            {
                if type == .library
                {
                    
                }
                else if type == .favorite
                {
                    let song = favoriteArray[indexPath.row]
                    AlertManager.shared.wantPresentAlert(title: String.sureDelete, message: song.name) {
                        
                    } rightBlock: {[weak self] text in
                        self?.mpr.setFavoriteSong(false, song: song) { succeed in
                            //保存成功则刷新列表
                            if succeed
                            {
                                self?.tableView.reloadData()
                            }
                        }
                    }
                }
                else if type == .songLists
                {
                    let songlist = songLists[indexPath.row]
                    AlertManager.shared.wantPresentAlert(title: String.sureDelete, message: songlist.name) {
                        
                    } rightBlock: {[weak self] _ in
                        self?.mpr.deleteSonglist(songlist.id, success: { succeed in
                            if succeed
                            {
                                self?.tableView.reloadData()
                            }
                        })
                    }

                }
            }
        }
    }
    
    /**************************************** tableview代理 Section End ***************************************/
    
}


extension MusicViewController: InternalType
{
    //列表类型
    enum ListType {
        case library                //音乐库
        case favorite               //我喜欢
        case songLists              //歌单列表
        
    }
    
}
