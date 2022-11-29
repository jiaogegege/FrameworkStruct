//
//  SandBoxConst.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/1/19.
//

import Foundation

//判断文件是否从本地沙盒或者文件App中打开的路径前缀
let sdFilePrefix = "file:///"

//MARK: 文件路径定义，以`sd`开头，表示`sandbox`缩写
//数据库文件路径
let sdDatabaseDir = "db"     //数据库相关文件存放目录
let sdDatabaseFile = "database.sqlite"   //数据库文件名
let sdDatabaseOriginSQLFile = "db_table.sql"    //创建数据库表结构文件名

//下载临时目录
let sdDownloadTempDir = "download_temp"

//沙盒中音频文件目录
let sdSoundsDir = "Sounds"


//文件扩展名列表，根据需要新增
enum FileTypeName: String {
    //文档
    case dat
    case txt
    case rtf
    case lrc
    case ass
    case md
    case doc
    case docx
    case ppt
    case pptx
    case xls
    case xlsx
    case pdf
    case mobi
    case epub
    //编程语言
    case h
    case c
    case cpp
    case m
    case mm
    case rs
    case go
    case swift
    case java
    case kt
    case cs
    case py
    case rb
    case sql
    case json
    case xml
    case html
    case css
    case js
    case ts
    case php
    //音频
    case aac
    case m4a
    case caf
    case mp3
    case opus
    case aiff
    case aif
    case wma
    case flac
    case ogg
    case wav
    case midi
    case ra
    //视频
    case mov
    case m4v
    case flv
    case mp4
    case mkv
    case mpv
    case avi
    case navi
    case wmv
    case rm
    case rmvb
    //图片
    case jpg
    case jpeg
    case png
    case gif
    case bmp
    case tiff
    case tif
    case svg
    case raw
    case webp
    case psd
    case ai
    case cdr
    //压缩文件
    case zip
    case rar
    case tar
    case ar
    case bz
    case car
    case gz
    case rz
    //数据库
    case sqlite
    case db
    
    //判断是否音乐文件
    static func isAudio(_ fileName: String) -> Bool
    {
        let fileStr = fileName.lowercased()
        if fileStr.hasSuffix(Self.mp3.rawValue) || fileStr.hasSuffix(Self.wma.rawValue) || fileStr.hasSuffix(Self.aac.rawValue) || fileStr.hasSuffix(Self.m4a.rawValue) || fileStr.hasSuffix(Self.aiff.rawValue) || fileStr.hasSuffix(Self.aif.rawValue) || fileStr.hasSuffix(Self.wav.rawValue) || fileStr.hasSuffix(Self.flac.rawValue) || fileStr.hasSuffix(Self.ogg.rawValue) || fileStr.hasSuffix(Self.caf.rawValue)
        {
            return true
        }
        return false
    }
    
    //根据传入的文件名字返回包含扩展名的文件名
    func fullName(_ name: String) -> String
    {
        if let fullName = (name as NSString).appendingPathExtension(self.rawValue)
        {
            return fullName
        }
        else
        {
            return String(format: "%@.%@", name, self.rawValue)
        }
    }
}


//文件信息
struct SBFileAttributes {
    var type: FileAttributeType?     //typeDirectory/typeRegular/typeSymbolicLink/typeSocket/typeCharacterSpecial/typeBlockSpecial/typeUnknown
    var size: UInt64?
    var modificationDate: Date?
    var referenceCount: Int?
    var deviceIdentifier: String?
    var ownerAccountName: String?
    var groupOwnerAccountName: String?
    var posixPermissions: Int?
    var systemNumber: Int?
    var systemFileNumber: Int?
    var extensionHidden: Bool?
    var hfsCreatorCode: OSType?
    var hfsTypeCode: OSType?
    var immutable: Bool?
    var appendOnly: Bool?
    var creationDate: Date?
    var ownerAccountID: NSNumber?
    var groupOwnerAccountID: NSNumber?
    var busy: Bool?
    var protectionKey: FileProtectionType?
    var systemSize: UInt64?
    var systemFreeSize: UInt64?
    var systemNodes: String?
    var systemFreeNodes: String?
    
    //从一个文件属性初始化
    init(fileAttrs: [FileAttributeKey : Any])
    {
        self.size = fileAttrs[.size] as? UInt64
        self.type = fileAttrs[.type] as? FileAttributeType
        self.modificationDate = fileAttrs[.modificationDate] as? Date
        self.referenceCount = fileAttrs[.referenceCount] as? Int
        self.deviceIdentifier = fileAttrs[.deviceIdentifier] as? String
        self.ownerAccountName = fileAttrs[.ownerAccountName] as? String
        self.groupOwnerAccountName = fileAttrs[.groupOwnerAccountName] as? String
        self.posixPermissions = fileAttrs[.posixPermissions] as? Int
        self.systemNumber = fileAttrs[.systemNumber] as? Int
        self.systemFileNumber = fileAttrs[.systemFileNumber] as? Int
        self.extensionHidden = fileAttrs[.extensionHidden] as? Bool
        self.hfsCreatorCode = fileAttrs[.hfsCreatorCode] as? OSType
        self.hfsTypeCode = fileAttrs[.hfsTypeCode] as? OSType
        self.immutable = fileAttrs[.immutable] as? Bool
        self.appendOnly = fileAttrs[.appendOnly] as? Bool
        self.creationDate = fileAttrs[.creationDate] as? Date
        self.ownerAccountID = fileAttrs[.ownerAccountID] as? NSNumber
        self.groupOwnerAccountID = fileAttrs[.groupOwnerAccountID] as? NSNumber
        self.busy = fileAttrs[.busy] as? Bool
        self.protectionKey = fileAttrs[.protectionKey] as? FileProtectionType
        self.systemSize = fileAttrs[.systemSize] as? UInt64
        self.systemFreeSize = fileAttrs[.systemFreeSize] as? UInt64
        self.systemNodes = fileAttrs[.systemNodes] as? String
        self.systemFreeNodes = fileAttrs[.systemFreeNodes] as? String
    }
}
