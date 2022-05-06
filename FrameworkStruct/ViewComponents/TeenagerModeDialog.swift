//
//  TeenagerModeDialog.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/1/15.
//

/**
 * 青少年模式弹窗
 */
import UIKit

class TeenagerModeDialog: FSDialog
{
    //回调
    var enterTeenModeCallback: VoidClosure? = nil   //进入青少年模式
    var confirmCallback: VoidClosure? = nil     //我知道了
    
    //UI组件
    fileprivate var headImageView: UIImageView! //头图
    fileprivate var contentLabel: UILabel!  //内容说明
    fileprivate var goBtn: UIButton!    //去设置青少年模式
    fileprivate var sepLine: UIView!    //分割线
    fileprivate var confirmBtn: UIButton!   //我知道了按钮
    
    
    //MARK: 方法
    
    //创建界面
    override func createView() {
        super.createView()
        
        headImageView = UIImageView()
        containerView.addSubview(headImageView)
        
        contentLabel = UILabel()
        containerView.addSubview(contentLabel)
        
        goBtn = UIButton(type: .custom)
        containerView.addSubview(goBtn)
        
        sepLine = UIView()
        containerView.addSubview(sepLine)
        
        confirmBtn = UIButton(type: .custom)
        containerView.addSubview(confirmBtn)
    }
    
    //设置界面
    override func configView() {
        super.configView()
        
        containerView.layer.cornerRadius = 5.0
        containerView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.left.equalTo(fit8(50))
            make.right.equalTo(fit8(-50))
        }
        
        //头图
        headImageView.image = .iTeenagerProtect
        headImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(fit8(24))
            make.height.equalTo(fit8(70))
            make.width.equalTo(headImageView.snp.height).multipliedBy(1.328)
        }
        
        //内容说明
        contentLabel.text = String.teenagerProtectContent
        contentLabel.textColor = ThemeManager.shared.getCurrentTheme().contentTextColor
        contentLabel.font = UIFont.systemFont(ofSize: fit8(14))
        contentLabel.textAlignment = .center
        contentLabel.numberOfLines = 0
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(fit8(24))
            make.right.equalTo(fit8(-24))
            make.top.equalTo(headImageView.snp.bottom).offset(fit8(16))
        }
        
        //选择模式按钮
        goBtn.setTitle(String.enterTeenMode + " >", for: .normal)
        goBtn.titleLabel?.font = UIFont.systemFont(ofSize: fit8(15))
        goBtn.setTitleColor(.systemBlue, for: .normal)
        goBtn.addTarget(self, action: #selector(gotoTeenAction(sender:)), for: .touchUpInside)
        goBtn.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(fit8(2))
            make.width.equalTo(fit8(200))
            make.height.equalTo(fit8(36))
            make.centerX.equalToSuperview()
        }
        
        //分割线
        sepLine.backgroundColor = .cGray_f4
        sepLine.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.left.right.equalTo(0)
            make.top.equalTo(goBtn.snp.bottom).offset(fit8(8))
        }
        
        //我知道了按钮
        confirmBtn.setTitle(.iKnown, for: .normal)
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: fitX(20))
        confirmBtn.setTitleColor(self.themeColor, for: .normal)
        confirmBtn.addTarget(self, action: #selector(iKnownAction(sender:)), for: .touchUpInside)
        confirmBtn.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(sepLine.snp.bottom)
            make.height.equalTo(fit8(50))
        }
    }

    //进入青少年模式
    @objc func gotoTeenAction(sender: UIButton)
    {
        FSLog("进入青少年模式")
        if let cb = self.enterTeenModeCallback
        {
            cb()
        }
    }
    
    //我知道了按钮
    @objc func iKnownAction(sender: UIButton)
    {
        FSLog("我知道了")
        if let cb = self.confirmCallback
        {
            cb()
        }
    }

    //设置动画初始状态
    override func resetOrigin() {
        super.resetOrigin()
        self.containerView.snp.updateConstraints { make in
            make.centerY.equalToSuperview().offset((kScreenHeight - containerView.height) / 2.0)
        }
        containerView.transform = containerView.transform.scaledBy(x: 0.5, y: 0.5)
        self.layoutIfNeeded()
    }
    
    //显示时的动画效果
    override func showAnimation(completion: @escaping VoidClosure) {
        super.showAnimation(completion: completion)
        UIView.animate(withDuration: self.animateInterval, delay: 0.0, options: .curveEaseOut) {
            self.containerView.snp.updateConstraints { make in
                make.centerY.equalToSuperview()
            }
            self.containerView.transform = self.containerView.transform.scaledBy(x: 2.0, y: 2.0)
            self.layoutIfNeeded()
        } completion: { finished in
            
        }

    }
}
