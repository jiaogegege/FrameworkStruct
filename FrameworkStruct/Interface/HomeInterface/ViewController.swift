//
//  ViewController.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2021/12/9.
//

import UIKit

class ViewController: UIViewController {
    
    let titleArray = [String.sWaterfall, String.sThemeSelect, String.sModalShow, String.sConstraintTest]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configUI()
    }
    
    //设置界面
    func configUI()
    {
//        ToastManager.shared.style = .light
//        ToastManager.shared.contentColor = UIColor.black
        ToastManager.shared.hudType = .svHud
        ToastManager.shared.wantShowText("1")
        ToastManager.shared.wantShowText("2")
        ToastManager.shared.wantShowText("3")
        ToastManager.shared.directShow(text: "直接显示", detail: nil, animate: true, hideDelay: 3, completion: nil)
        ToastManager.shared.wantShowText("4")
        ToastManager.shared.wantShowText("5")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            ToastManager.shared.hideHUD()
//        }
//        ToastManager.shared.wantShow(text: "圣诞快乐风景是动手动脚", detail: nil, animate: true, hideDelay: 2) {
//            print("上岛咖啡加上点开链接")
//        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0
        {
            let jcolVC = JCollectionViewController.init()
            self.navigationController?.pushViewController(jcolVC, animated: true)
        }
        else if indexPath.row == 1
        {
            let themeVC = ThemeSelectViewController.getViewController()
            self.navigationController?.pushViewController(themeVC, animated: true)
        }
        else if indexPath.row == 2
        {
            let vc = ModalTestViewController.getViewController()
            vc.modalPresentationStyle = .pageSheet
//            vc.isModalInPresentation = true
            self.present(vc, animated: true, completion: nil)
        }
        else if indexPath.row == 3
        {
            let vc = ConstraintTestViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
