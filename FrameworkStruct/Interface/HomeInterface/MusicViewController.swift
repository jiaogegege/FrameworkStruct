//
//  MusicViewController.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/10/10.
//

/**
 音乐库界面
 */
import UIKit

class MusicViewController: BasicViewController
{
    //MARK: 属性
    @IBOutlet weak var libraryBtn: UIButton!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var songListsBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var jumpCurrentBtn: UIButton!
    
    fileprivate var mpr = MPManager.shared
    
    fileprivate var libraryArray: [MPSongModel] = []
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ApplicationManager.shared.screenIdle = true
        if mpr.isPlaying
        {
            jumpCurrentAction(jumpCurrentBtn)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ApplicationManager.shared.screenIdle = false
    }
    
    override func createUI() {
        super.createUI()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseId)
        tableView.register(UINib(nibName: MusicSongListCell.className, bundle: nil), forCellReuseIdentifier: MusicSongListCell.reuseId)
        self.currentBtn = self.libraryBtn
    }
    
    override func configUI() {
        self.jumpCurrentBtn.setImage(.iJumpCurrentSong, for: .normal)
    }
    
    override func initData() {
        super.initData()
        mpr.addDelegate(self)
        currentSong = mpr.currentSong
        mpr.getAlliCloudSongs(completion: {[weak self] songs in
            self?.libraryArray = songs
            self?.tableView.reloadData()
        })
    }
    
    @IBAction func libraryAction(_ sender: UIButton) {
        if sender != self.currentBtn
        {
            type = .library
            self.currentBtn?.isSelected = false
            sender.isSelected = true
            self.currentBtn = sender
            searchArray = []
            isSearching = false
            searchBar.text = nil
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
            searchArray = []
            isSearching = false
            searchBar.text = nil
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
            searchArray = []
            isSearching = false
            searchBar.text = nil
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
    
}


extension MusicViewController: DelegateProtocol, UITableViewDelegate, UITableViewDataSource, MPManagerDelegate, UISearchBarDelegate
{
    /**************************************** MPManager代理 Section Begin ***************************************/
    //音乐库初始化完成
    func mpManagerDidInitCompleted() {
        mpr.getAlliCloudSongs(completion: {[weak self] songs in
            self?.libraryArray = songs
            self?.tableView.reloadData()
        })
    }
    
    //音乐库更新
    func mpManagerDidUpdated() {
        mpr.getAlliCloudSongs(completion: {[weak self] songs in
            self?.libraryArray = songs
            self?.tableView.reloadData()
        })
    }
    
    func mpManagerWaitToPlay(_ song: MPAudioProtocol) {
//        g_loading(interaction: true)
    }
    
    func mpManagerStartPlay(_ song: MPAudioProtocol) {
//        g_endLoading()
        currentSong = song
        tableView.reloadData()
        jumpCurrentAction(jumpCurrentBtn)
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
                return 44
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
                cell.updateView()
                return cell
            }
            else if type == .songLists
            {
                return UITableViewCell()
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
                    self?.push(MusicPlayViewController.getViewController())
                }
            }
            else
            {
                push(MusicPlayViewController.getViewController())
            }
        }
        else
        {
            if type == .library
            {
                if mpr.currentSong?.audioId != libraryArray[indexPath.row].id
                {
                    mpr.playSong(libraryArray[indexPath.row], in: .iCloud) {[weak self] success in
    //                    g_toast(text: (success ? "播放成功" : "播放失败"))
                        self?.push(MusicPlayViewController.getViewController())
                    }
                }
                else
                {
                    push(MusicPlayViewController.getViewController())
                }
            }
            else if type == .favorite
            {
                if mpr.currentSong?.audioId != favoriteArray[indexPath.row].id
                {
                    mpr.playSong(favoriteArray[indexPath.row], in: .iCloud) {[weak self] success in
    //                    g_toast(text: (success ? "播放成功" : "播放失败"))
                        self?.push(MusicPlayViewController.getViewController())
                    }
                }
                else
                {
                    push(MusicPlayViewController.getViewController())
                }
            }
            else if type == .songLists
            {
                
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
