//
//  FileManageAdapter.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/9/24.
//

/**
 文件管理适配器
 主要处理从外部打开一个文件，或者使用外部App打开本地文件，以及手动打开一个外部文件
 */
import UIKit
import UniformTypeIdentifiers

class FileManageAdapter: OriginAdapter, SingletonProtocol
{
    typealias Singleton = FileManageAdapter
    
    //MARK: 属性
    //单例
    static let shared = FileManageAdapter()
    
    //打开app时携带的信息
    fileprivate var openInfo: OpenUrlInfo?
    
    
    //MARK: 方法
    //私有化初始化方法
    private override init()
    {
        super.init()
        
        self.addNotification()
    }
    
    override func copy() -> Any
    {
        return self
    }
    
    override func mutableCopy() -> Any
    {
        return self
    }
    
    fileprivate func addNotification()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActiveNotification(notification:)), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    //处理主动从文件App打开文件，此处示例为暂时保存到Documents文件夹
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
                    try? data.write(to: URL(fileURLWithPath: SandBoxAccessor.shared.getDocumentDir().appendingPathComponent(fileName)))
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
    //app已经获得焦点
    @objc func applicationDidBecomeActiveNotification(notification: Notification)
    {
        //处理fileUrl，如果有的话
        if let info = self.openInfo
        {
            let fileName = info.fileUrl.lastPathComponent    //包含扩展名的文件名
//            let displayName = info.fileUrl.deletingPathExtension().lastPathComponent   //文件名
//            let fileExt = info.fileUrl.pathExtension   //扩展名
            
            //如果是音乐文件，那么保存到iCloud的`Documents/Music/Song`文件夹
            if FileTypeName.isAudio(fileName)
            {
                if let songDir = iCloudAccessor.shared.getDir(.MusicSong)
                {
                    let fileUrl = songDir.appendingPathComponent(fileName)
                    if let fileData = try? Data(contentsOf: info.fileUrl)
                    {
                        iCloudAccessor.shared.createDocument(fileData, targetUrl: fileUrl) { succeed in
                            //删除源文件
                            SandBoxAccessor.shared.deletePath(info.fileUrl.path)
                            //处理完后清空
                            self.openInfo = nil
                        }
                    }
                }
                else
                {
                    //删除源文件
                    SandBoxAccessor.shared.deletePath(info.fileUrl.path)
                    //处理完后清空
                    self.openInfo = nil
                }
            }
            else    //其他文件目前先保存到本地`Documents`文件夹
            {
                let savePath = SandBoxAccessor.shared.getDocumentDir().appendingPathComponent(fileName)
                if let fileData = try? Data(contentsOf: info.fileUrl)
                {
                    try? fileData.write(to: URL(fileURLWithPath: savePath))
                    //删除源文件
//                    SandBoxAccessor.shared.deletePath(info.fileUrl.path)
                    //处理完后清空
                    self.openInfo = nil
                }
            }
        }
    }
    
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


//内部类型
extension FileManageAdapter: InternalType
{
    //打开app的信息结构体，包括url/options
    struct OpenUrlInfo {
        //打开此app时传递的fileUrl
        var fileUrl: URL
        //通过appdelegate打开时携带的信息
        var appOptions: [UIApplication.OpenURLOptionsKey : Any]?
        //通过scenedelegate打开时携带的信息
        var sceneOptions: UIScene.OpenURLOptions?
    }
    
}


//接口方法
extension FileManageAdapter: ExternalInterface
{
    ///从本地或者其他App打开一个文件，具体处理方法根据实际需求
    ///从隔空投送接收文件
    func dispatchFileUrl(_ fileUrl: URL, appOptions: [UIApplication.OpenURLOptionsKey : Any]? = nil, sceneOptions: UIScene.OpenURLOptions? = nil)
    {
        self.openInfo = OpenUrlInfo(fileUrl: fileUrl, appOptions: appOptions, sceneOptions: sceneOptions)
    }
    
    ///主动从本地文件App打开沙盒中的文件
    func openFile()
    {
        let vc = UIDocumentPickerViewController(documentTypes: FMUTIs.getUTIs(), in: .open)
        vc.delegate = self
        g_presentVC(vc)
    }
    
}
