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
    
    fileprivate var mpr = MPManager.shared
    
    fileprivate var libraryArray: [MPSongModel] = []
    fileprivate var favoriteArray: [MPSongModel] = []
    fileprivate var songLists: [MPSonglistModel] = []
    
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
            self.currentBtn?.isSelected = false
            sender.isSelected = true
            self.currentBtn = sender
        }
    }
    
    @IBAction func favoriteAction(_ sender: UIButton) {
        if sender != self.currentBtn
        {
            self.currentBtn?.isSelected = false
            sender.isSelected = true
            self.currentBtn = sender
        }
    }
    
    @IBAction func songListAction(_ sender: UIButton) {
        if sender != self.currentBtn
        {
            self.currentBtn?.isSelected = false
            sender.isSelected = true
            self.currentBtn = sender
        }
    }
    
}


extension MusicViewController: DelegateProtocol, UITableViewDelegate, UITableViewDataSource, MPManagerDelegate
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseId, for: indexPath)
        var title: String = ""
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
        cell.textLabel?.text = title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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


extension MusicViewController: InternalType
{
    //列表类型
    enum ListType {
        case library                //音乐库
        case favorite               //我喜欢
        case songLists              //歌单列表
        
    }
    
}
