//
//  HealthCodeViewController.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/9/5.
//

import UIKit

class HealthCodeViewController: BasicViewController {
    
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
    fileprivate var scrollContentView: UIView!      //滚动横幅
    fileprivate var scrollContainerView: UIView!
    fileprivate var contentLabel: UILabel!          //滚动横幅文字
    fileprivate var codeView: UIView!
    fileprivate var codeTimeLabel: UILabel!
    fileprivate var codeImgView: UIImageView!   //健康码绿码
    
    
    var canScrollContent: Bool = false       //是否可以滚动文字界面退出后不可以滚动

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
            make.height.equalTo(44.0)
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
        var scrollHeight: CGFloat = 0.0     //滚动内容高度
        
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
            make.width.equalTo(kScreenWidth)
            make.height.equalTo(100)
        }
        scrollHeight += 100
        
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
        scrollHeight += 34
        
        scrollHeight += 8
        
        //健康码
        codeView = UIView()
        scrollView.addSubview(codeView)
        codeView.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.top.equalTo(scrollContentView.snp.bottom).offset(8)
            make.width.equalTo(kScreenWidth - 12 * 2)
            make.height.equalTo(kScreenWidth)
        }
        codeTimeLabel = UILabel()
        codeView.addSubview(codeTimeLabel)
        codeTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(28)
            make.left.right.equalToSuperview()
            make.height.equalTo(31)
        }
        
        scrollHeight += kScreenWidth
        
        scrollView.contentSize = CGSize(width: kScreenWidth, height: scrollHeight)
    }
    
    override func configUI() {
        super.configUI()
        
        navBar.setImage(UIImage.iHealthCodeNav, for: .normal)
        navBar.setImage(UIImage.iHealthCodeNav, for: .selected)
        navBar.setImage(UIImage.iHealthCodeNav, for: .highlighted)
        navBar.addTarget(self, action: #selector(backAction(sender:)), for: .touchUpInside)
        
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
        sampDateLabel.text = String(format: "%@核酸检测", currentTimeString(format: .localMonthDayShort))
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
        resultDateLabel.text = String(format: "%@核酸检测", currentTimeString(format: .localMonthDayShort))
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
        
        scrollContentView.backgroundColor = UIColor.colorFromHex(0xfefaf0)
        
        scrollContainerView.clipsToBounds = true
        
        contentLabel.font = .systemFont(ofSize: 19)
        contentLabel.textColor = UIColor.colorFromHex(0xd0723f)
        contentLabel.text = "若您有近7天中高风险地区旅居史(含境外)请及时信息更新和风险报备。"
        canScrollContent = true
        startContentScroll()
        
        //健康码
        codeView.backgroundColor = .white
        codeView.layer.cornerRadius = 8
        codeView.layer.shadowColor = UIColor.black.cgColor
        codeView.layer.shadowOffset = .zero
        codeView.layer.shadowRadius = 5
        codeView.layer.shadowOpacity = 0.1
        
        codeTimeLabel.font = .boldSystemFont(ofSize: 30)
        codeTimeLabel.textColor = .cBlack_3
        codeTimeLabel.textAlignment = .center
        codeTimeLabel.text = currentTimeString(format: .dashMonthDayHourMinSec)
        
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
    
    deinit {
        self.canScrollContent = false
    }
}
