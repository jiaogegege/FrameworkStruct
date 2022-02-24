//
//  NotificationAdapter.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/2/20.
//

/**
 * 系统推送通知适配器
 * 1. 本地推送
 * 2. 远程推送
 * 3. 推送action、category定制
 * 4. 自定义推送UI，未开发...
 */
import UIKit
import UserNotifications
import UserNotificationsUI
import CoreLocation


///推送通知适配器代理方法
protocol NotificationAdapterDelegate
{
    ///申请权限结果
    func notificationAdapterDidFinishAuthorization(isGranted: Bool)
    
    ///申请权限错误
    func notificationAdapterDidAuthorizationError(error: Error)
    
    ///用户点击了某个通知进入app
    func notificationAdapterDidClickNotification(notification: UNNotification)
    
    ///用户划掉了通知
    func notificationAdapterDidDismissNotification(notification: UNNotification)
    
    ///用户在通知中回复了一条消息，根据action category设计
    func notificationAdapterDidReplyMessage(notification: UNNotification, text: String)
    
    ///用户在通知中点击了确定，根据action category设计
    func notificationAdapterDidClickConfirm(notification: UNNotification)
    
    ///用户在通知中点击了取消，根据action category设计
    func notificationAdapterDidClickCancel(notification: UNNotification)
    
}

class NotificationAdapter: OriginAdapter
{
    //MARK: 属性
    //单例
    static let shared = NotificationAdapter()
    
    ///代理对象
    var delegate: NotificationAdapterDelegate?
    
    //通知中心
    fileprivate var notificationCenter: UNUserNotificationCenter {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        return center
    }
    
    //权限申请结果
    fileprivate var isGranted: Bool = false
    
    
    //MARK: 方法
    //私有化初始化方法
    private override init()
    {
        super.init()
        self.authorize()
    }
    
    override func copy() -> Any
    {
        return self
    }
    
    override func mutableCopy() -> Any
    {
        return self
    }
    
    //申请通知权限
    fileprivate func authorize()
    {
        //请求通知权限，申请的类型options可修改，根据实际需求使用
        self.notificationCenter.requestAuthorization(options: [.alert, .badge, .sound, .carPlay, .providesAppNotificationSettings]) {[weak self] (isGranted, error) in
            //根据权限申请结果采取不同的操作
            //不管有没有错误都将申请结果传出去
//            FSLog("Notification Permission Granted:\(isGranted)")
            self?.isGranted = isGranted
            if let delegate = self?.delegate {
                delegate.notificationAdapterDidFinishAuthorization(isGranted: isGranted)
            }
            if isGranted
            {
                NAActionCategoryType.registerNotificationCategory(center: self!.notificationCenter)
                self?.registerForRemoteNotification()
            }
            
            if let error = error {
                //如果申请通知权限错误
                FSLog("request notification auth error: \(error.localizedDescription)")
                //将错误传出去
                if let delegate = self?.delegate {
                    delegate.notificationAdapterDidAuthorizationError(error: error)
                }
            }
        }
    }
    
    //注册远程推送
    fileprivate func registerForRemoteNotification()
    {
        #if targetEnvironment(simulator)
//        FSLog("Simulator don't support remote notification")
        #else
        g_async {
            ApplicationManager.shared.app.registerForRemoteNotifications()
        }
        #endif
    }
    
