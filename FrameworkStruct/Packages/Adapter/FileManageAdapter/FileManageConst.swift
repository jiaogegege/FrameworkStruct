//
//  FileManageConst.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/9/24.
//

import Foundation
import UniformTypeIdentifiers

///支持的UTIs，可以添加更多，参考`UTType`或者UTIs官网
enum FMUTIs: String, CaseIterable
{
    case folder = "public.folder"
    case directory = "public.directory"
    case item = "public.item"
    case content = "public.content"
    case compositeContent = "public.composite-content"
    case diskImage = "public.disk-image"
    case archive = "public.archive"
    case data = "public.data"
    case symbolicLink = "public.symlink"
    case appleMail = "com.apple.mail.emlx"
    case vCard = "public.vcard"
    case executable = "public.executable"
    case appleBookmark = "com.apple.bookmark"
    case url = "public.url"
    case fileUrl = "public.file-url"
    case text = "public.text"
    case plainText = "public.plain-text"
    case utf8PlainText = "public.utf8-plain-text"
    case rtf = "public.rtf"
    case html = "public.html"
    case xml = "public.xml"
    case json = "public.json"
    case sourceCode = "public.source-code"
    case script = "public.script"
    case image = "public.image"
    case audiovisualContent = "public.audiovisual-content"
    case pdf = "com.adobe.pdf"
    case jpeg = "public.jpeg"
    case tiff = "public.tiff"
    case gif = "com.compuserve.gif"
    case png = "public.png"
    case svg = "public.svg-image"
    case keynoteKey = "com.apple.keynote.key"
    case msdoc = "com.microsoft.word.doc"
    case msxls = "com.microsoft.excel.xls"
    case msppt = "com.microsoft.powerpoint.ppt"
    
    //获取对应uti的UTType
    @available(iOS 14.0, *)
    func getType() -> UTType?
    {
        UTType(self.rawValue)
    }
    
    //获取所有的UTType列表
    @available(iOS 14.0, *)
    static func getTypes() -> [UTType]
    {
        var types: [UTType] = []
        for item in Self.allCases
        {
            if let it = item.getType()
            {
                types.append(it)
            }
        }
        return types
    }
    
    //获取一个UTIs数组
    static func getUTIs() -> [String]
    {
        Self.allCases.map { uti in
            uti.rawValue
        }
    }
}
