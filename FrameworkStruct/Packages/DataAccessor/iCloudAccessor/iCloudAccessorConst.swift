//
//  iCloudAccessorConst.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/9/23.
//

import Foundation



///可在icloud中保存的值的类型，都是基础类型
enum IAValueType {
    case string
    case bool
    case double
    case int
    case longlong
    case data
    case array
    case dict
}

///iCloud document目录预定义列表，根据实际需求修改
enum IADocumentDir: String {
    case Documents
    case Data = "Documents/Data"                                    //Documents下有一个Data文件夹
    case Text = "Documents/Text"                                    //Documents下有一个Text文件夹
    case Image = "Documents/Image"                                  //Documents下有一个Image文件夹
    case Music = "Documents/Music"                                  //Documents下有一个Music文件夹
    case MusicSong = "Documents/Music/Song"                         //Documents下有一个Music文件夹下有一个Song文件夹
    case MusicLyric = "Documents/Music/Lyric"                       //Documents下有一个Music文件夹下有一个Lyric文件夹
    case MusicLibrary = "Documents/Music/Library"                   //Documents下有一个Music文件夹下有一个Library文件夹
}

///可在icloud读写的value的key定义，根据实际需求定义
enum IAValueKey: String, CaseIterable {
    case appName
    case appVersion
    case mpProgress             //音乐播放器当前播放进度`TimeInterval`
    case mpPlayMode             //音乐播放器当前播放模式`Int`
    
    ///获取value，提供一种只能获得key的情况下快速获取value的方法，比如通知
    func getValue() -> Any?
    {
        iCloudAccessor.shared.getValue(self)
    }
}

///value变化的原因
enum IAValueChangeReason: Int {
    case unknown                    //未知原因，不可能出现
    
    case serverChange               //icloud中的值被其他设备修改发生变化
    case initialSyncChange          //如果该设备从未从icloud获取这个值，该设备尝试修改iCloud中的这个值
    case quotaViolationChange       //该app在iCloud中超过存储上限
    case accountChange              //用户改变了icloud账户，本地的值被新账户中的值代替
    
    init(rawValue: Int) {
        switch rawValue {
        case NSUbiquitousKeyValueStoreServerChange:
            self = .serverChange
        case NSUbiquitousKeyValueStoreInitialSyncChange:
            self = .initialSyncChange
        case NSUbiquitousKeyValueStoreQuotaViolationChange:
            self = .quotaViolationChange
        case NSUbiquitousKeyValueStoreAccountChange:
            self = .accountChange
        default:
            self = .unknown
        }
    }
}

///value变化通知产生的通知结构体
struct IAValueChangeModel {
    var key: IAValueKey
    var value: Any?
    var changeReasion: IAValueChangeReason
}

///Document查询结果
struct IADocumentSearchResult {
    var name: String            //kMDItemFSName
    var displayName: String     //kMDItemDisplayName
    var url: URL
    var path: String
    var size: Int64?            //kMDItemFSSize
    var createDate: Date        //kMDItemFSCreationDate
    var changeDate: Date        //kMDItemFSContentChangeDate
    var contentType: String     //kMDItemContentType
    var contentTypeTree: [String]?
    var isUbiquitous: Bool
    var hasUnresolvedConflicts: Bool
    var downloadingStatus: String   //NSMetadataUbiquitousItemDownloadingStatusNotDownloaded/NSMetadataUbiquitousItemDownloadingStatusDownloaded/NSMetadataUbiquitousItemDownloadingStatusCurrent
    var isDownloading: Bool
    var isUploaded: Bool
    var isUploading: Bool
    var percentDownloaded: Double?
    var percentUploaded: Double
    var downloadingError: NSError?
    var uploadingError: NSError?
    var downloadRequested: Bool
    var isExternalDocument: Bool
    var containerDisplayName: String
    var urlInLocalContainer: URL
    var isShared: Bool
    var currentUserRole: String?     //NSMetadataUbiquitousSharedItemRoleOwner/NSMetadataUbiquitousSharedItemRoleParticipant
    var currentUserPermissions: String?     //NSMetadataUbiquitousSharedItemPermissionsReadOnly/NSMetadataUbiquitousSharedItemPermissionsReadWrite
    var ownerNameComponents: PersonNameComponents?
    var mostRecentEditorNameComponents: PersonNameComponents?
    
