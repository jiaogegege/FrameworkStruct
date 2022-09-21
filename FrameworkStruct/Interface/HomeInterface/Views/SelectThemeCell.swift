//
//  SelectThemeCell.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/12/13.
//

import UIKit

class SelectThemeCell: UITableViewCell {
    //MARK: 属性
    @IBOutlet weak var nameLabel: UILabel!  //主题名称
    //主题对象
    var theme: ThemeProtocol? = nil
    
    
    //MARK: 方法
    //数据赋值之后，手动调用更新方法
    func update()
    {
        self.nameLabel.textColor = theme?.mainColor
        self.nameLabel.text = self.theme?.themeName
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
