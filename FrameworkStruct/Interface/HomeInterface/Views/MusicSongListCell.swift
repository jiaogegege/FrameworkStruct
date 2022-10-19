//
//  MusicSongListCell.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/10/19.
//

import UIKit

class MusicSongListCell: UITableViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var currentPlayImgView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var songlistBtn: UIButton!
    
    var number: Int?        //排序序号，从1开始
    var songData: MPSongModel?
    

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
        
    }
    @IBAction func songlistAction(_ sender: UIButton) {
        
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
        }
    }
    
}
