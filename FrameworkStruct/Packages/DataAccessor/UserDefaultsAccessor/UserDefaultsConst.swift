//
//  UserDefaultsConst.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/2/26.
//

import Foundation

///保存的数据的key列表
enum UDAKeyType: String {
    case deviceId                                   //设备唯一id，随机生成
    case lastRunVersion                             //App上一次启动时的版本号
    case runTimes                                   //App启动次数
    case currentTheme                               //当前主题key
    case calendarTitleList                          //本地创建的自定义日历标题数组
    case followDarkMode                             //是否跟随系统暗黑模式
}
