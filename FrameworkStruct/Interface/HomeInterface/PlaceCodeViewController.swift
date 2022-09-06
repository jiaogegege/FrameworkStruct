//
//  PlaceCodeViewController.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/9/6.
//

import UIKit

class PlaceCodeViewController: BasicViewController {
    //UI组件
    @IBOutlet weak var placeField: UITextField! //具体场所
    @IBOutlet weak var areaField: UITextField!  //区域
    @IBOutlet weak var timeLabel: UILabel!  //当前时间
    @IBOutlet weak var sampTimeLabel: UILabel!  //采样时间
    @IBOutlet weak var detectionTimeLabel: UILabel! //检测时间
    
    
    override class func getViewController() -> Self {
        getVC(from: "Main")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func customConfig() {
        self.backStyle = .darkThin
    }

    override func updateUI() {
        timeLabel.text = currentTimeString(format: .localYearMonthDay) + " " + currentTimeString(format: .dashHourMinSec)
        sampTimeLabel.text = getTimeString(date: Date(), sepType: .local, year: nil, month: .monthShort, hour: nil, min: nil, sec: nil)
        detectionTimeLabel.text = getTimeString(date: Date(), sepType: .local, year: nil, month: .monthShort, hour: nil, min: nil, sec: nil)
    }
    
}


extension PlaceCodeViewController: DelegateProtocol, UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
