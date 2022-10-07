//
//  MPContainer.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/10/7.
//

/**
 音乐数据容器
 */
import UIKit

class MPContainer: OriginContainer
{
    //MARK: 属性
    //单例
    static let shared = MPContainer()
    
    
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


//内部类型
extension MPContainer: InternalType
{
    //数据对象的key
    enum MPDataKey: String {
        case iCloudLibrary                  //iCloud媒体库
        case localLibrary                   //本地媒体库
        case iTunesLibrary                  //iTunes媒体库
        
        case currentPlaylist                //当前播放列表
        case currentSong                    //当前播放歌曲
        case historySongs                   //历史播放歌曲
        case historyPlaylists               //历史播放列表
    }
    
}


//外部接口
extension MPContainer: ExternalInterface
{
    
}
