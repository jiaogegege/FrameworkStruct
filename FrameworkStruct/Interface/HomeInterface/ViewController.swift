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
        AlertManager.shared.wantPresentAlert(title: "1")
        AlertManager.shared.wantPresentAlert(title: "2")
        AlertManager.shared.wantPresentAlert(title: "3")
        AlertManager.shared.wantPresentAlert(title: "4")
        AlertManager.shared.wantPresentAlert(title: "15")
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
