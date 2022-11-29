//
//  SimpleTableViewController.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/1/17.
//

/**
 * 创建简单表格
 */
import UIKit

class SimpleTableViewController: BasicViewController
{
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var expandBtn: UIButton!
    var table: SimpleTableView!
    
    //标题
    var titleStr: String?
    
    var dataArray = [["上市时间", "2021-03"],
                     ["认证型号", "V10 Digital Slim Fluffy"],
                     ["产品净重", "纤巧软绒滚筒*1，电动床褥吸头*1，缝隙软毛宽嘴两用吸头*1，缝隙清洁吸头*1，底部转换头*1，缝隙清洁吸头*1，底部转换头*1，缝隙清洁吸头*1，底部转换头*1"],
                     ["功能参数"],
                     ["额定电压", "220V"],
                     ["额定功率", "380W", "110W"]]
    
    override class func getViewController() -> Self {
        getVC(from: gMainSB)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let ti = titleStr
        {
            self.title = ti
        }
    }
    
    override func customConfig() {
        self.backgroundStyle = .lightGray
        self.navTitleColor = .green
        self.navBackgroundColor = .red
    }
    
    override func createUI() {
        super.createUI()
        self.table = SimpleTableView.init(frame: CGRect(x: 0, y: 0, width: self.containerView.width, height: containerView.height))
        self.containerView.addSubview(self.table)
    }
    
    override func configUI() {
        super.configUI()
        table.dataArray = self.dataArray
        table.isOddEvenIsolate = true
        table.updateView()
        
        let totalRow = table.totalRowCount
        //获取前3行高度
        let top3Height: CGFloat = table.getTopRowHeight(rowCount: 3).0
        self.expandBtn.isHidden = totalRow > 3 ? false : true
        self.containerViewHeight.constant = top3Height + 10 * 2
    }

    //展开
    @IBAction func expandBtnAction(_ sender: UIButton) {
        let totalHeight = table.tableTotalHeight
        self.containerViewHeight.constant = totalHeight + 10 * 2
        self.expandBtn.isHidden = true
    }
    
}
