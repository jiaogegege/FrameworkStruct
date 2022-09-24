//
//  FileManageConst.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/9/24.
//

import Foundation

///支持的UTIs
enum FMUTIs: String, CaseIterable
{
    case publicArchive = "public.archive"
    case publicData = "public.data"
    case publicText = "public.text"
    case publicImage = "public.image"
    case publicSourceCode = "public.source-code"
    case publicAudiovisualContent = "public.audiovisual-content"
    case pdf = "com.adobe.pdf"
    case keynoteKey = "com.apple.keynote.key"
    case msdoc = "com.microsoft.word.doc"
    case msxls = "com.microsoft.excel.xls"
    case msppt = "com.microsoft.powerpoint.ppt"
    
    //获取一个utis数组
    static func getUTIs() -> [String]
    {
        Self.allCases.map { uti in
            uti.rawValue
        }
    }
}
