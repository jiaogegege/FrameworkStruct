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


extension FSNotification
{
    //媒体库初始化完成的通知
    static let containerInitFinished = FSNotification(value: "containerInitFinished")
}

class MPContainer: OriginContainer
{
    //MARK: 属性
    //单例
    static let shared = MPContainer()
    
    //沙盒存取器
    fileprivate lazy var sb = SandBoxAccessor.shared
    
    //icloud存取器
    fileprivate lazy var ia: iCloudAccessor = {
        let ia = iCloudAccessor.shared
        return ia
    }()

    
    //MARK: 方法
    //私有化初始化方法
    private override init()
    {
        super.init()
        self.initLibrary()
    }
    
    override func copy() -> Any
    {
        return self
    }
    
    override func mutableCopy() -> Any
    {
        return self
    }
    
    //初始化媒体库列表
    fileprivate func initLibrary()
    {
        //尝试获取保存在icloud上的媒体库文件，包含一个媒体库列表
        if let libDir = ia.getMusicLibrary()
        {
            let libFileUrl = ia.getFileUrl(in: libDir, fileName: Self.libraryFileName)
            if sb.isExist(libFileUrl.path)
            {
                //如果存在媒体库文件，那么尝试打开
                ia.openDocument(libFileUrl) {[weak self] handler in
                    if let had = handler
                    {
                        //读取文件
                        if let data = self?.ia.readDocument(had)
                        {
                            //序列化data为MPMediaLibraryModel数组
                            if let arr = ArchiverAdatper.shared.unarchive(data) as? [MPMediaLibraryModel]
                            {
                                //更新媒体库，目前只有iCloud
                                self?.updateLibrary(arr, completion: { newLibs in
                                    self?.mutate(key: MPDataKey.librarys, value: newLibs)
                                    //写入iCloud文件
                                    if let data = ArchiverAdatper.shared.archive(newLibs as NSCoding)
                                    {
                                        self?.ia.writeDocument(had, data: data, completion: { success in
                                            NotificationCenter.default.post(name: FSNotification.containerInitFinished.name, object: nil)
                                        })
                                    }
                                })
                            }
                        }
                    }
                }
            }
            else    //如果媒体库文件不存在，那么尝试读取所有iCloud中的歌曲
            {
                queryAlliCloudSongs {[weak self] songs in
                    //创建一个iCloud媒体库
                    let iCloudLib = MPMediaLibraryModel(type: .iCloud, songs: songs, albums: [], artists: [], lyrics: [], musicbooks: [])
                    self?.mutate(key: MPDataKey.librarys, value: [iCloudLib])
                    //写入iCloud文件
                    if let data = ArchiverAdatper.shared.archive([iCloudLib] as NSCoding)
                    {
                        self?.ia.createDocument(data, targetUrl: libFileUrl)
                        NotificationCenter.default.post(name: FSNotification.containerInitFinished.name, object: nil)
                    }
                }
            }
        }
    }
    
    //update媒体库中的媒体，比如iCloud中有了新的歌曲，需要更新到媒体库中
    //目前只更新iCloud媒体库
    fileprivate func updateLibrary(_ originLibs: [MPMediaLibraryModel], completion: @escaping (([MPMediaLibraryModel]) -> Void))
    {
        for lib in originLibs {
            if lib.type == .iCloud
            {
                //查询所有iCloud中的歌曲
                queryAlliCloudSongs { songs in
                    //有新增歌曲则增加，有删除歌曲则减少
                    lib.diffSongs(songs)
                    completion(originLibs)
                }
            }
        }
    }
    
    //获取某一个媒体库
    fileprivate func getLibrary(_ type: MPLibraryType) -> MPMediaLibraryModel?
    {
        if let libs = self.get(key: MPDataKey.librarys) as? [MPMediaLibraryModel]
        {
            for lib in libs {
                if lib.type == type
                {
                    return lib
                }
            }
        }
        
        return nil
    }
    
    ///查询所有iCloud中的歌曲
    fileprivate func queryAlliCloudSongs(completion: @escaping ([MPSongModel]) -> Void)
    {
        ia.setFilter(files: FMUTIs.audioGroup, dirs: [.Music])
        ia.queryDocuments { files in
            let songs = files.map { file in
                MPSongModel(name: file.displayName, url: file.url)
            }
            completion(songs)
        }
    }
    
}


//内部类型
extension MPContainer: InternalType
{
    ///保存在icloud上的文件名
    //媒体库文件，媒体库对象列表，以`mplib`结尾
    static let libraryFileName = "library.mplib"
 
    //数据对象的key
    enum MPDataKey: String {
        case librarys                       //媒体库列表
        
        case currentSong                    //当前播放歌曲
        case currentPlaylist                //当前播放列表
        case historySongs                   //历史播放歌曲
        case historyPlaylists               //历史播放列表
    }
    
}


//外部接口
extension MPContainer: ExternalInterface
{
    ///获取iCloud库
    func getiCloudLibrary(_ completion: @escaping ((MPMediaLibraryModel) -> Void))
    {
        if let libs = self.get(key: MPDataKey.librarys) as? [MPMediaLibraryModel]
        {
            for lib in libs
            {
                if lib.type == .iCloud
                {
                    completion(lib)
                    return
                }
            }
        }
    }
    
}