    //根据url或文件名获取附件
    //attachment：本地文件名或者url地址
    //options:UNNotificationAttachmentOptionsTypeHintKey（附件类型:kUTTypeJPEG，默认从扩展名推测）/UNNotificationAttachmentOptionsThumbnailHiddenKey（是否隐藏附件缩略图，默认NO）/UNNotificationAttachmentOptionsThumbnailClippingRectKey（附件剪切rect,rect范围0-1）/UNNotificationAttachmentOptionsThumbnailTimeKey（动图或视频预览帧或秒数）
    fileprivate func getNotificationAttachment(attachment: NAAttachmentType, options: Dictionary<String, Any>?) -> UNNotificationAttachment?
    {
        guard let url = attachment.getUrl() else {
            return nil
        }
        do {
            let attachment = try UNNotificationAttachment(identifier: attachment.getId(), url: url, options: options)
            return attachment
        } catch {
            FSLog("attachment error: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    //处理action category响应，根据action category设计
    fileprivate func handleActionCategory(response: UNNotificationResponse)
    {
        let notification = response.notification
        let request = notification.request
        let content = request.content
        let actionIdentifier = response.actionIdentifier    //用户处理通知的动作
        let categoryIdentifier = content.categoryIdentifier     //action类别id
        //根据action category做一些操作
        switch categoryIdentifier {
        case NAActionCategoryType.replyMsg.getId(): //回复消息
            //获取通知中的消息
            if response.isKind(of: UNTextInputNotificationResponse.self)
            {
                //获取输入内容，传出去
                let text = (response as! UNTextInputNotificationResponse).userText
                if let delegate = delegate
                {
                    delegate.notificationAdapterDidReplyMessage(notification: notification, text: text)
                }
            }
        case NAActionCategoryType.confirmCancel.getId():    //确定取消
            if actionIdentifier == NAActionType.confirm.getId() //点击确定
            {
                if let delegate = delegate
                {
                    delegate.notificationAdapterDidClickConfirm(notification: notification)
                }
            }
            else if actionIdentifier == NAActionType.cancel.getId() //点击取消
            {
                if let delegate = delegate
                {
                    delegate.notificationAdapterDidClickCancel(notification: notification)
                }
            }
        default:
            break
        }
    }
}


//代理方法
extension NotificationAdapter: DelegateProtocol, UNUserNotificationCenterDelegate
{
    //当应用在前台时，收到通知会触发这个代理方法;在展示通知前进行处理，即有机会在展示通知前再修改通知内容
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        //1. 处理通知
//        let userInfo = notification.request.content.userInfo
//        let request = notification.request
//        let content = request.content
//        let badge = content.badge
//        let body = content.body
//        let title = content.title
//        let subtitle = content.subtitle
//        let sound = content.sound
//        if let ret = request.trigger?.isKind(of: UNPushNotificationTrigger.self), ret == true
//        {
//            //远程推送
//        }
//        else
//        {
//            //本地推送
//        }
        
        //2. 处理完成后调用 completionHandler ，用于指示在前台显示通知的形式
        if #available(iOS 14.0, *)
        {
            completionHandler([.badge, .sound, .list, .banner])
        }
        else
        {
            completionHandler([.badge, .sound, .alert])
        }
    }
    
    //当用户点击了通知中心，打开app，清除通知等操作之后的回调方法
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        //清除已触发的通知
        self.getDeliveredNotifications {[weak self] (notifications) in
            let count = notifications.count
            self?.removeAllDeliveredNotifications()
            g_async {
                ApplicationManager.shared.app.applicationIconBadgeNumber -= count
            }
        }

        let notification = response.notification
//        let userInfo = notification.request.content.userInfo
//        let request = notification.request
//        let content = request.content
//        let badge = content.badge
//        let body = content.body
//        let title = content.title
//        let subtitle = content.subtitle
//        let sound = content.sound
        let actionIdentifier = response.actionIdentifier    //用户处理通知的动作
//        let categoryIdentifier = content.categoryIdentifier     //action类别id
//        if let ret = request.trigger?.isKind(of: UNPushNotificationTrigger.self), ret == true
//        {
//            //远程推送
//        }
//        else
//        {
//            //本地推送
//        }
        
        //根据点击或取消执行动作
        if actionIdentifier == UNNotificationDefaultActionIdentifier
        {
            //用户点击了通知
            if let delegate = delegate
            {
                //将点击事件和通知数据传出去
                delegate.notificationAdapterDidClickNotification(notification: notification)
            }
        }
        else if actionIdentifier == UNNotificationDismissActionIdentifier
        {
            //用户划掉了通知
            if let delegate = delegate
            {
                delegate.notificationAdapterDidDismissNotification(notification: notification)
            }
        }
        else    //自定义动作id
        {
            //留给`handleActionCategory`处理
//            self.handleActionCategory(response: response)
        }
        
        self.handleActionCategory(response: response)
        
        completionHandler()
    }
    
    //当用户在通知中心左滑某个通知选择设置时，会调用这个方法，从“设置”打开时，`notification`将为nil
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?)
    {
        
    }
    
}


