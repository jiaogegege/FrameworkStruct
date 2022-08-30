//
//  CopyPasteViewController.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/4/7.
//

/**
 剪贴板复制粘贴
 */
import UIKit

class CopyPasteViewController: BasicViewController {
    //UI组件
    @IBOutlet weak var sourceLabel: FSLabel!
    @IBOutlet weak var targetLabel: FSLabel!
    @IBOutlet weak var sourceImgView: FSImageView!
    @IBOutlet weak var targetImgView: FSImageView!
    @IBOutlet weak var priceLabel: UILabel!
    
    override class func getViewController() -> Self {
        getVC(from: gMainSB)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func configUI() {
        super.configUI()
        sourceLabel.supportMenu = true
        targetLabel.supportMenu = true
        sourceImgView.supportMenu = true
        targetImgView.supportMenu = true
        targetImgView.image = GraphicsManager.shared.drawGroupImages([UIImage.iBackDark!, UIImage.iGuideHand!, UIImage.iHomeNormal!, UIImage.iBackClose!], direction: .vertical, align: .left)
    }
    
    override func updateUI() {
        priceLabel.attributedText = g_price(10234)
    }
    
}
