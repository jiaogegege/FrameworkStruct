//
//  HealthCodeViewController.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/9/5.
//


/**
 健康码
 */
import UIKit

class HealthCodeViewController: BasicViewController {
    //MARK: 属性
    //是否今日采样，如果为true，则采样日期为今天，检测结果日期为昨天；如果为false，则采样日期和检测结果日期都为昨天
    var isTodaySamp: Bool = false
    
    //UI组件
    fileprivate var navBar: UIButton!       //导航栏
    
    fileprivate var bottomView: UIView!     //底部固定view
    fileprivate var sampView: UIView!       //核酸采样view
    fileprivate var sampDateLabel: UILabel!
    fileprivate var sampRetLabel: UILabel!
    fileprivate var sampArrowImgView: UIImageView!
    fileprivate var resultView: UIView!
    fileprivate var resultDateLabel: UILabel!
    fileprivate var resultRetLabel: UILabel!
    fileprivate var resultArrowImgView: UIImageView!
    fileprivate var travelView: UIView!
    fileprivate var travelLabel: UILabel!
    fileprivate var travelArrowImgView: UIImageView!
    fileprivate var desLabel: UILabel!
    
    fileprivate var scrollView: UIScrollView!
    fileprivate var headView: UIImageView!
    fileprivate var nameTextField: UITextField!     //姓名
    fileprivate var idCardField: UITextField!       //身份证
    fileprivate var scrollContentView: UIView!      //滚动横幅
    fileprivate var scrollContainerView: UIView!
    fileprivate var contentLabel: UILabel!          //滚动横幅文字
    fileprivate var codeView: UIView!
    fileprivate var codeTimeLabel: UILabel!
    fileprivate var codeImgView: UIImageView!   //健康码绿码
    
    fileprivate var nucleateImgView: UIImageView!   //核酸结果
    fileprivate var vaccineImgView: UIImageView!    //疫苗结果
    fileprivate var travelImgView: UIImageView! //大数据行程卡
    fileprivate var infoUpdateImgView: UIImageView!     //信息更新
    
    fileprivate var dataSourceLabel: UILabel!       //数据来源
    fileprivate var line: UIView!
    fileprivate var operationBtn: UIButton!     //操作说明
    fileprivate var hotLineLabel: UILabel!  //服务热线
    
    
    var canScrollContent: Bool = false       //是否可以更新UI数据，文字滚动和时间定时器
    var timer: Timer?       //时间定时器

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func customConfig() {
        self.hideNavBar = true
        self.backgroundStyle = .white
        self.canLeftSlideBack = false
    }
    
    override func createUI() {
        super.createUI()
        
        //导航条
        navBar = UIButton(type: .custom)
        self.view.addSubview(navBar)
        navBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(kStatusHeight)
            make.height.equalTo(navBar.snp.width).multipliedBy(44.0 / 375.0)
        }
        
