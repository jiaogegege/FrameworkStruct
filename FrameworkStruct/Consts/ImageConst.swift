//
//  ImageConst.swift
//  FrameworkStruct
//
//  Created by  jggg on 2021/12/6.
//

/**
 * 定义各种资源图片
 */
import UIKit

extension UIImage: ConstantProtocol
{
    //MARK: 资源图片常量
    
    /**
     * 常量图片建议以`i`开头，表示`image`，方便区分
     */
    //app图标
    @objc static let iAppIcon:UIImage? = UIImage(named: "AppIcon")
    
    //tabbar图标
    static var iHomeNormal: UIImage? {
        UIImage(named: "home_normal")
    }
    static var iHomeSelected: UIImage? {
        UIImage(named: "home_selected")
    }
    static var iMineNormal: UIImage? {
        UIImage(named: "mine_normal")
    }
    static var iMineSelected: UIImage? {
        UIImage(named: "mine_selected")
    }
    
    //返回按钮图片
    @objc static var iBackDark: UIImage? {
        UIImage(named: "common_back_dark")
    }
    @objc static var iBackDarkAlways: UIImage? {
        UIImage(named: "common_back_dark_always")
    }
    @objc static var iBackLightAlways: UIImage? {
        UIImage(named: "common_back_light_always")
    }
    @objc static var iBackThinDarkAlways: UIImage? {
        UIImage(named: "common_back_thin_dark_always")
    }
    @objc static var iBackClose: UIImage? {
        UIImage(named: "common_back_close_dark")
    }
    
    //cell方向箭头
    @objc static var iRightArrow: UIImage? {
        UIImage(named: "right_arrow")
    }
    @objc static var iRightArrowLightAlways: UIImage? {
        UIImage(named: "common_right_arrow_light_always")
    }
    
    //系统设置图标
    @objc static var iSysSettingIcon: UIImage? {
        UIImage(named: "sys_setting")
    }
    
    //青少年模式弹窗头图
    @objc static var iTeenagerProtect = UIImage(named: "teenager_protect")
    
    //miku系列图片
    @objc static let iMiku_0 = UIImage(named: "miku_0")
    
    //Guide提示图片
    @objc static let iGuideHand = UIImage(named: "gudie_hand")
    @objc static let iGuideOrderAdd = UIImage(named: "guide_order_add")
    
    //健康码图片
    static var iHealthCodeNav: UIImage? = getPic("health_code_nav", ext: "jpg")
    static var iHealthCodeHead: UIImage? = getPic("health_code_head", ext: "jpg")
    static var iHealthCode: UIImage? = getPic("health_code", ext: "jpg")
    static var iHealthNucleateInfo: UIImage? = getPic("health_nucleate_info", ext: "jpg")
    //核酸/大数据/行程卡
    static var iHealthCodeNucleate: UIImage? = getPic("health_code_nucleate", ext: "jpg")
    static var iHealthCodeVaccine: UIImage? = getPic("health_code_vaccine", ext: "jpg")
    static var iHealthCodeTravelCard: UIImage? = getPic("health_code_travel_card", ext: "jpg")
    //信息更新
    static var iHealthCodeInfoUpdate: UIImage? = getPic("health_code_info_update", ext: "jpg")
    //正在播放
    static let iCurrentPlaySong: UIImage? = UIImage(named: "mp_playing")
    //未收藏
    static let iUnfavorite: UIImage? = UIImage(named: "mp_unfavorite")
    //已收藏
    static let ifavorite: UIImage? = UIImage(named: "mp_favorite")
    //添加到歌单
    static let iSonglist: UIImage? = UIImage(named: "mp_addto_songlist")
    //跳到正在播放
    static let iJumpCurrentSong: UIImage? = UIImage(named: "mp_jump_current")
    //默认唱片底图
    static let iDefaultDisc: UIImage? = UIImage(named: "mp_default_disc")
    //唱片图
    static let iDiscImage: UIImage? = UIImage(named: "mp_disc_img")
    //播放
    static let iPlayBtn: UIImage? = UIImage(named: "mp_play_btn")
    //暂停
    static let iPauseBtn: UIImage? = UIImage(named: "mp_pause_btn")
    //下一首
    static let iNextBtn: UIImage? = UIImage(named: "mp_play_next_btn")
    //上一首
    static let iPreviousBtn: UIImage? = UIImage(named: "mp_play_previous_btn")
    //随机播放
    static let iRandomBtn: UIImage? = UIImage(named: "mp_play_random_btn")
    //顺序播放
    static let iSequenceBtn: UIImage? = UIImage(named: "mp_play_sequence_btn")
    //单曲循环
    static let iSingleBtn = UIImage(named: "mp_play_single_btn")
    //播放列表
    static let iPlaylistBtn = UIImage(named: "mp_playlist_btn")
    //进度按钮
    static let iPlayProgressBtn = UIImage(named: "mp_progress_icon")
    //我喜欢
    static let iPlayUnfavoriteBtn = UIImage(named: "mp_play_unfavorite")
    static let iPlayFavoriteBtn = UIImage(named: "mp_play_favorite")
    //添加到歌单
    static let iPlayAddSonglistBtn = UIImage(named: "mp_play_add_songlist")
    //mini唱片
    static let iMiniDiscBg = UIImage(named: "mp_mini_disc")
    //mini下一首
    static let iMiniNextBtn = UIImage(named: "mp_mini_next")
    //mini暂停
    static let iMiniPauseBtn = UIImage(named: "mp_mini_pause")
    //mini播放
    static let iMiniPlayBtn = UIImage(named: "mp_mini_play")
    //mini播放列表
    static let iMiniPlaylistBtn = UIImage(named: "mp_mini_playlist")
    //播放列表删除歌曲
    static let iPlaylistDeleteBtn = UIImage(named: "mp_playlist_delete_btn")
    //播放列表定位按钮
    static let iPlaylistLocationBtn = UIImage(named: "mp_playlist_location_btn")
    //歌词定位按钮
    static let iLrcLocationBtn = UIImage(named: "mp_locate_lrc_btn")

}

//实用方法
extension UIImage
{
    ///对于某些全屏的图片有iPhone8和iPhoneX的尺寸区别，对于iPhoneX的图片，添加后缀`_bang`
    static func bangImage(name: String) -> UIImage?
    {
        UIImage(named: name + String.bangSuffix)
    }
    
    ///对于某些全屏图片有iPhone8和iPhoneX的尺寸区别，对于iPhone8的图片，添加后缀`_small`
    static func smallImage(name: String) -> UIImage?
    {
        UIImage(named: name + String.smallSuffix)
    }
    
    ///读取bundle中的一张大图，不缓存图片
    static func getPic(_ name: String, ext: String? = nil) -> UIImage?
    {
        UIImage(contentsOfFile: SandBoxAccessor.shared.getBundleFilePath(name, ext: ext) ?? "")
    }

}
