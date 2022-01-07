//
//  ThemeSelectViewController.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/12/13.
//

import UIKit

class ThemeSelectViewController: BasicViewController
{
    //MARK: 属性
    //视图组件
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var progress: UIProgressView!
    
    //内部属性
    let themeMgr = ThemeManager.shared  //主题管理器
    var themeArray: [ThemeProtocol]? = nil    //主题列表
    
    
    static func getViewController() -> ThemeSelectViewController
    {
        let board = UIStoryboard(name: kMainSB, bundle: nil)
        return board.instantiateViewController(withIdentifier: "ThemeSelectViewController") as! ThemeSelectViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func createUI()
    {
        super.createUI()
        self.tableView.register(UINib(nibName: SelectThemeCellKey, bundle: nil), forCellReuseIdentifier: SelectThemeCellKey)
    }
    
    override func configUI() {
        super.configUI()
    }
    
    override func initData()
    {
        super.initData()
        self.themeArray = themeMgr.allTheme
    }
    
    override func updateUI() {
        super.updateUI()
    }

    //切换主题更新UI
    override func themeUpdateUI(theme: ThemeProtocol)
    {
        super.themeUpdateUI(theme: theme)
        label.backgroundColor = theme.mainColor
        label.textColor = theme.mainTitleColor
        button.setTitleColor(theme.mainColor, for: .normal)
        segment.selectedSegmentTintColor = theme.mainColor
        textField.textColor = theme.mainColor
        slider.tintColor = theme.mainColor
        switcher.onTintColor = theme.mainColor
        progress.progressTintColor = theme.mainColor
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
        cell.update()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let theme = self.themeArray?[indexPath.row]
        {
            //切换主题
            themeMgr.changeTheme(theme: theme)
        }
    }
    
}