//内部类型
extension NotificationAdapter: InternalType
{
    ///提示音类型
    enum NASoundType
    {
        case `default`  //系统默认提示音
        case custom(UNNotificationSoundName.SoundName)   //自定义普通提示音，name：音频名
        case critical(UNNotificationSoundName.SoundName? = nil)   //重要信息提示音，name为nil则返回系统默认
        
        ///返回提示音
        func getSound() -> UNNotificationSound
        {
            switch self {
            case .default:
                return UNNotificationSound.default
            case .custom(let name):
                return UNNotificationSound(named: UNNotificationSoundName(name.rawValue))
            case .critical(let name):
                if let name = name
                {
                    return UNNotificationSound.criticalSoundNamed(UNNotificationSoundName(name.rawValue))
                }
                else
                {
                    return UNNotificationSound.defaultCritical
                }
            }
        }
    }

    ///附件类型
    enum NAAttachmentType
    {
        case local(String)  //本地bundle文件
        case remote(String) //网络资源
        
        //获取url
        func getUrl() -> URL?
        {
            switch self {
            case .local(let fileName):
                if fileName.contains(".")
                {
                    let arr = fileName.components(separatedBy: ".")
                    guard let path = Bundle.main.path(forResource: arr.first, ofType: arr.last) else {
                        return URL(fileURLWithPath: fileName)
                    }
                    return URL(fileURLWithPath: path)
                }
                else
                {
                    guard let path = Bundle.main.path(forResource: fileName, ofType: nil) else {
                        return nil
                    }
                    return URL(fileURLWithPath: path)
                }
            case .remote(let urlStr):
                return URL(string: urlStr)
            }
        }
        
        //获取资源id
        func getId() -> String
        {
            switch self {
            case .local(let fileName):
                return "FS_" + g_uuidString() + "_" + fileName
            case .remote(let urlStr):
                return "FS_" + g_uuidString() + "_" + urlStr
            }
        }
    }
    
    ///通知触发方式
    enum NATriggerType
    {
        case after(TimeInterval, Bool)    //延时触发，是否重复
        case date(DateComponents, Bool)             //固定日期触发，DateComponents根据需要定制，比如每小时重复(minute/second)、每天重复(hour/minute)、每周重复(weakday/hour)、每月重复(month/day)等；是否重复
        case location(Double, Double, Double, Bool, Bool, Bool)   //进入或离开某个区域触发，参数：latitude(纬度)/longitude(经度)/radius(半径)/进入区域是否提醒/离开区域是否提醒，是否重复
        
        ///获取触发器
        func getTrigger() -> UNNotificationTrigger
        {
            switch self {
            case .after(let inter, let repeats):
                return UNTimeIntervalNotificationTrigger(timeInterval: inter, repeats: repeats)
            case .date(let da, let repeats):
                return UNCalendarNotificationTrigger(dateMatching: da, repeats: repeats)
            case .location(let latitude, let longitude, let radius, let enter, let exit, let repeats):
                let center = CLLocationCoordinate2DMake(latitude, longitude)
                let region = CLCircularRegion(center: center, radius: radius, identifier: "FS_location_\(latitude)_\(longitude)_\(radius)")
                region.notifyOnEntry = enter
                region.notifyOnExit = exit
                return UNLocationNotificationTrigger(region: region, repeats: repeats)
            }
        }
    }
    
    ///通知action所有类型，根据实际需求定义
    ///有可能某一个action出现在多个category中，所以判断的时候要先判断category在判断action
    enum NAActionType
    {
        case input(String, String, String)  //有一个输入框和一个按钮，参数：title/placeholder/inputBtnTitle
        case button(String)     //有一个普通按钮，参数：buttonTitle
        case confirm        //确定按钮，参数：buttonConfirm
        case cancel     //取消按钮，参数：buttonCancel
        
        //获取action的id
        func getId() -> String
        {
            switch self {
            case .input(_, _, _):
                return "action.input"
            case .button(_):
                return "action.normalButton"
            case .confirm:
                return "action.confirm"
            case .cancel:
            return "action.cancel"
            }
        }

