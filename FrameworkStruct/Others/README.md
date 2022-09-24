# 此处存放项目中其他一些配置文件

##  info.plist配置项说明

### 隐私项配置

相册
NSPhotoLibraryUsageDescription
相机
NSCameraUsageDescription
麦克风
NSMicrophoneUsageDescription
位置
NSLocationUsageDescription
在使用期间访问位置
NSLocationWhenInUseUsageDescription
始终访问位置
NSLocationAlwaysUsageDescription
日历
NSCalendarsUsageDescription
提醒事项
NSRemindersUsageDescription
运动与健身
NSMotionUsageDescription
健康更新
NSHealthUpdateUsageDescription
健康分享
NSHealthShareUsageDescription
蓝牙
NSBluetoothPeripheralUsageDescription
媒体资料库
NSAppleMusicUsageDescription
<key>NSAppleMusicUsageDescription</key>
<string>App需要您的同意,才能访问媒体资料库</string>
<key>NSBluetoothPeripheralUsageDescription</key>
<string>App需要您的同意,才能访问蓝牙</string>
<key>NSCalendarsUsageDescription</key>
<string>App需要您的同意,才能访问日历</string>
<key>NSCameraUsageDescription</key>
<string>App需要您的同意,才能访问相册</string>
<key>NSContactsUsageDescription</key>
<string>App需要您的同意,才能访问通信录</string>
<key>NSHealthShareUsageDescription</key>
<string>App需要您的同意,才能访问健康分享</string>
<key>NSHealthUpdateUsageDescription</key>
<string>App需要您的同意,才能访问健康更新 </string>
<key>NSLocationAlwaysUsageDescription</key>
<string>App需要您的同意,才能始终访问位置</string>
<key>NSLocationUsageDescription</key>
<string>App需要您的同意,才能访问位置</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>App需要您的同意,才能在使用期间访问位置</string>
<key>NSMicrophoneUsageDescription</key>
<string>App需要您的同意,才能访问麦克风</string>
<key>NSMotionUsageDescription</key>
<string>App需要您的同意,才能访问运动与健身</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>App需要您的同意,才能访问相机</string>
<key>NSRemindersUsageDescription</key>
<string>App需要您的同意,才能访问提醒事项</string>

### 支持iCloud文件共享

<key>NSUbiquitousContainers</key>
<dict>
    <key>iCloud.FrameworkStruct</key>
    <dict>
        <key>NSUbiquitousContainerIsDocumentScopePublic</key>
        <true/>
        <key>NSUbiquitousContainerName</key>
        <string>$(PRODUCT_NAME)</string>
        <key>NSUbiquitousContainerSupportedFolderLevels</key>
        <string>Any</string>
    </dict>
</dict>

### Document Types说明示例

<dict>

   <key>CFBundleTypeName</key>

   <string>My File Format</string>

   <key>CFBundleTypeIconFiles</key>

       <array>

           <string>MySmallIcon.png</string>

           <string>MyLargeIcon.png</string>

       </array>

   <key>LSItemContentTypes</key>

       <array>

           <string>com.example.myformat</string>

       </array>

   <key>LSHandlerRank</key>

   <string>Owner</string>

</dict>