        //底部view
        bottomView = UIView()
        self.view.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(110 + kSafeBottomHeight)
        }
        
        let sampViewWidth: CGFloat = (kScreenWidth - 6 * 6.0) / 3.0
        let sampViewHeight: CGFloat = 40.0
        
        sampView = UIView()
        bottomView.addSubview(sampView)
        sampView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(12)
            make.width.equalTo(sampViewWidth + 5)
            make.height.equalTo(sampViewHeight)
        }
        sampDateLabel = UILabel()
        sampView.addSubview(sampDateLabel)
        sampDateLabel.snp.makeConstraints { make in
            make.top.equalTo(6)
            make.left.right.equalToSuperview()
            make.height.equalTo(12)
        }
        sampRetLabel = UILabel()
        sampView.addSubview(sampRetLabel)
        sampRetLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-6)
            make.height.equalTo(12)
        }
        sampArrowImgView = UIImageView()
        sampView.addSubview(sampArrowImgView)
        sampArrowImgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-6)
            make.width.equalTo(6)
            make.height.equalTo(10)
        }
        
        resultView = UIView()
        bottomView.addSubview(resultView)
        resultView.snp.makeConstraints { make in
            make.left.equalTo(sampView.snp.right).offset(6)
            make.top.equalToSuperview().offset(12)
            make.width.equalTo(sampViewWidth + 5)
            make.height.equalTo(sampViewHeight)
        }
        resultDateLabel = UILabel()
        resultView.addSubview(resultDateLabel)
        resultDateLabel.snp.makeConstraints { make in
            make.top.equalTo(6)
            make.left.right.equalToSuperview()
            make.height.equalTo(12)
        }
        resultRetLabel = UILabel()
        resultView.addSubview(resultRetLabel)
        resultRetLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-6)
            make.height.equalTo(12)
        }
        resultArrowImgView = UIImageView()
        resultView.addSubview(resultArrowImgView)
        resultArrowImgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-6)
            make.width.equalTo(6)
            make.height.equalTo(10)
        }
        
        travelView = UIView()
        bottomView.addSubview(travelView)
        travelView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(resultView.snp.right).offset(6)
            make.height.equalTo(sampViewHeight)
        }
        travelLabel = UILabel()
        travelView.addSubview(travelLabel)
        travelLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(12)
            make.width.equalTo(45)
        }
        travelArrowImgView = UIImageView()
        travelView.addSubview(travelArrowImgView)
        travelArrowImgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(6)
            make.height.equalTo(10)
            make.left.equalTo(travelLabel.snp.right).offset(2)
        }
        
        desLabel = UILabel()
        bottomView.addSubview(desLabel)
        desLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.top.equalTo(sampView.snp.bottom).offset(15)
        }

        //scrollview
        scrollView = UIScrollView()
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        headView = UIImageView()
        scrollView.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(headView.snp.width).multipliedBy(100.0 / 375.0)
        }
        
        nameTextField = UITextField()
        scrollView.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { make in
            make.left.equalTo(294)
            make.top.equalTo(19)
            make.height.equalTo(20)
            make.right.equalTo(0)
        }
        
        idCardField = UITextField()
        scrollView.addSubview(idCardField)
        idCardField.snp.makeConstraints { make in
            make.top.equalTo(72)
            make.left.equalTo(230)
            make.height.equalTo(16)
            make.right.equalTo(0)
        }
        
        //滚动文字
        scrollContentView = UIView()
        scrollView.addSubview(scrollContentView)
        scrollContentView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headView.snp.bottom)
            make.height.equalTo(34)
        }
        
        scrollContainerView = UIView()
        scrollContentView.addSubview(scrollContainerView)
        scrollContainerView.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.top.equalTo(7)
            make.bottom.equalTo(-7)
            make.right.equalTo(-14)
        }
        
        contentLabel = UILabel()
        scrollContainerView.addSubview(contentLabel)
        
        //健康码
        codeView = UIView()
        scrollView.addSubview(codeView)
        codeView.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.top.equalTo(scrollContentView.snp.bottom).offset(8)
            make.width.equalTo(kScreenWidth - 12 * 2)
        }
        codeTimeLabel = UILabel()
        codeView.addSubview(codeTimeLabel)
        codeTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(28)
            make.left.right.equalToSuperview()
            make.height.equalTo(42)
        }
        codeImgView = UIImageView()
        codeView.addSubview(codeImgView)
        codeImgView.snp.makeConstraints { (make) in
            make.top.equalTo(codeTimeLabel.snp.bottom).offset(22)
            make.centerX.equalToSuperview()
            make.left.equalTo(48)
            make.right.equalTo(-48)
            make.height.equalTo(codeImgView.snp.width)
            make.bottom.equalTo(-28)
        }

        //核酸结果
        nucleateImgView = UIImageView()
        scrollView.addSubview(nucleateImgView)
        nucleateImgView.snp.makeConstraints { make in
            make.left.equalTo(9)
            make.top.equalTo(codeView.snp.bottom).offset(8)
            make.width.equalTo((kScreenWidth - 26.0) / 2.0)
            make.height.equalTo(nucleateImgView.snp.width).multipliedBy(302.0 / 354.0)
        }
        
        //疫苗结果
        vaccineImgView = UIImageView()
        scrollView.addSubview(vaccineImgView)
        vaccineImgView.snp.makeConstraints { make in
            make.top.equalTo(codeView.snp.bottom).offset(10)
            make.right.equalTo(-10)
            make.left.equalTo(nucleateImgView.snp.right).offset(8)
            make.height.equalTo(vaccineImgView.snp.width).multipliedBy(296.0 / 356.0)
        }
        
        //大数据行程卡
        travelImgView = UIImageView()
        scrollView.addSubview(travelImgView)
        travelImgView.snp.makeConstraints { make in
            make.top.equalTo(nucleateImgView.snp.bottom).offset(7)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(travelImgView.snp.width).multipliedBy(113.0 / 713.0)
        }
        
        //信息更新
        infoUpdateImgView = UIImageView()
        scrollView.addSubview(infoUpdateImgView)
        infoUpdateImgView.snp.makeConstraints { make in
            make.top.equalTo(travelImgView.snp.bottom).offset(8)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(infoUpdateImgView.snp.width).multipliedBy(267.0 / 711.0)
        }
        
        //数据来源
        dataSourceLabel = UILabel()
        scrollView.addSubview(dataSourceLabel)
        dataSourceLabel.snp.makeConstraints { make in
            make.top.equalTo(infoUpdateImgView.snp.bottom).offset(20)
            make.left.equalTo(infoUpdateImgView).offset(29)
            make.right.equalTo(infoUpdateImgView).offset(-29)
        }
        
        //横线
        line = UIView()
        scrollView.addSubview(line)
        line.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(dataSourceLabel.snp.bottom).offset(10)
            make.height.equalTo(1)
        }
        
        //操作说明
        operationBtn = UIButton(type: .custom)
        scrollView.addSubview(operationBtn)
        operationBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(line.snp.bottom).offset(10)
            make.width.equalTo(200)
            make.height.equalTo(13)
        }
        
        //服务热线
        hotLineLabel = UILabel()
        scrollView.addSubview(hotLineLabel)
        hotLineLabel.snp.makeConstraints { make in
            make.top.equalTo(operationBtn.snp.bottom).offset(5)
            make.left.equalTo(29)
            make.right.equalTo(-29)
            make.bottom.equalTo(-25)
        }
        
    }
    
    override func configUI() {
        super.configUI()
        
        self.view.insertSubview(bottomView, aboveSubview: scrollView)
        
        //导航栏
        navBar.setImage(UIImage.iHealthCodeNav, for: .normal)
        navBar.setImage(UIImage.iHealthCodeNav, for: .selected)
        navBar.setImage(UIImage.iHealthCodeNav, for: .highlighted)
        navBar.addTarget(self, action: #selector(backAction(sender:)), for: .touchUpInside)
        
        //底部view
        bottomView.backgroundColor = .white
        bottomView.layer.shadowColor = UIColor.black.cgColor
        bottomView.layer.shadowRadius = 5
        bottomView.layer.shadowOffset = CGSize(width: 0, height: -5)
        bottomView.layer.shadowOpacity = 0.1
        
        sampView.backgroundColor = UIColor.colorFromHex(0x49a16f)
        sampView.layer.cornerRadius = 5
        sampDateLabel.textColor = .white
        sampDateLabel.font = .systemFont(ofSize: 12)
        sampDateLabel.textAlignment = .center
        sampDateLabel.text = String(format: "%@核酸检测", getTimeString(date: nowAfter(isTodaySamp ? 0 : -tSecondsInDay), sepType: .local, year: nil, month: .monthShort, day: .dayShort, hour: nil, min: nil, sec: nil))
        sampRetLabel.textColor = .white
        sampRetLabel.font = .systemFont(ofSize: 12)
        sampRetLabel.textAlignment = .center
        sampRetLabel.text = "已采样"
        sampArrowImgView.image = UIImage.iRightArrowLightAlways
        
        resultView.backgroundColor = UIColor.colorFromHex(0x499b34)
        resultView.layer.cornerRadius = 5
        resultDateLabel.textColor = .white
        resultDateLabel.font = .systemFont(ofSize: 12)
        resultDateLabel.textAlignment = .center
        //是否显示今天
        var isCurrent: Bool = false
        if isTodaySamp
        {
            let period = TimeEmbellisher.shared.getPeriod(Date())
            if period == .noon || period == .afternoon || period == .evenfall || period == .evening
            {
                isCurrent = true
            }
        }
        resultDateLabel.text = String(format: "%@核酸检测", getTimeString(date: isCurrent ? Date() : nowAfter(-tSecondsInDay), sepType: .local, year: nil, month: .monthShort, day: .dayShort, hour: nil, min: nil, sec: nil))
        resultRetLabel.textColor = .white
        resultRetLabel.font = .systemFont(ofSize: 12)
        resultRetLabel.textAlignment = .center
        resultRetLabel.text = "结果：阴性"
        resultArrowImgView.image = UIImage.iRightArrowLightAlways
        
        travelView.backgroundColor = UIColor.colorFromHex(0x4d88e2)
        travelView.layer.cornerRadius = 5
        travelLabel.textColor = .white
        travelLabel.font = .systemFont(ofSize: 13)
        travelLabel.textAlignment = .center
        travelLabel.text = "行程卡"
        travelArrowImgView.image = UIImage.iRightArrowLightAlways
        
        desLabel.textColor = UIColor.colorFromHex(0x696969)
        desLabel.font = .systemFont(ofSize: 10)
        desLabel.numberOfLines = 0
        desLabel.text = "*数据来源：苏州市卫生健康委员会。反映近7天内最新核酸采样记录和核酸检测报告情况，点击可查询更多，数据在不断汇聚和完善中。"
        
        scrollView.backgroundColor = UIColor.colorFromHex(0xededed)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = true
        
        headView.image = UIImage.iHealthCodeHead
        
        nameTextField.text = "姚五岳"
        nameTextField.delegate = self
        nameTextField.textColor = UIColor.colorWithHex("C1F0FF")
        nameTextField.font = .boldSystemFont(ofSize: 20)
        nameTextField.returnKeyType = .done
        
        idCardField.text = "321******8609"
        idCardField.delegate = self
        idCardField.textColor = UIColor.colorWithHex("F5FFFF")
        idCardField.font = UIFont.init(name: "Arial", size: 21)
        idCardField.returnKeyType = .done
        idCardField.isHidden = true
        
        scrollContentView.backgroundColor = UIColor.colorFromHex(0xfefaf0)
        
        scrollContainerView.clipsToBounds = true
        
        contentLabel.font = .systemFont(ofSize: 19)
        contentLabel.textColor = UIColor.colorFromHex(0xd0723f)
        contentLabel.text = "若您有近7天中高风险地区旅居史(含境外)请及时信息更新和风险报备。"
        canScrollContent = true
        
        //健康码
        codeView.backgroundColor = .white
        codeView.layer.cornerRadius = 8
        codeView.layer.shadowColor = UIColor.black.cgColor
        codeView.layer.shadowOffset = .zero
        codeView.layer.shadowRadius = 5
        codeView.layer.shadowOpacity = 0.1
        
        codeTimeLabel.font = UIFont.init(name: "Noto Sans Myanmar Bold", size: 42)
        codeTimeLabel.textColor = .cBlack_3
        codeTimeLabel.textAlignment = .center
        codeTimeLabel.text = currentTimeString(format: .dashMonthDayHourMinSec)
        
        codeImgView.image = UIImage.iHealthCode
        
        //核酸结果/疫苗结果/大数据行程卡
        nucleateImgView.image = UIImage.iHealthCodeNucleate
        vaccineImgView.image = UIImage.iHealthCodeVaccine
        travelImgView.image = UIImage.iHealthCodeTravelCard
        
        //信息更新
        infoUpdateImgView.image = UIImage.iHealthCodeInfoUpdate
        
        //数据来源
        dataSourceLabel.textColor = UIColor.colorFromHex(0x3579F6)
        dataSourceLabel.font = .systemFont(ofSize: 13)
        dataSourceLabel.textAlignment = .center
        dataSourceLabel.numberOfLines = 0
        dataSourceLabel.text = "数据来源:全国一体化政务服务平台、个人申报信息和江苏省公共管理机构。"
        
        //横线
        line.backgroundColor = UIColor.cGray_dc
        
        //操作说明
        operationBtn.setTitle("操作说明", for: .normal)
        operationBtn.setTitleColor(UIColor.colorFromHex(0x3579F6), for: .normal)
        operationBtn.titleLabel?.font = .systemFont(ofSize: 13)
        operationBtn.addTarget(self, action: #selector(operationAction(sender:)), for: .touchUpInside)
        
        //服务热线
        hotLineLabel.textColor = UIColor.colorFromHex(0x777777)
        hotLineLabel.font = .systemFont(ofSize: 13)
        hotLineLabel.textAlignment = .center
        hotLineLabel.numberOfLines = 0
        hotLineLabel.text = "本服务由江苏省疾病预防控制中心提供\n––– 服务热线：12345 –––"
    }
    
    override func updateUI() {
        startContentScroll()
        startTimer()
    }

    //开启文字滚动效果
    func startContentScroll()
    {
        //设置初始位置
        contentLabel.sizeToFit()
        let textWidth: CGFloat = contentLabel.width
        contentLabel.x = kScreenWidth
        contentLabel.y = 0
        //做一个动画
        UIView.animate(withDuration: 12, delay: 0, options: .curveLinear) {[weak self] in
            self?.contentLabel.x = -(textWidth - kScreenWidth / 2.0)
        } completion: {[weak self] finished in
            if let ret = self?.canScrollContent, ret == true
            {
                self?.startContentScroll()
            }
        }
    }
    
    //开启时间定时器
    func startTimer()
    {
        endTimer()
        timer = TimerManager.shared.timer(interval: 1.0, repeats: true, mode: .common, hostId: self.className, action: {[weak self] (timer) in
            self?.codeTimeLabel.text = currentTimeString(format: .dashMonthDayHourMinSec)
        })
    }
    
    //结束时间定时器
    func endTimer()
    {
        timer?.invalidate()
        timer = nil
    }
    
    //操作说明事件
    @objc func operationAction(sender: UIButton)
    {
        
    }
    
    deinit {
        self.canScrollContent = false
        endTimer()
    }
}


extension HealthCodeViewController: DelegateProtocol, UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
