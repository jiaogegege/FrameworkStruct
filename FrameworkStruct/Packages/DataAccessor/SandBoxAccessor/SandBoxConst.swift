//
//  SandBoxConst.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/1/19.
//

import Foundation

//判断文件是否从本地沙盒或者文件App中打开的路径前缀
let sdFilePrefix = "file:///private"

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
    
    //根据传入的文件名字返回包含扩展名的文件名
    func fullName(_ name: String) -> String
    {
        if let fullName =  (name as NSString).appendingPathExtension(self.rawValue)
        {
            return fullName
        }
        else
        {
            return String(format: "%@.%@", name, self.rawValue)
        }
    }
}
