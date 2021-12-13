//
//  SelectThemeCell.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/12/13.
//

import UIKit

//cellidkey
let SelectThemeCellKey = "SelectThemeCell"

class SelectThemeCell: UITableViewCell {
    //MARK: 属性
    @IBOutlet weak var nameLabel: UILabel!  //主题名称
    //主题对象
    var theme: CustomTheme? = nil {
        didSet {
            self.nameLabel.textColor = theme?.mainColor
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
