//
//  iCloudDocument.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/9/23.
//


/**
 用来操作icloud中的文件
 */
import UIKit

class iCloudDocument: UIDocument
{
    //保存的数据
    var data: Data?
    
    
    ///保存文件时调用
    override func contents(forType typeName: String) throws -> Any {
        if let data = data {
            return data
        }
        return Data()
    }
    
    ///读取文件时调用
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        data = (contents as! Data)
    }
    
}