    //初始化方法
    init(info: NSMetadataItem) {
        self.name = info.value(forAttribute: NSMetadataItemFSNameKey) as! String
        self.displayName = info.value(forAttribute: NSMetadataItemDisplayNameKey) as! String
        self.url = info.value(forAttribute: NSMetadataItemURLKey) as! URL
        self.path = info.value(forAttribute: NSMetadataItemPathKey) as! String
        self.size = info.value(forAttribute: NSMetadataItemFSSizeKey) as? Int64
        self.createDate = info.value(forAttribute: NSMetadataItemFSCreationDateKey) as! Date
        self.changeDate = info.value(forAttribute: NSMetadataItemFSContentChangeDateKey) as! Date
        self.contentType = info.value(forAttribute: NSMetadataItemContentTypeKey) as! String
        self.contentTypeTree = info.value(forAttribute: NSMetadataItemContentTypeTreeKey) as? [String]
        self.isUbiquitous = info.value(forAttribute: NSMetadataItemIsUbiquitousKey) as! Bool
        self.hasUnresolvedConflicts = info.value(forAttribute: NSMetadataUbiquitousItemHasUnresolvedConflictsKey) as! Bool
        self.downloadingStatus = info.value(forAttribute: NSMetadataUbiquitousItemDownloadingStatusKey) as! String
        self.isDownloading = info.value(forAttribute: NSMetadataUbiquitousItemIsDownloadingKey) as! Bool
        self.isUploaded = info.value(forAttribute: NSMetadataUbiquitousItemIsUploadedKey) as! Bool
        self.isUploading = info.value(forAttribute: NSMetadataUbiquitousItemIsUploadingKey) as! Bool
        self.percentDownloaded = info.value(forAttribute: NSMetadataUbiquitousItemPercentDownloadedKey) as? Double
        self.percentUploaded = info.value(forAttribute: NSMetadataUbiquitousItemPercentUploadedKey) as! Double
        self.downloadingError = info.value(forAttribute: NSMetadataUbiquitousItemDownloadingErrorKey) as? NSError
        self.uploadingError = info.value(forAttribute: NSMetadataUbiquitousItemUploadingErrorKey) as? NSError
        self.downloadRequested = info.value(forAttribute: NSMetadataUbiquitousItemDownloadRequestedKey) as! Bool
        self.isExternalDocument = info.value(forAttribute: NSMetadataUbiquitousItemIsExternalDocumentKey) as! Bool
        self.containerDisplayName = info.value(forAttribute: NSMetadataUbiquitousItemContainerDisplayNameKey) as! String
        self.urlInLocalContainer = info.value(forAttribute: NSMetadataUbiquitousItemURLInLocalContainerKey) as! URL
        self.isShared = info.value(forAttribute: NSMetadataUbiquitousItemIsSharedKey) as! Bool
        self.currentUserRole = info.value(forAttribute: NSMetadataUbiquitousSharedItemCurrentUserRoleKey) as? String
        self.currentUserPermissions = info.value(forAttribute: NSMetadataUbiquitousSharedItemCurrentUserPermissionsKey) as? String
        self.ownerNameComponents = info.value(forAttribute: NSMetadataUbiquitousSharedItemOwnerNameComponentsKey) as? PersonNameComponents
        self.mostRecentEditorNameComponents = info.value(forAttribute: NSMetadataUbiquitousSharedItemMostRecentEditorNameComponentsKey) as? PersonNameComponents
    }
}