        //获取action
        func getAction(options: UNNotificationActionOptions) -> UNNotificationAction
        {
            switch self {
            case .input(let title , let placeholder, let btnTitle):
                return UNTextInputNotificationAction(identifier: self.getId(), title: title, options: options, textInputButtonTitle: btnTitle, textInputPlaceholder: placeholder)
            case .button(let btnTitle):
                return UNNotificationAction(identifier: self.getId(), title: btnTitle, options: options)
            case .confirm:
                return UNNotificationAction(identifier: self.getId(), title: String.confirm, options: options)
            case .cancel:
                return UNNotificationAction(identifier: self.getId(), title: String.cancel, options: options)
            }
        }
    }
    
    ///通知action category分组
    ///具体的分组要根据实际需求设计，每一个分组只能针对某一个特定的功能，不能一个分组对应多个功能，比如：`replyMsg`只能用作回复消息，而不能又用来输入备忘录，如果要输入备忘录，应该新建一个分组
    enum NAActionCategoryType
    {
        case replyMsg   //回复消息
        case confirmCancel  //确定取消
        
        //获取id
        func getId() -> String
        {
            switch self {
            case .replyMsg:
                return "action.category.replyMsg"
            case .confirmCancel:
                return "action.category.confirmCancel"
            }
        }
        
        //获得对应category，具体参数根据实际需求设置
        func getCatetory() -> UNNotificationCategory
        {
            switch self {
            case .replyMsg:
                let input = NAActionType.input(String.newMsg, String.inputMessage, String.send).getAction(options: [.authenticationRequired])
                return UNNotificationCategory(identifier: self.getId(), actions: [input], intentIdentifiers: [], options: [.customDismissAction])
            case .confirmCancel:
                let confirm = NAActionType.confirm.getAction(options: [.authenticationRequired, .foreground])
                let cancel = NAActionType.cancel.getAction(options: [.authenticationRequired, .foreground])
                return UNNotificationCategory(identifier: self.getId(), actions: [confirm, cancel], intentIdentifiers: [], options: [.customDismissAction, .allowInCarPlay, .hiddenPreviewsShowTitle, .hiddenPreviewsShowSubtitle])
            }
        }
        
        
        //注册通知类别，新增category的枚举类型后，需要在这里注册
        //Apple 引入了可以交互的通知，这是通过将一簇 action 放到一个 category 中，将这个 category 进行注册，最后在发送通知时将通知的 category 设置为要使用的 category 来实现的
        static func registerNotificationCategory(center: UNUserNotificationCenter)
        {
            center.setNotificationCategories([NAActionCategoryType.replyMsg.getCatetory(), NAActionCategoryType.confirmCancel.getCatetory()])
        }
    }
    
}


//接口方法
extension NotificationAdapter: ExternalInterface
{
    ///是否允许推送通知
    var canPush: Bool {
        return self.isGranted
    }
    
    ///获取到远程推送token，在AppDelegate中调用这个方法，在这里可以对接第三方推送服务
    func registerForRemoteNotificationWithToken(_ token: Data)
    {
        
    }
    
    ///注册远程推送失败
    func registerForRemoteNotificationFail(_ error: Error)
    {
        //如果失败做一些处理
        
    }
    
