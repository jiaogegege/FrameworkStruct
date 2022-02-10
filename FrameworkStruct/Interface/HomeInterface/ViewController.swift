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
    
    let titleArray = [String.waterfall, String.themeSelect, String.modalShow, String.constraintTest, String.drawTable, String.layerShadow]

    override func viewDidLoad() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
            super.viewDidLoad()
        }
        self.backStyle = .none
        self.title = "功能选择"
    }
    
    //创建界面
    override func createUI() {
        super.createUI()
        
    }
    
    //设置界面
    override func configUI()
    {
        super.configUI()

    }
    
    //初始化数据
    override func initData() {
        super.initData()
        
    }
    
    //更新界面
    override func updateUI() {
        super.updateUI()
        
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
        if indexPath.row == 0
        {
            let jcolVC = JCollectionViewController.init()
            self.navigationController?.pushViewController(jcolVC, animated: true)
        }
        else if indexPath.row == 1  //主题选择
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
        else if indexPath.row == 4  //绘制表格
        {
            let vc = SimpleTableViewController.getViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else if indexPath.row == 5  //阴影测试
        {
            let vc = ShadowTestViewController.getViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
