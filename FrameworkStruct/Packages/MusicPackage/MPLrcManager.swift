//
//  MPLrcManager.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/11/5.
//

/**
 歌词管理
 目前只支持自己下载然后上传到iCloud，注意文件名保持一致
 
 可参考的歌词搜索网站：
 https://www.gecimao.com/search/%E5%A4%95%E6%97%A5%E5%9D%82
 https://www.gecimao.com/search/夕日坂
 */
import UIKit

class MPLrcManager: OriginManager, SingletonProtocol
{
    typealias Singleton = MPLrcManager
    
    //MARK: 属性
    //单例
    static let shared = MPLrcManager()
    
    fileprivate lazy var ia = iCloudAccessor.shared
    fileprivate lazy var ra = RegexAdapter.shared
    
    
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
    
    //读取歌词文件内容并解析
    fileprivate func parseLyricData(_ data: Data, lrcFileUrl: URL, completion: @escaping OpGnClo<MPLyricModel>)
    {
        if let lrcContent = data.toString()
        {
            //先提取标题
            let title = ra.getSubStrIn(lrcContent, with: Self.titleReg).first
            //提取艺术家
            let artist = ra.getSubStrIn(lrcContent, with: Self.artistReg).first
            //专辑
            let album = ra.getSubStrIn(lrcContent, with: Self.albumReg).first
            //时间歌词数组
            var lrcArray: [LineLyricInfo] = []
            //先提取时间和歌词的所有行
            let contentArray = ra.getSubStrIn(lrcContent, with: Self.timeLrcReg, once: false)
            for item in contentArray    //遍历每一行，获取时间和歌词
            {
                let timeStr = ra.getSubStrIn(item, with: Self.timeReg).first
                let lrcStr = ra.getSubStrIn(item, with: Self.lyricReg).first
                //将时间字符串转换为秒
                let timeComp = timeStr?.components(separatedBy: String.sColon)
                if let minute = timeComp?.first, let second = timeComp?.last
                {
                    let totalTime: TimeInterval = (minute as NSString).doubleValue * tSecondsInMinute + (second as NSString).doubleValue
                    let lrcModel = LineLyricInfo(time: totalTime, timeStr: timeStr!, lyric: lrcStr)
                    lrcArray.append(lrcModel)
                }
            }
            let model = MPLyricModel(url: lrcFileUrl, title: title, artist: artist, album: album, lyrics: lrcArray)
            //返回对象
            completion(model)
        }
        else
        {
            completion(nil)
        }
    }
    
}


extension MPLrcManager: InternalType
{
    //提取歌词相关正则表达式
    static let titleReg: RegExp = "(?<=\\[ti:).*(?=\\])"           //标题
    static let artistReg: RegExp = "(?<=\\[ar:).*(?=\\])"          //艺术家
    static let albumReg: RegExp = "(?<=\\[al:).*(?=\\])"           //专辑
    static let timeLrcReg: RegExp = "\\[\\d.*(\n|\r)"                   //时间和歌词的一行
    static let timeReg: RegExp = "(?<=\\[).+(?=\\])"               //时间
    static let lyricReg: RegExp = "(?<=\\]).*(?=(\n|\r))"               //歌词
    
}


extension MPLrcManager: ExternalInterface
{
    ///获取解析好的歌词或字幕对象
    func getLyric(_ audio: MPAudioProtocol, completion: @escaping OpGnClo<MPLyricModel>)
    {
        //如果是iCloud中的歌曲文件，那么尝试从iCloud获取歌词文件
        if ia.isiCloudFile(audio.audioUrl)
        {
            let lrcFileName = FileTypeName.lrc.fullName(audio.audioName)   //歌词文件名
            if let lrcDir = ia.getMusicLyricDir()
            {
                let lrcFileUrl = ia.getFileUrl(in: lrcDir, fileName: lrcFileName)   //歌词文件url
                //读取文件内容并解析
                ia.openDocument(lrcFileUrl) {[weak self] handler in
                    if let handler = handler {
                        //打开文件成功，开始解析
                        if let data = self?.ia.readDocument(handler)
                        {
                            self?.parseLyricData(data, lrcFileUrl: lrcFileUrl, completion: { lyricModel in
                                if lyricModel?.title == nil
                                {
                                    lyricModel?.title = audio.audioName
                                }
                                completion(lyricModel)
                                //关闭文件
                                self?.ia.closeDocument(handler)
                            })
                        }
                        else
                        {
                            completion(nil)
                            //关闭文件
                            self?.ia.closeDocument(handler)
                        }
                    }
                    else
                    {
                        completion(nil)
                    }
                }
            }
            else
            {
                completion(nil)
            }
        }
        else    //不是icloud中的歌曲，暂时返回nil
        {
            completion(nil)
        }
    }
    
}