    ///创建一个本地推送通知
    ///参数：
    ///title：标题；subtitle：副标题；body：内容主体；
    ///sound：提示音；imageName：图片内容；audioName：音频内容；videoName：视频内容；
    ///attachmentOptions:UNNotificationAttachmentOptionsTypeHintKey（附件类型:kUTTypeJPEG，默认从扩展名推测）/UNNotificationAttachmentOptionsThumbnailHiddenKey（是否隐藏附件缩略图，默认NO）/UNNotificationAttachmentOptionsThumbnailClippingRectKey（附件剪切rect,rect范围0-1）/UNNotificationAttachmentOptionsThumbnailTimeKey（动图或视频预览帧或秒数）
    ///launchImageName：点击通知启动图(本地图片)
    ///trigger:通知触发方式
    ///identifier:目前identifier是一个随机字符串，如果需要记录相关信息，那么根据需求定义并记录
    ///completion:添加通知完成的操作
    func createLocalNotification(title: String, subtitle: String? = nil, body: String,
                                 sound: NASoundType = .default,
                                 imageName: NAAttachmentType? = nil,
                                 audioName: NAAttachmentType? = nil,
                                 videoName: NAAttachmentType? = nil,
                                 attachmentOptions: Dictionary<String, Any>? = nil,
                                 category: NAActionCategoryType? = nil,
                                 launchImageName: String? = nil,
                                 trigger: NATriggerType,
                                 identifier: String = g_uuidString(),
                                 completion: ((_ error: Error?) -> Void)? = nil)
    {
        //判断是否可以使用推送
        guard canPush else {
            let err = FSError.noPushError
//            FSLog("push notification: \(err.localizedDescription)")
            if let comp = completion
            {
                
                comp(err)
            }
            return
        }
        
        let content = UNMutableNotificationContent()
        //标题
        content.title = NSString.localizedUserNotificationString(forKey: title, arguments: nil)
        //副标题
        if let subtitle = subtitle
        {
            content.subtitle = NSString.localizedUserNotificationString(forKey: subtitle, arguments: nil)
        }
        //内容主体
        content.body = NSString.localizedUserNotificationString(forKey: body, arguments: nil)
        //提示音
        content.sound = sound.getSound()
        //数字标
        content.badge = NSNumber(value: ApplicationManager.shared.app.applicationIconBadgeNumber + 1)
        //处理附件
        var attachmentArr = [UNNotificationAttachment]()
        //如果有图片
        if let imageName = imageName
        {
            if let atta = self.getNotificationAttachment(attachment: imageName, options: attachmentOptions) {
                attachmentArr.append(atta)
            }
        }
        //如果有音频
        if let audioName = audioName
        {
            if let atta = self.getNotificationAttachment(attachment: audioName, options: attachmentOptions) {
                attachmentArr.append(atta)
            }
        }
        //如果有视频
        if let videoName = videoName
        {
            if let atta = self.getNotificationAttachment(attachment: videoName, options: attachmentOptions) {
                attachmentArr.append(atta)
            }
        }
        content.attachments = attachmentArr //添加附件，大部分情况只有一个附件
        //动作类别
        if let category = category
        {
            content.categoryIdentifier = category.getId()
        }
        //点击通知启动app时显示的启动图
        if let launchImg = launchImageName {
            content.launchImageName = launchImg
        }
        //触发方式
        let trigger = trigger.getTrigger()
        //通知请求
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.add(request) { (error) in
            if let error = error
            {
                FSLog("add local notification error: \(error.localizedDescription)")
            }
            if let comp = completion
            {
                comp(error)
            }
        }
    }
    
    ///发送一个本地文本通知，提供触发日期
    func pushLocalTextNotification(title: String, text: String, pushDate: DateComponents, repeats: Bool = false)
    {
        self.createLocalNotification(title: title, subtitle: nil, body: text, sound: .default, imageName: nil, audioName: nil, videoName: nil, attachmentOptions: nil, category: nil, launchImageName: nil, trigger: .date(pushDate, repeats), completion: nil)
    }
    
    ///获取所有未触发通知请求
    func getAllPendingRequests(completion: @escaping ([UNNotificationRequest]) -> Void)
    {
        self.notificationCenter.getPendingNotificationRequests(completionHandler: completion)
    }
    
    ///删除指定的未触发通知请求
    func removePendingRequests(ids: [String])
    {
        self.notificationCenter.removePendingNotificationRequests(withIdentifiers: ids)
    }
    
    ///删除所有未触发通知
    func removeAllPendingRequests()
    {
        self.notificationCenter.removeAllPendingNotificationRequests()
    }
    
    ///获取已触发通知
    func getDeliveredNotifications(completion: @escaping ([UNNotification]) -> Void)
    {
        self.notificationCenter.getDeliveredNotifications(completionHandler: completion)
    }
    
    ///删除指定的已触发通知
    func removeDeliveredNotifications(ids: [String])
    {
        notificationCenter.removeDeliveredNotifications(withIdentifiers: ids)
    }
    
    ///删除所有已触发通知
    func removeAllDeliveredNotifications()
    {
        notificationCenter.removeAllDeliveredNotifications()
    }
    
}
