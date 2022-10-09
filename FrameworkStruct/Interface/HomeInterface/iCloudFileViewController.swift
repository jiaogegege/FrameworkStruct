//
//  iCloudFileViewController.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/9/27.
//

/**
 icloud文件管理，测试用
 包括新增、删除、覆盖等
 */
import UIKit

class iCloudFileViewController: BasicTableViewController {
    //icloud适配器
    fileprivate lazy var ia: iCloudAccessor = {
        let ia = iCloudAccessor.shared
        ia.setFilter(FMUTIs.textGroup, opposite: false)
        ia.setSort(type: .name(false))
        return ia
    }()
    
    //icloud文件列表
    fileprivate var fileArray: [IADocumentSearchResult]?
    
    
    //MARK: 方法
    override class func getViewController() -> Self {
        getVC(from: gMainSB)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func createUI() {
        super.createUI()
        //导航栏上的按钮
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNewFile(sender:)))
        navigationItem.rightBarButtonItems = [addBtn]
    }
    
    override func configUI() {
        super.configUI()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseId)
    }
    
    override func initData() {
        refresh()
    }
    
    //随便创建一个文件，测试用
    @objc fileprivate func createNewFile(sender: UIBarButtonItem)
    {
        //弹框输入文件名，扩展名固定`.txt`
        AlertManager.shared.wantPresentAlert(title: "请输入文件名", needInput: true, inputPlaceHolder: "请输入文件名", usePlaceHolder: false, leftTitle: String.cancel, leftBlock: {
            
        }, rightTitle: String.confirm) { name in
            //获取到文件名后
            if let name = name
            {
                let fileName = FileTypeName.txt.fullName(name)
                self.ia.createDocument("测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容".toData()!, targetUrl: self.ia.getDocumentsDir()!, fileName: fileName) { success in
                    g_toast(text: success ? "创建文件成功" : "创建文件失败")
                    //刷新界面，网络有延迟
                    g_after(1) {
                        self.refresh()
                    }
                }
            }
        }
    }

}


//通知代理
extension iCloudFileViewController: DelegateProtocol
{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fileArray?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseId, for: indexPath)
        cell.textLabel?.text = fileArray?[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete  //删除操作
        {
            if let file = fileArray?[indexPath.row]
            {
                ia.deleteDocument(file.url) {[weak self] error in
                    g_toast(text: (error == nil ? "删除成功" : "删除失败"))
                    if error == nil //删除成功，刷新列表
                    {
                        //先删除本地的
                        self?.fileArray?.remove(at: indexPath.row)
                        self?.tableView.reloadData()
                        g_after(3.5) {
                            self?.refresh()
                        }
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let info = self.fileArray?[indexPath.row]
        {
            let vc = EditiCloudFileViewController.getViewController()
            vc.fileInfo = info
            push(vc)
        }
    }
    
}


//接口方法
extension iCloudFileViewController: ExternalInterface
{
    //刷新文件列表
    func refresh()
    {
        ia.queryDocuments {[weak self] files in
            self?.fileArray = files
            self?.tableView.reloadData()
        }
    }
    
}
