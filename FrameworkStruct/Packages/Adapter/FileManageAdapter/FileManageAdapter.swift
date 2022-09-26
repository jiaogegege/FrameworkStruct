//
//  FileManageAdapter.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/9/24.
//

/**
 文件管理适配器
 主要处理从外部打开一个文件，或者使用外部App打开本地文件
 */
import UIKit
import UniformTypeIdentifiers

class FileManageAdapter: OriginAdapter
{
    //MARK: 属性
    //单例
    static let shared = FileManageAdapter()
    
    
    //MARK: 方法
    //私有化初始化方法
    private override init()
    {
        super.init()
    }
    
    override func copy() -> Any
    {
        return self
    }
    
    override func mutableCopy() -> Any
    {
        return self
    }
    
    //处理从文件App打开文件
    fileprivate func processOpenFile(_ fileUrl: URL)
    {
        var fileData: Data?
        //获取文件安全访问权限
        let authozied = fileUrl.startAccessingSecurityScopedResource()
        if authozied
        {
            //通过文件协调器读取文件地址
            let fileCoordinator = NSFileCoordinator()
            fileCoordinator.coordinate(readingItemAt: fileUrl, options: [.withoutChanges], error: nil) { (newUrl) in
                let fileName = newUrl.lastPathComponent
                //读取文件协调器提供的新地址里的数据
                fileData = try? Data.init(contentsOf: newUrl, options: [.mappedIfSafe])
                if let data = fileData {
                    //获取到数据，暂时保存到本地沙盒
                    try? data.write(to: URL(fileURLWithPath: SandBoxAccessor.shared.getDocumentDirectory().appendingPathComponent(fileName)))
                }
            }
        }
        //停止安全访问权限
        fileUrl.stopAccessingSecurityScopedResource()
    }

}


//通知代理方法
extension FileManageAdapter: DelegateProtocol, UIDocumentPickerDelegate
{
    //取消选择文件
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
    }
    
    //选择了多个文件，iOS11，根据实际需求针对打开多个文件的情况进行处理，这里只做例子
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let url = urls.first
        {
            processOpenFile(url)
        }
    }
    
}


//接口方法
extension FileManageAdapter: ExternalInterface
{
    ///从本地或者其他App打开一个文件，具体处理方法根据实际需求
    func dispatchFileUrl(_ fileUrl: URL, appOptions: [UIApplication.OpenURLOptionsKey : Any]? = nil, sceneOptions: UIScene.OpenURLOptions? = nil)
    {
        //暂时写入Documents文件夹
        let fileName = fileUrl.lastPathComponent    //包含扩展名的文件名
//        let fileExt = fileUrl.pathExtension   //扩展名
//        let absFileName = fileUrl.deletingPathExtension().lastPathComponent   //文件名
        //保存的文件路径
        let savePath = SandBoxAccessor.shared.getDocumentDirectory().appendingPathComponent(fileName)
        if let fileData = try? Data(contentsOf: fileUrl)
        {
            try? fileData.write(to: URL(fileURLWithPath: savePath))
        }
    }
    
    ///主动从本地文件App打开沙盒中的文件
    func openFile()
    {
        let vc = UIDocumentPickerViewController(documentTypes: FMUTIs.getUTIs(), in: .open)
        vc.delegate = self
        g_presentVC(vc)
    }
    
}
