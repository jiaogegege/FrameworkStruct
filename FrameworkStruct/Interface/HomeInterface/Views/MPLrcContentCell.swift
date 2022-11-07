//
//  MPLrcContentCell.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/11/7.
//

/**
 显示歌词的cell，也用于显示title/artist/album
 */
import UIKit

class MPLrcContentCell: UITableViewCell {
    //MARK: 属性
    //这几个属性每次都要设置，没有的话就设置nil
    var title: String?
    var artist: String?
    var album: String?
    var lrcInfo: LineLyricInfo?
    var distanceToCenter: DistanceToCenter = .center(0)     //距离中心cell的距离
    
    //UI
    fileprivate var lrcLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createView()
        configView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createView() {
        lrcLabel = UILabel()
        contentView.addSubview(lrcLabel)
        lrcLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(fitX(30))
            make.right.equalTo(fitX(-30))
        }
    }
    
    override func configView() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        lrcLabel.backgroundColor = .clear
        lrcLabel.font = .systemFont(ofSize: Self.fontSize)
        lrcLabel.textColor = .white
        lrcLabel.textAlignment = .center
        lrcLabel.isHidden = true
    }

}


extension MPLrcContentCell: InternalType
{
    //原始字体大小
    static let fontSize: CGFloat = fitX(18.0)
    
    ///距离中心的位置，越远数值越大，0表示就在中心位置
    enum DistanceToCenter {
        case center(Int)
        
        //获取透明度和字体大小
        func getAlphaAndFontSize() -> (CGFloat, CGFloat)
        {
            switch self {
            case .center(let int):
                if int == 0
                {
                    return (1.0, MPLrcContentCell.fontSize)
                }
                else
                {
                    return (1.0 - CGFloat(int) * 0.2, MPLrcContentCell.fontSize - fitX(CGFloat(int)))
                }
            }
        }
    }
    
}


extension MPLrcContentCell: ExternalInterface
{
    override func updateView() {
        if let lrcInfo = lrcInfo {
            lrcLabel.numberOfLines = 2
            lrcLabel.text = lrcInfo.lyric
        }
        else
        {
            var str = ""
            if let ti = title {
                if str.isValid()
                {
                    str.append(String.sNewline)
                    str.append(String.sNewline)
                }
                str.append(ti)
            }
            if let ar = artist {
                if str.isValid()
                {
                    str.append(String.sNewline)
                    str.append(String.sNewline)
                }
                str.append(ar)
            }
            if let al = album {
                if str.isValid()
                {
                    str.append(String.sNewline)
                    str.append(String.sNewline)
                }
                str.append(al)
            }
            lrcLabel.numberOfLines = 0
            lrcLabel.text = str
        }
        //调整样式，非中间显示的cell字体大小统一调小
        let style = distanceToCenter.getAlphaAndFontSize()
        lrcLabel.isHidden = false
        self.lrcLabel.textColor = .white.withAlphaComponent(style.0)
//            self.lrcLabel.font = .systemFont(ofSize: style.1)
        AnimationManager.shared.viewScale(x: (style.1 == Self.fontSize ? style.1 : fitX(16)) / Self.fontSize, y: (style.1 == Self.fontSize ? style.1 : fitX(16)) / Self.fontSize, duration: 0.3, delay: 0, on: self.lrcLabel)
    }
    
}
