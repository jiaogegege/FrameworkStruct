//
//  PlaceCodeViewController.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/9/6.
//


/**
 场所码
 */
import UIKit

class PlaceCodeViewController: BasicViewController {
    //MARK: 属性
    //是否今日采样，如果为true，则采样日期为今天，检测结果日期为昨天；如果为false，则采样日期和检测结果日期都为昨天
    var isTodaySamp: Bool = false
    
    //UI组件
    @IBOutlet weak var placeField: UITextField! //具体场所
    @IBOutlet weak var areaField: UITextField!  //区域
    @IBOutlet weak var timeLabel: UILabel!  //当前时间
    @IBOutlet weak var sampTimeLabel: UILabel!  //采样时间
    @IBOutlet weak var detectionTimeLabel: UILabel! //检测时间
    
    
    override class func getViewController() -> Self {
        getVC(from: gMainSB)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func customConfig() {
        self.backStyle = .darkThin
    }

    override func updateUI() {
        timeLabel.text = currentTimeString(format: .localYearMonthDay) + " " + currentTimeString(format: .hourMinSec)
        sampTimeLabel.text = getTimeString(date: nowAfter(isTodaySamp ? 0 : -tSecondsInDay), sepType: .local, year: nil, month: .monthShort, hour: nil, min: nil, sec: nil)
        detectionTimeLabel.text = getTimeString(date: nowAfter(-tSecondsInDay), sepType: .local, year: nil, month: .monthShort, hour: nil, min: nil, sec: nil)
    }
    
}


extension PlaceCodeViewController: DelegateProtocol, UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
