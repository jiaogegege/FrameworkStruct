//
//  AudioConst.swift
//  FrameworkStruct
//
//  Created by jggg on 2022/2/22.
//

/**
 声音资源相关定义
 */
import Foundation

//MARK: UNNotificationSoundName
extension UNNotificationSoundName
{
    ///可选自定义推送提示音，根据实际项目需求修改
    enum SoundName: String {
        case sound_搞怪 = "sound_搞怪.caf"
        case sound_蛐蛐叫 = "sound_蛐蛐叫.caf"
        case sound_竖琴铃声 = "sound_竖琴铃声.caf"
        case sound_烟花长爆 = "sound_烟花长爆.caf"
    }

}
