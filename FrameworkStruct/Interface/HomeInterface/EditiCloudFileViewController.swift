//
//  EditiCloudFileViewController.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/9/28.
//

import UIKit

class EditiCloudFileViewController: BasicViewController {
    
    //文件信息
    var fileInfo: IADocumentSearchResult?
    
    fileprivate lazy var ia: iCloudAccessor = iCloudAccessor.shared
    
    //打开文件的id
    fileprivate var fileId: iCloudAccessor.IADocumentHandlerType?
    
    //UI组件
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    
    
    //MARK: 方法
    override class func getViewController() -> Self {
        getVC(from: gMainSB)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initData() {
        if let fileInfo = fileInfo {
            ia.openDocument(fileInfo.url) {[weak self] id in
                if let id = id
                {
                    self?.fileId = id
                    self?.textView.text = self?.ia.readDocument(id)?.toString()
                }
            }
        }
    }
    
    @IBAction func cancelAction(_ sender: UIButton?) {
        textView.resignFirstResponder()
        pop()
    }
    
    //保存文本
    @IBAction func confirmAction(_ sender: UIButton) {
        textView.resignFirstResponder()
        if let data = self.textView.text.toData()
        {
            ia.writeDocument(self.fileId!, data: data) { success in
                g_toast(text: success ? "保存成功" : "保存失败")
                //关闭文件并退出
                if success
                {
                    self.cancelAction(nil)
                }
            }
        }
    }
    
}


extension EditiCloudFileViewController: DelegateProtocol, UITextViewDelegate
{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == String.sNewline
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

}
