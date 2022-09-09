//
//  TravelCardViewController.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/9/9.
//


/**
 行程卡
 */
import UIKit

class TravelCardViewController: BasicViewController {
    //MARK: 属性
    var provinceCity: String?       //省市名
    
    var canAnimate: Bool = false        //是否可以做动画
    
    //UI组件
    @IBOutlet weak var navBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var signImgView: UIImageView!
    
    @IBOutlet weak var signImgViewHeight: NSLayoutConstraint!
    @IBOutlet weak var signImgViewWidth: NSLayoutConstraint!
    
    
    //MARK: 方法
    override class func getViewController() -> Self {
        getVC(from: gMainSB)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func customConfig() {
        self.hideNavBar = true
    }
    
    override func configUI() {
        super.configUI()
        navBtn.addTarget(self, action: #selector(backAction(sender:)), for: .touchUpInside)
    }
    
    override func updateUI() {
        super.updateUI()
        timeLabel.text = String(format: "更新于：%@", currentTimeString(format: .dotYearMonthDayHourMinSec))
        let attrStr: NSMutableAttributedString = NSMutableAttributedString()
        attrStr.append(StringEmbellisher.shared.attrStringWith("您于前7天内到达或途经：", font: .systemFont(ofSize: 16), color: .colorFromHex(0x94939D), lineSpace: 4))
        attrStr.append(StringEmbellisher.shared.attrStringWith(provinceCity ?? "江苏省苏州市", font: .boldSystemFont(ofSize: 16), color: .colorFromHex(0x46464b), lineSpace: 4))
        placeLabel.attributedText = attrStr
        startAnimation()
    }
    
    //开启一个缩放动画
    func startAnimation()
    {
        canAnimate = true
        g_after(0.01) {
            self.animationLoop()
        }
    }
    
    //具体的动画
    func animationLoop()
    {
        guard canAnimate == true else {
            return
        }
        
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveLinear) { [weak self] in
            self?.signImgViewWidth.constant = 160
            self?.signImgViewHeight.constant = 160
            self?.view.layoutIfNeeded()
        } completion: { finished in
            UIView.animate(withDuration: 0.7, delay: 0, options: .curveLinear) { [weak self] in
                self?.signImgViewWidth.constant = 120
                self?.signImgViewHeight.constant = 120
                self?.view.layoutIfNeeded()
            } completion: { [weak self] finished in
                self?.animationLoop()
            }
        }
    }
    
    deinit {
        canAnimate = false
    }
}


extension TravelCardViewController: DelegateProtocol, UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
