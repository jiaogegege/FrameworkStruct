//
//  CopyPasteViewController.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/4/7.
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
    
    override func createUI() {
        super.createUI()
        stMgr.subscribe("text") {[unowned self] (newStr, oldStr) in
            self.priceLabel.text = "\(oldStr ?? "") -> \(newStr ?? "")"
        }
        stMgr.subscribe("text", delegate: self)
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
        g_after(1) {
            self.stMgr.set("1", key: "text")
        }
        g_after(2) {
            self.stMgr.set("2", key: "text")
        }
        g_after(3) {
            self.stMgr.set("3", key: "text")
        }
    }
    
}


extension CopyPasteViewController: DelegateProtocol, StatusManagerDelegate
{
    func statusManagerDidUpdateStatus(_ key: Any, newValue: Any?, oldValue: Any?) {
        print("\(String(describing: newValue))-\(String(describing: oldValue))")
    }
    
}
