//
//  ViewController.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2021/12/9.
//

import UIKit

class ViewController: BasicViewController
{
    @IBOutlet weak var tableView: UITableView!
    
    let titleArray = [String.healthCode, String.placeCode, String.travelCard, String.waterfall, String.themeSelect, String.modalShow, String.constraintTest, String.drawTable, String.layerShadow, String.animationDemo, String.webInteraction, String.drawTest, String.copyPaste]
    
    override class func getViewController() -> Self {
        return getVC(from: gMainSB)
    }

    override func viewDidLoad() {
            super.viewDidLoad()
    }
    
    override func customConfig() {
        self.title = "功能选择"
        self.backStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.statusBarStyle = .light
        self.hideNavBar = false
        self.navBackgroundColor = self.theme.mainColor
        self.navTitleColor = .white
    }
    
    //创建界面
    override func createUI() {
        super.createUI()
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.navBackgroundColor = self.theme.mainColor
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = self.titleArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == 0   //健康码
        {
            g_alert(title: "是否今日检测？", leftTitle: String.no, leftBlock: {
                let vc = HealthCodeViewController.getViewController()
                vc.hidesBottomBarWhenPushed = true
                vc.isTodaySamp = false
                self.push(vc)
            }, rightTitle: String.yes) { text in
                let vc = HealthCodeViewController.getViewController()
                vc.hidesBottomBarWhenPushed = true
                vc.isTodaySamp = true
                self.push(vc)
            }
        }
        else if indexPath.row == 1      //场所码
        {
            g_alert(title: "是否今日检测？", leftTitle: String.no, leftBlock: {
                let vc = PlaceCodeViewController.getViewController()
                vc.hidesBottomBarWhenPushed = true
                vc.isTodaySamp = false
                self.push(vc)
            }, rightTitle: String.yes) { text in
                let vc = PlaceCodeViewController.getViewController()
                vc.hidesBottomBarWhenPushed = true
                vc.isTodaySamp = true
                self.push(vc)
            }
        }
        else if indexPath.row == 2      //行程卡
        {
            g_alert(title: "输入省市", needInput: true, inputPlaceHolder: "江苏省苏州市", usePlaceHolder: true) {
                
            } rightBlock: { text in
                let vc = TravelCardViewController.getViewController()
                vc.hidesBottomBarWhenPushed = true
                vc.provinceCity = text
                self.push(vc)
            }
        }
        else if indexPath.row == 3       //瀑布流
        {
            let vc = JCollectionViewController.getViewController()
            vc.hidesBottomBarWhenPushed = true
            self.push(vc)
        }
        else if indexPath.row == 4  //主题选择
        {
            let vc = ThemeSelectViewController.getViewController()
            vc.hidesBottomBarWhenPushed = true
            self.push(vc)
        }
        else if indexPath.row == 5
        {
            let vc = ModalTestViewController.getViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.modalPresentationStyle = .pageSheet
//            vc.isModalInPresentation = true
            self.present(vc, animated: true, completion: nil)
        }
        else if indexPath.row == 6  //约束测试
        {
            let vc = ConstraintTestViewController.getViewController()
            vc.hidesBottomBarWhenPushed = true
            self.push(vc)
        }
        else if indexPath.row == 7  //绘制表格
        {
            let vc = SimpleTableViewController.getViewController()
            vc.hidesBottomBarWhenPushed = true
            self.push(vc)
            
        }
        else if indexPath.row == 8  //阴影测试
        {
            let vc = ShadowTestViewController.getViewController()
            vc.hidesBottomBarWhenPushed = true
            self.push(vc)
        }
        else if indexPath.row == 9  //动画演示
        {
            let vc = AnimationDemoViewController.getViewController()
            vc.hidesBottomBarWhenPushed = true
            self.push(vc)
        }
        else if indexPath.row == 10  //h5交互
        {
            let vc = TestWebViewController.getViewController()
            vc.hidesBottomBarWhenPushed = true
            self.push(vc)
        }
        else if indexPath.row == 11  //绘图测试
        {
            let vc = DrawTestViewController.getViewController()
            vc.hidesBottomBarWhenPushed = true
            self.push(vc)
        }
        else if indexPath.row == 12  //复制粘贴
        {
            let vc = CopyPasteViewController.getViewController()
            vc.hidesBottomBarWhenPushed = true
            self.push(vc)
        }
    }
    
    
}
