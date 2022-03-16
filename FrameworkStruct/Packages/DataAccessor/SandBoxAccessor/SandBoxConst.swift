//
//  SandBoxConst.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/1/19.
//

import Foundation

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
    //文本
    case txt
    case rtf
    case md
    case json
    case xml
    //编程语言
    case h
    case c
    case cpp
    case m
    case mm
    case swift
    case java
    case py
    case sql
    case html
    case css
    case js
    //音频
    case aac
    case caf
    case mp3
    case wav
    //视频
    case mov
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
    
}
