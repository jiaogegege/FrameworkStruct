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
    //文件、目录、文档
    case folder = "public.folder"
    case directory = "public.directory"
    case item = "public.item"
    case content = "public.content"
    case compositeContent = "public.composite-content"
    case diskImage = "public.disk-image"
    case archive = "public.archive"
    case data = "public.data"
    case symbolicLink = "public.symlink"
    case executable = "public.executable"
    case url = "public.url"
    case fileUrl = "public.file-url"
    //文本
    case text = "public.text"
    case plainText = "public.plain-text"
    case utf8PlainText = "public.utf8-plain-text"
    case utf16PlainText = "public.utf16-plain-text"
    case rtf = "public.rtf"
    case html = "public.html"
    case xml = "public.xml"
    case json = "public.json"
    case yaml = "public.yaml"
    //源代码
    case sourceCode = "public.source-code"
    case assembly = "public.assembly-source"
    case cHeader = "public.c-header"
    case c = "public.c-source"
    case oc = "public.objective-c-source"
    case swift = "public.swift-source"
    case cppHeader = "public.c-plus-plus-header"
    case cpp = "public.c-plus-plus-source"
    case ocpp = "public.objective-c-plus-plus-source"
    case script = "public.script"
    case javaScript = "com.netscape.javascript-source"
    case shell = "public.shell-script"
    case perl = "public.perl-script"
    case python = "public.python-script"
    case ruby = "public.ruby-script"
    case php = "public.php-script"
    //图像
    case image = "public.image"
    case jpeg = "public.jpeg"
    case tiff = "public.tiff"
    case gif = "com.compuserve.gif"
    case png = "public.png"
    case svg = "public.svg-image"
    case icns = "com.apple.icns"
    case bmp = "com.microsoft.bmp"
    case ico = "com.microsoft.ico"
    case raw = "public.camera-raw-image"
    case livePhoto = "com.apple.live-photo"
    case heif = "public.heif"
    case heic = "public.heic"
    case webP = "org.webmproject.webp"
    //音视频
    case volume = "public.volume"
    case audiovisualContent = "public.audiovisual-content"
    case audio = "public.audio"
    case mp3 = "public.mp3"
    case aiff = "public.aiff-audio"
    case wav = "com.microsoft.waveform-audio"
    case midi = "public.midi-audio"
    case playlist = "public.playlist"
    case m3uPlaylist = "public.m3u-playlist"
    case appleProtectedMpeg4Audio = "com.apple.protected-mpeg-4-audio"
    case appleProtectedMpeg4Video = "com.apple.protected-mpeg-4-video"
    case mpeg4Audio = "public.mpeg-4-audio"
    case mpeg4 = "public.mpeg-4"
    case movie = "public.movie"
    case video = "public.video"
    case quickTime = "com.apple.quicktime-movie"
    case mpeg = "public.mpeg"
    case mpeg2Video = "public.mpeg-2-video"
    case mpeg2TransportStream = "public.mpeg-2-transport-stream"
    case avi = "public.avi"
    //文档
    case gzip = "org.gnu.gnu-zip-archive"
    case bz2 = "public.bzip2-archive"
    case zip = "public.zip-archive"
    case spreadSheet = "public.spreadsheet"
    case presentation = "public.presentation"
    case database = "public.database"
    case pdf = "com.adobe.pdf"
    case threeDContent = "public.3d-content"
    case usd = "com.pixar.universal-scene-description"
    case usdz = "com.pixar.universal-scene-description-mobile"
    //Apple
    case appleScript = "com.apple.applescript.text"
    case resolvable = "com.apple.resolvable"
    case appleMail = "com.apple.mail.emlx"
    case aliasFile = "com.apple.alias-file"
    case keynoteKey = "com.apple.keynote.key"
    case appleBookmark = "com.apple.bookmark"
    case propertyList = "com.apple.property-list"
    case rtfd = "com.apple.rtfd"
    case webArchive = "com.apple.webarchive"
    case package = "com.apple.package"
    case bundle = "com.apple.bundle"
    case framework = "com.apple.framework"
    case application = "com.apple.application"
    case applicationBundle = "com.apple.application-bundle"
    case applicationExtension = "com.apple.application-and-system-extension"
    case unixExecutable = "public.unix-executable"
    case appleArchive = "com.apple.archive"
    case appleScene = "com.apple.scenekit.scene"
    case appleAR = "com.apple.arobject"
    case realityFile = "com.apple.reality"
    //Microsoft
    case doc = "com.microsoft.word.doc"
    case xls = "com.microsoft.excel.xls"
    case ppt = "com.microsoft.powerpoint.ppt"
    case exe = "com.microsoft.windows-executable"
    //网络
    case message = "public.message"
    case contact = "public.contact"
    case vCard = "public.vcard"
    case todoItem = "public.to-do-item"
    case calendarEvent = "public.calendar-event"
    case emailMessage = "public.email-message"
    case internetLocation = "com.apple.internet-location"
    case font = "public.font"
    case bookmark = "public.bookmark"
    case epub = "org.idpf.epub-container"
    case log = "public.log"
    
    
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
