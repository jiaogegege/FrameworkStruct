//
//  MusicSongListCell.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/10/19.
//

/**
 歌曲列表
 */
import UIKit

class MusicSongListCell: UITableViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var currentPlayImgView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var songlistBtn: UIButton!
    @IBOutlet weak var downloadStateImgView: UIImageView!
    
    var number: Int?        //排序序号，从1开始
    var songData: MPSongModel?
    var isCurrent: Bool = false
    var favoriteCallback: ((MPSongModel) -> Void)?  //点击收藏按钮
    var addSonglistCallback: ((MPSongModel) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        favoriteBtn.setImage(.iUnfavorite, for: .normal)
        favoriteBtn.setImage(.ifavorite, for: .selected)
        songlistBtn.setImage(.iSonglist, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func favoriteAction(_ sender: UIButton) {
        if let cb = favoriteCallback, let song = songData {
            cb(song)
        }
    }
    
    //添加到歌单
    @IBAction func songlistAction(_ sender: UIButton) {
        if let addSonglistCallback = addSonglistCallback, let song = songData {
            addSonglistCallback(song)
        }
    }
    
}


extension MusicSongListCell: ExternalInterface
{
    override func updateView() {
        if let num = number {
            numberLabel.text = "\(num)"
        }
        if let song = songData, let asset = song.asset {
            songNameLabel.text = song.name
            artistNameLabel.text = (asset[.artist] as? String ?? "") + " - " + (asset[.albumName] as? String ?? "")
            self.downloadStateImgView.isHidden = !song.isDownloaded
            favoriteBtn.isSelected = song.isFavorite
        }
        self.currentPlayImgView.isHidden = !isCurrent
        self.songNameLabel.textColor = isCurrent ? .cAccent : .cBlack_3
    }
    
}
