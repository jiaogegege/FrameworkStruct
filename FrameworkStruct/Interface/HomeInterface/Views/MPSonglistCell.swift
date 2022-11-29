//
//  MPSonglistCell.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/11/4.
//

/**
 歌单列表cell
 */
import UIKit

class MPSonglistCell: UITableViewCell {
    
    var songlist: MPSonglistModel? {
        didSet {
            updateView()
        }
    }
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var songlistNameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func updateView() {
        if let songlist = songlist {
            if let path = songlist.images?.first?.path {
                imgView.image = UIImage(named: (path as NSString).lastPathComponent)
            }
            //如果有歌曲，那么尝试获取第一个歌曲的专辑图
            if let img = songlist.songs.first?.asset?[.artwork] as? UIImage
            {
                imgView.image = img
            }
            songlistNameLabel.text = songlist.name
            countLabel.text = "\(songlist.songs.count)首"
        }
    }
    
}
