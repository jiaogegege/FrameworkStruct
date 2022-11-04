//
//  SonglistViewController.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/11/4.
//

/**
 歌单界面，包括歌曲列表
 */
import UIKit

class SonglistViewController: BasicViewController {
    var songlist: MPSonglistModel?
    
    //MARK: 属性
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tagsView: UIView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var playAllBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: 方法
    override class func getViewController() -> Self {
        getVC(from: gMainSB)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //播放全部
    @IBAction func playAllAction(_ sender: UIButton) {
        
    }
    
}
