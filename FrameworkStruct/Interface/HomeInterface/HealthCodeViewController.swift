//
//  HealthCodeViewController.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/9/5.
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
    
    fileprivate var nucleateScrollView: UIScrollView!       //核酸疫苗信息，左右滑动
    //中间view
    fileprivate var nucleateMiddleView: UIView!     //48小时核酸
    fileprivate var nucleateImgView: UIImageView!   //核酸结果
    fileprivate var vaccineImgView: UIImageView!    //疫苗结果
    fileprivate var travelImgView: UIImageView! //大数据行程卡
    fileprivate var infoUpdateImgView: UIImageView!     //信息更新
    fileprivate var dataSourceLabel: UILabel!       //数据来源
    fileprivate var line: UIView!
    fileprivate var operationBtn: UIButton!     //操作说明
    fileprivate var hotLineLabel: UILabel!  //服务热线
    //左侧view
    fileprivate var nucleateLeftView: UIView!
    fileprivate var nucleateSampView: UIView!       //采样信息容器
    fileprivate var nucleateSampPosLabel: UILabel!      //采样地点
    fileprivate var nucleateSampDetectTimeLabel: UILabel!   //检测时间
    fileprivate var nucleateSampDetectResultLabel: UILabel!     //检测结果
    fileprivate var nucleateInfoImgView: UIImageView!
    //右侧view
    fileprivate var nucleateRightView: UIView!      //疫苗view
    
    
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
            make.height.equalTo(75 + kSafeBottomHeight)
        }
        
        let sampViewWidth: CGFloat = (kScreenWidth - 6 * 6.0) / 3.0
        let sampViewHeight: CGFloat = 40.0
        
        sampView = UIView()
        bottomView.addSubview(sampView)
        sampView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(5)
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
            make.top.equalTo(sampView)
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
            make.top.equalTo(sampView)
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
            make.top.equalTo(sampView.snp.bottom).offset(10)
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
        
        nucleateScrollView = UIScrollView()
        nucleateScrollView.isPagingEnabled = true
        nucleateScrollView.showsVerticalScrollIndicator = false
        nucleateScrollView.showsHorizontalScrollIndicator = false
        nucleateScrollView.bounces = false
        scrollView.addSubview(nucleateScrollView)
        nucleateScrollView.snp.makeConstraints { make in
            make.top.equalTo(codeView.snp.bottom).offset(4)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(500)
            make.bottom.equalToSuperview()
        }
        //核酸左侧view
        nucleateLeftView = UIView()
        nucleateScrollView.addSubview(nucleateLeftView)
        nucleateLeftView.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.width.equalTo(kScreenWidth)
            make.height.equalTo(305)
        }
        nucleateSampView = UIView()
        nucleateSampView.backgroundColor = .white
        nucleateLeftView.addSubview(nucleateSampView)
        nucleateSampView.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.top.equalTo(4)
            make.height.equalTo(178)
        }
        let sampPosNameLabel = UILabel()
        sampPosNameLabel.textColor = UIColor.colorFromHex(0x898989)
        sampPosNameLabel.font = .systemFont(ofSize: 15)
        sampPosNameLabel.text = "采样点："
        nucleateSampView.addSubview(sampPosNameLabel)
        sampPosNameLabel.snp.makeConstraints { make in
            make.left.equalTo(8)
            make.top.equalTo(13)
            make.height.equalTo(15)
        }
        nucleateSampPosLabel = UILabel()
        nucleateSampPosLabel.textColor = UIColor.colorFromHex(0x494949)
        nucleateSampPosLabel.font = .systemFont(ofSize: 15)
        nucleateSampPosLabel.text = "丽景湾花园"
        nucleateSampView.addSubview(nucleateSampPosLabel)
        nucleateSampPosLabel.snp.makeConstraints { make in
            make.left.equalTo(96)
            make.top.equalTo(sampPosNameLabel)
            make.height.equalTo(sampPosNameLabel)
        }
        let detectTimeNameLabel = UILabel()
        detectTimeNameLabel.textColor = UIColor.colorFromHex(0x898989)
        detectTimeNameLabel.font = .systemFont(ofSize: 15)
        detectTimeNameLabel.text = "检测时间："
        nucleateSampView.addSubview(detectTimeNameLabel)
        detectTimeNameLabel.snp.makeConstraints { make in
            make.left.equalTo(sampPosNameLabel)
            make.top.equalTo(sampPosNameLabel.snp.bottom).offset(20)
            make.height.equalTo(15)
        }
        nucleateSampDetectTimeLabel = UILabel()
        nucleateSampDetectTimeLabel.textColor = UIColor.colorFromHex(0x494949)
        nucleateSampDetectTimeLabel.font = .systemFont(ofSize: 15)
        var detectTimeStr = currentTimeString(format: .dashYearMonthDayHourMinSec)
        //如果是上午则取昨天下午的时间，如果是下午则取今天下午的时间
        let nowPeriod = TimeEmbellisher.shared.getPeriod(Date())
        if nowPeriod == .beforeDawn || nowPeriod == .morning || nowPeriod == .forenoon
        {
            detectTimeStr = TimeEmbellisher.shared.string(from: TimeEmbellisher.shared.dateByComponent(nowAfter(-tSecondsInDay), hour: 14, minute: 24, second: 51)!, format: .dashYearMonthDayHourMinSec)
        }
        else
        {
            //时间不超过当前时间
            var date = TimeEmbellisher.shared.dateByComponent(Date(), hour: Int(randomIn(13, 18)), minute: Int(randomIn(1, 59)), second: Int(randomIn(1, 59)))!
            if intervalBetween(date, Date()) < 0
            {
                date = Date()
            }
            detectTimeStr = TimeEmbellisher.shared.string(from: date, format: .dashYearMonthDayHourMinSec)
        }
        nucleateSampDetectTimeLabel.text = detectTimeStr
        nucleateSampView.addSubview(nucleateSampDetectTimeLabel)
        nucleateSampDetectTimeLabel.snp.makeConstraints { make in
            make.left.equalTo(96)
            make.top.equalTo(detectTimeNameLabel)
            make.height.equalTo(detectTimeNameLabel)
        }
        let detectResultNameLabel = UILabel()
        detectResultNameLabel.textColor = UIColor.colorFromHex(0x898989)
        detectResultNameLabel.font = .systemFont(ofSize: 15)
        detectResultNameLabel.text = "检测结果："
        nucleateSampView.addSubview(detectResultNameLabel)
        detectResultNameLabel.snp.makeConstraints { make in
            make.left.equalTo(8)
            make.top.equalTo(detectTimeNameLabel.snp.bottom).offset(20)
            make.height.equalTo(15)
        }
        nucleateSampDetectResultLabel = UILabel()
        nucleateSampDetectResultLabel.textColor = UIColor.colorFromHex(0x58C73A)
        nucleateSampDetectResultLabel.font = .boldSystemFont(ofSize: 16)
        nucleateSampDetectResultLabel.text = "阴性"
        nucleateSampView.addSubview(nucleateSampDetectResultLabel)
        nucleateSampDetectResultLabel.snp.makeConstraints { make in
            make.left.equalTo(96)
            make.top.equalTo(detectResultNameLabel)
            make.height.equalTo(detectResultNameLabel)
        }
        //分割线
        let nucleateLeftLine = UIView()
        nucleateLeftLine.backgroundColor = UIColor.colorFromHex(0xDEE1E6)
        nucleateSampView.addSubview(nucleateLeftLine)
        nucleateLeftLine.snp.makeConstraints { make in
            make.left.equalTo(8)
            make.right.equalTo(-8)
            make.height.equalTo(1)
            make.top.equalTo(detectResultNameLabel.snp.bottom).offset(20)
        }
        let nucleateDescLabel = UILabel()
        nucleateDescLabel.attributedText = StringEmbellisher.shared.attrStringWith("数据来源：江苏省卫生健康委员会，反映近7天内最近一次核酸检测情况，数据在不断汇聚和完善中。", font: .systemFont(ofSize: 12), lineSpace: 4)
        nucleateDescLabel.numberOfLines = 2
        nucleateDescLabel.textColor = UIColor.colorFromHex(0x777777)
        nucleateDescLabel.font = .systemFont(ofSize: 12)
        nucleateSampView.addSubview(nucleateDescLabel)
        nucleateDescLabel.snp.makeConstraints { make in
            make.left.right.equalTo(nucleateLeftLine)
            make.top.equalTo(nucleateLeftLine.snp.bottom).offset(10)
            make.bottom.equalTo(-4)
        }
        
        nucleateInfoImgView = UIImageView()
        nucleateInfoImgView.image = UIImage.iHealthNucleateInfo
        nucleateLeftView.addSubview(nucleateInfoImgView)
        nucleateInfoImgView.snp.makeConstraints { make in
            make.left.equalTo(6)
            make.right.equalTo(-6)
            make.top.equalTo(nucleateSampView.snp.bottom).offset(4)
            make.height.equalTo(125)
        }

        //核酸结果
        nucleateMiddleView = UIView()
        nucleateScrollView.addSubview(nucleateMiddleView)
        nucleateMiddleView.snp.makeConstraints { make in
            make.top.equalTo(nucleateLeftView)
            make.left.equalTo(nucleateLeftView.snp.right)
            make.width.equalTo(kScreenWidth)
            make.height.equalTo(500)
        }
        
        nucleateImgView = UIImageView()
        nucleateMiddleView.addSubview(nucleateImgView)
        nucleateImgView.snp.makeConstraints { make in
            make.left.equalTo(9)
            make.top.equalTo(4)
            make.width.equalTo((kScreenWidth - 26.0) / 2.0)
            make.height.equalTo(nucleateImgView.snp.width).multipliedBy(302.0 / 354.0)
        }
        
        //疫苗结果
        vaccineImgView = UIImageView()
        nucleateMiddleView.addSubview(vaccineImgView)
        vaccineImgView.snp.makeConstraints { make in
            make.top.equalTo(6)
            make.right.equalTo(-10)
            make.left.equalTo(nucleateImgView.snp.right).offset(8)
            make.height.equalTo(vaccineImgView.snp.width).multipliedBy(296.0 / 356.0)
        }
        
        //大数据行程卡
        travelImgView = UIImageView()
        nucleateMiddleView.addSubview(travelImgView)
        travelImgView.snp.makeConstraints { make in
            make.top.equalTo(nucleateImgView.snp.bottom).offset(7)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(travelImgView.snp.width).multipliedBy(113.0 / 713.0)
        }
        
        //信息更新
        infoUpdateImgView = UIImageView()
        nucleateMiddleView.addSubview(infoUpdateImgView)
        infoUpdateImgView.snp.makeConstraints { make in
            make.top.equalTo(travelImgView.snp.bottom).offset(2)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(infoUpdateImgView.snp.width).multipliedBy(267.0 / 711.0)
        }
        
        //数据来源
        dataSourceLabel = UILabel()
        nucleateMiddleView.addSubview(dataSourceLabel)
        dataSourceLabel.snp.makeConstraints { make in
            make.top.equalTo(infoUpdateImgView.snp.bottom).offset(20)
            make.left.equalTo(infoUpdateImgView).offset(29)
            make.right.equalTo(infoUpdateImgView).offset(-29)
        }
        
        //横线
        line = UIView()
        nucleateMiddleView.addSubview(line)
        line.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(dataSourceLabel.snp.bottom).offset(10)
            make.height.equalTo(1)
        }
        
        //操作说明
        operationBtn = UIButton(type: .custom)
        nucleateMiddleView.addSubview(operationBtn)
        operationBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(line.snp.bottom).offset(10)
            make.width.equalTo(200)
            make.height.equalTo(13)
        }
        
        //服务热线
        hotLineLabel = UILabel()
        nucleateMiddleView.addSubview(hotLineLabel)
        hotLineLabel.snp.makeConstraints { make in
            make.top.equalTo(operationBtn.snp.bottom).offset(5)
            make.left.equalTo(29)
            make.right.equalTo(-29)
            make.bottom.equalTo(-25)
        }
        
        nucleateScrollView.contentSize = CGSize(width: 2 * kScreenWidth, height: 500)
        nucleateScrollView.contentOffset = CGPoint(x: kScreenWidth, y: 0)
        scrollView.contentSize = CGSize(width: kScreenWidth, height: 1000)
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
        
        sampView.backgroundColor = UIColor.colorFromHex(0x4AA270)
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
        
        resultView.backgroundColor = UIColor.colorFromHex(0x499C34)
        resultView.layer.cornerRadius = 5
        resultDateLabel.textColor = .white
        resultDateLabel.font = .systemFont(ofSize: 12)
        resultDateLabel.textAlignment = .center
        //是否显示今天
        var isCurrent: Bool = false
        if isTodaySamp
        {
            let period = TimeEmbellisher.shared.getPeriod(Date())
            if period == .afternoon || period == .evenfall || period == .evening
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
        desLabel.textAlignment = .center
        desLabel.text = "*数据来源：苏州市新冠肺炎疫情联防联控指挥部"
        
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
        
        nucleateSampView.layer.cornerRadius = 8
        nucleateSampView.layer.shadowColor = UIColor.black.cgColor
        nucleateSampView.layer.shadowOffset = .zero
        nucleateSampView.layer.shadowRadius = 5
        nucleateSampView.layer.shadowOpacity = 0.1
        
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
