//
//  ArchiverAdapter.swift
//  FrameworkStruct
//
//  Created by jggg on 2022/10/6.
//

/**
 归档适配器
 用于处理自定义对象的归档和解档
 */
import UIKit

class ArchiverAdapter: OriginAdapter {
    //MARK: 属性
    //单例
    static let shared = ArchiverAdapter()
    
    
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
    
}


//接口方法
extension ArchiverAdapter: ExternalInterface
{
    ///将一个对象归档，返回Data
    ///secure：是否安全归档，如果为true，那么obj必须支持NSSecureCoding
    func archive(_ obj: NSCoding, secure: Bool = false) -> Data?
    {
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: obj, requiringSecureCoding: secure)
        } catch {
            FSLog(error.localizedDescription)
            return nil
        }
    }

    ///将一个对象归档，返回Data
    ///secure：是否安全归档，如果为true，那么obj必须支持NSSecureCoding
    func archive(_ obj: NSCoding, secure: Bool = false, completion: @escaping OptionalDataClosure)
    {
        g_async { queue in
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: obj, requiringSecureCoding: secure)
                queue.async {
                    completion(data)
                }
            } catch {
                FSLog(error.localizedDescription)
                queue.async {
                    completion(nil)
                }
            }
        }
    }
    
    ///将对象归档到一个文件
    func archiveToFile(_ obj: NSCoding, secure: Bool = false, fileUrl: URL, completion: BoolClosure? = nil)
    {
        g_async { queue in
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: obj, requiringSecureCoding: secure)
                try data.write(to: fileUrl)
                if let cb = completion
                {
                    queue.async {
                        cb(true)
                    }
                }
            } catch {
                FSLog(error.localizedDescription)
                if let cb = completion
                {
                    queue.async {
                        cb(false)
                    }
                }
            }
        }
    }
    
    ///将Data解档为一个对象
    func unarchive(_ data: Data) -> Any?
    {
        do {
            return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
        } catch {
            FSLog(error.localizedDescription)
            return nil
        }
    }
    
    ///将Data解档为一个对象
    func unarchive(_ data: Data, completion: @escaping OptionalAnyClosure)
    {
        g_async { queue in
            do {
                if let obj = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
                {
                    queue.async {
                        completion(obj)
                    }
                }
                else
                {
                    queue.async {
                        completion(nil)
                    }
                }
            } catch {
                FSLog(error.localizedDescription)
                queue.async {
                    completion(nil)
                }
            }
        }
    }
    
    ///从一个文件中解档为一个对象
    func unarchiveFromFile(_ fileUrl: URL, completion: @escaping OptionalAnyClosure)
    {
        g_async { queue in
            do {
                let data = try Data(contentsOf: fileUrl)
                if let obj = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
                {
                    queue.async {
                        completion(obj)
                    }
                }
                else
                {
                    queue.async {
                        completion(nil)
                    }
                }
            } catch {
                FSLog(error.localizedDescription)
                queue.async {
                    completion(nil)
                }
            }
        }
    }
    
}
