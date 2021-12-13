//
//  ThemeSelectViewController.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/12/13.
//

import UIKit

class ThemeSelectViewController: UIViewController
{
    //MARK: 属性
    //视图组件
    @IBOutlet weak var tableView: UITableView!
    
    //内部属性
    let themeMgr = ThemeManager.shared  //主题管理器
    var themeArray: [CustomTheme]? = nil    //主题列表
    
    
    static func getViewController() -> ThemeSelectViewController
    {
        let board = UIStoryboard(name: sMainSB, bundle: nil)
        return board.instantiateViewController(withIdentifier: "ThemeSelectViewController") as! ThemeSelectViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configUI()
        self.initData()
    }
    
    func configUI()
    {
        self.tableView.register(SelectThemeCell.self, forCellReuseIdentifier: SelectThemeCellKey)
        
    }
    
    func initData()
    {
        self.themeArray = themeMgr.allTheme
    }

    
}

//MARK: tableView代理
extension ThemeSelectViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.themeArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectThemeCellKey, for: indexPath) as! SelectThemeCell
        cell.theme = self.themeArray?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
