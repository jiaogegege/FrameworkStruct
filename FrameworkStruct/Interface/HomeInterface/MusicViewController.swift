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
    
    fileprivate var mpr = MPManager.shared
    
    fileprivate var libraryArray: [MPSongModel] = []
    fileprivate var favoriteArray: [MPSongModel] = []
    fileprivate var songLists: [MPSonglistModel] = []
    
    fileprivate var searchArray: [MPSongModel] = []
    fileprivate var isSearching: Bool = false
    
    fileprivate var type: ListType = .library
    
    fileprivate var currentBtn: UIButton?
    
    
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ApplicationManager.shared.screenIdle = false
    }
    
    override func createUI() {
        super.createUI()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseId)
        self.currentBtn = self.libraryBtn
    }
    
    override func initData() {
        super.initData()
        mpr.addDelegate(self)
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
    
    //搜索方法
    fileprivate func search(_ text: String)
    {
        let arr = (type == .library ? libraryArray : favoriteArray)
        if g_validString(text)
        {
            //过滤搜索文本
            self.searchArray = arr.filter({ song in
                song.name.contains(text)
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
    
    func mpManagerSongChange(_ song: MPAudioProtocol) {
        
    }
    
    func mpManagerProgressChange(_ progress: TimeInterval) {
        
    }
    
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
        searchBar.resignFirstResponder()
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseId, for: indexPath)
        var title: String = ""
         if isSearching
        {
            title = searchArray[indexPath.row].name
        }
        else
        {
            if type == .library
            {
                title = libraryArray[indexPath.row].name
            }
            else if type == .favorite
            {
                title = favoriteArray[indexPath.row].name
            }
            else if type == .songLists
            {
                title = songLists[indexPath.row].name
            }
        }
        cell.textLabel?.text = title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching
        {
            mpr.playSong(searchArray[indexPath.row], in: .iCloud) { success in
                g_toast(text: (success ? "播放成功" : "播放失败"))
            }
        }
        else
        {
            if type == .library
            {
                mpr.playSong(libraryArray[indexPath.row], in: .iCloud) { success in
                    g_toast(text: (success ? "播放成功" : "播放失败"))
                }
            }
            else if type == .favorite
            {
                
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
