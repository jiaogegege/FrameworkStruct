//
//  StringConst.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/11/5.
//

/**
 * 定义各种文案和字符串
 * 仅定义纯粹的字符串，而不定义含有特殊意义的字符串
 */
import Foundation

//MARK: 项目通用字符串定义
/**
 * 通用字符串建议以`s`开头，表示`string`，方便区分
 */

//MARK: 对String的扩展，包括一些实用方法和常量定义
extension String: ConstantPropertyProtocol
{
    //空字符
    static let sEmpty = ""
    //一个空格
    static let sSpace = " "
    //新行
    static let sNewline = "\n"
    static let sNewLine = "\\n"
    //通用分隔符
    static let sSeprator = "<=>"
    
    //"iCloud"
    static let iCloud = "iCloud"
    
    //汉字数字
    static let s0 = "〇"
    static let s1 = "一"
    static let s2 = "二"
    static let s3 = "三"
    static let s4 = "四"
    static let s5 = "五"
    static let s6 = "六"
    static let s7 = "七"
    static let s8 = "八"
    static let s9 = "九"
    static let s十 = "十"
    static let s百 = "百"
    static let s千 = "千"
    static let s万 = "万"
    static let s亿 = "亿"
    
    //人民币大写数字
    static let sRMB0 = "零"
    static let sRMB1 = "壹"
    static let sRMB2 = "贰"
    static let sRMB3 = "叁"
    static let sRMB4 = "肆"
    static let sRMB5 = "伍"
    static let sRMB6 = "陆"
    static let sRMB7 = "柒"
    static let sRMB8 = "捌"
    static let sRMB9 = "玖"
    static let sRMB十 = "拾"
    static let sRMB百 = "佰"
    static let sRMB千 = "仟"
    static let sRMB万 = "万"
    static let sRMB亿 = "亿"
    
    //常用特殊字符
    static let cDot: Character = "."
    static let sDot = "."
    static let cTilde: Character = "~"
    static let sTilde = "~"
    static let cSigh: Character = "!"
    static let sSigh = "!"
    static let cAt: Character = "@"
    static let sAt = "@"
    static let cSharp: Character = "#"
    static let sSharp = "#"
    static let cPercent: Character = "%"
    static let sPercent = "%"
    static let cCaret: Character = "^"
    static let sCaret = "^"
    static let cAnd: Character = "&"
    static let sAnd = "&"
    static let cStar: Character = "*"
    static let sStar = "*"
    static let cOr: Character = "|"
    static let sOr = "|"
    static let cQuestion: Character = "?"
    static let sQuestion = "?"
    static let cComma: Character = ","
    static let sComma = ","
    static let cSemicolon: Character = ";"
    static let sSemicolon = ";"
    static let cQuote: Character = "\""
    static let sQuote = "\""
    static let cSingleQuote: Character = "'"
    static let sSingleQuote = "'"
    static let cSlash: Character = "/"
    static let sSlash = "/"
    static let cBackslash: Character = "\\"
    static let sBackslash = "\\"
    static let cUnderline: Character = "_"
    static let sUnderline = "_"
    static let cColon: Character = ":"
    static let sColon = ":"
    static let cLeftBracket: Character = "("
    static let sLeftBracket = "("
    static let cRightBracket: Character = ")"
    static let sRightBracket = ")"
    static let cLeftSquareBracket: Character = "["
    static let sLeftSquareBracket = "["
    static let cRightSquareBracket: Character = "]"
    static let sRightSquareBracket = "]"
    static let cLeftCurlyBracket: Character = "{"
    static let sLeftCurlyBracket = "{"
    static let cRightCurlyBracket: Character = "}"
    static let sRightCurlyBracket = "}"
    static let cEnDash: Character = "–"
    static let sEnDash = "–"
    
    //数学符号
    static let sPlus = "+"
    static let sMinus = "-"
    static let sAddMinus = "±"
    static let sMultiply = "×"
    static let sDivision = "÷"
    static let sInfinite = "∞"
    static let sEqual = "="
    static let sUnequal = "≠"
    static let sAboutEqual = "≈"
    static let sGreaterEqual = "≥"
    static let sComplexGreaterEqual = "≧"
    static let sLessEqual = "≤"
    static let sComplexLessEqual = "≦"
    static let sBecause = "∵"
    static let sTherefore = "∴"
    
    //货币符号
    static let sCurrency = "¤"              //国际通货符号，当没有合适的货币符号时使用
    static let sUSD = "$"                   //美元
    static let sFen = "¢"                   //分，美元和其他一些货币辅助单位的符号
    static let sWen = "₥"                   //文（表示千分之一元或十分之一分）
    static let sEUR = "€"                   //欧元
    static let sFRF = "₣"                   //法郎
    static let sCNY = "¥"                   //人民币
    static let sJPY = "¥"                   //日元
    static let sGBP = "£"                   //英镑
    static let sRUB = "₽"                   //卢布
    static let sSGD = "S$"                  //新加坡元
    static let sTHB = "฿"                   //泰铢
    static let sINR = "Rs."                 //印度卢比
    static let sVND = "₫"                   //越南盾
    static let sDkr = "Kr"                  //丹麦克朗，挪威克朗，瑞典克朗以及冰岛克朗
    static let sBRL = "R$"                  //雷亚尔，巴西的货币符号
    static let sLira = "₤"                  //里拉
    static let sPeso = "₱"                  //菲律宾比索，菲律宾的货币符号
    static let sRand = "R"                  //南非兰特，南非的货币符号
    static let sRupee = "৲৳"                //卢比符号(孟加拉地区使用)
    static let sKRW = "₩"                   //韩元
    static let sTWD = "NT$"                 //新台币
    static let sHKD = "HK$"                 //港元
    
    //希腊字母
    static let sUAlpha = "Α"
    static let sAlpha = "α"
    static let sUBeta = "Β"
    static let sBeta = "β"
    static let sUGamma = "Γ"
    static let sGamma = "γ"
    static let sUDelta = "Δ"
    static let sDelta = "δ"
    static let sUEpsilon = "Ε"
    static let sEpsilon = "ε"
    static let sUZeta = "Ζ"
    static let sZeta = "ζ"
    static let sUEta = "Η"
    static let sEta = "η"
    static let sUTheta = "Θ"
    static let sTheta = "θ"
    static let sUIota = "Ι"
    static let sIota = "ι"
    static let sUKappa = "Κ"
    static let sKappa = "κ"
    static let sULambda = "Λ"
    static let sLambda = "λ"
    static let sUMu = "Μ"
    static let sMu = "μ"
    static let sUNu = "Ν"
    static let sNu = "ν"
    static let sUXi = "Ξ"
    static let sXi = "ξ"
    static let sUOmicron = "Ο"
    static let sOmicron = "ο"
    static let sUPi = "Π"
    static let sPi = "π"
    static let sURho = "Ρ"
    static let sRho = "ρ"
    static let sUSigma = "Σ"
    static let sSigma = "σ"
    static let sUTau = "Τ"
    static let sTau = "τ"
    static let sUUpsilon = "Υ"
    static let sUpsilon = "υ"
    static let sUPhi = "Φ"
    static let sPhi = "φ"
    static let sUChi = "Χ"
    static let sChi = "χ"
    static let sUPsi = "Ψ"
    static let sPsi = "ψ"
    static let sUOmega = "Ω"
    static let sOmega = "ω"
    
    //罗马数字
    static let sRm1 = "Ⅰ"
    static let sRm2 = "Ⅱ"
    static let sRm3 = "Ⅲ"
    static let sRm4 = "Ⅳ"
    static let sRm5 = "Ⅴ"
    static let sRm6 = "Ⅵ"
    static let sRm7 = "Ⅶ"
    static let sRm8 = "Ⅷ"
    static let sRm9 = "Ⅸ"
    static let sRm10 = "Ⅹ"
    static let sRm50 = "L"
    static let sRm100 = "C"
    static let sRm500 = "D"
    static let sRm1000 = "M"
    
    
    
    
    
    //iPhoneX资源文件后缀
    static let bangSuffix = "_bang"
    //iPhone8资源文件后缀
    static let smallSuffix = "_small"
    
    //获取对应的iPhoneX下的文件名
    func bangString() -> String
    {
        self + String.bangSuffix
    }
    
    //获取对应的iPhone8以下的文件名
    func smallString() -> String
    {
        self + String.smallSuffix
    }
    
}


//MARK: 项目中文案定义，国际化文案
extension String
{
    //MARK: 项目中各种标题
    //app名称
    static let appName = localized("appName")
    //主页
    static let homeVC = localized("homeVC")
    //我的
    static let mineVC = localized("mineVC")
    //健康码
    static let healthCode = localized("healthCode")
    //场所码
    static let placeCode = localized("placeCode")
    //行程卡
    static let travelCard = localized("travelCard")
    //瀑布流
    static let waterfall = localized("waterfall")
    //主题选择
    static let themeSelect = localized("themeSelect")
    //模态显示
    static let modalShow = localized("modalShow")
    //约束测试
    static let constraintTest = localized("constraintTest")
    //绘制表格
    static let drawTable = localized("drawTable")
    //图层阴影
    static let layerShadow = localized("layerShadow")
    //动画演示
    static let animationDemo = localized("animationDemo")
    //H5交互
    static let webInteraction = localized("webInteraction")
    //绘图测试
    static let drawTest = localized("drawTest")
    //复制粘贴
    static let copyPaste = localized("copyPaste")
    //iCloud文件管理
    static let iCloudFileManage = localized("iCloudFileManage")
    //编辑iCloud文件
    static let editiCloudFile = localized("editiCloudFile")
    
    //MARK: 界面提示和按钮文案
    //确定
    static let confirm = localized("confirm")
    //取消
    static let cancel = localized("cancel")
    //是
    static let yes = localized("yes")
    //否
    static let no = localized("no")
    //成功
    static let success = localized("success")
    //失败
    static let failure = localized("failure")
    //跳过
    static let skip = localized("skip")
    //我知道了
    static let iKnown = localized("iKnown")
    //从相册选择
    static let selectFromPhotoLibiary = localized("selectFromPhotoLibiary")
    //拍照
    static let takePhotoWithCamera = localized("takePhotoWithCamera")
    //新消息
    static let newMsg = localized("newMsg")
    //发送
    static let send = localized("send")
    //输入消息
    static let inputMessage = localized("inputMessage")
    //追加
    static let append = localized("append")
    //我的收藏
    static let myFavorite = localized("myFavorite")
    //切换主题
    static let changeTheme = localized("changeTheme")
    //icloud文件
    static let icloudFile = localized("icloudFile")
    //音乐库
    static let musicLibrary = localized("musicLibrary")
    //历史播放
    static let historyPlay = localized("historyPlay")
    //当前播放
    static let currentPlay = localized("currentPlay")
    //播放音乐
    static let playMusic = localized("playMusic")
    //喜欢
    static let like = localized("like")
    //不喜欢
    static let dislike = localized("dislike")
    //添加到书签
    static let addToBookmark = localized("addToBookmark")
    //我喜欢
    static let iLike = localized("iLike")
    //确定删除？
    static let sureDelete = localized("sureDelete")
    //新建歌单
    static let newSonglist = localized("newSonglist")
    //为歌单取个名字吧
    static let enterSonglistNameHint = localized("enterSonglistName")
    //为歌单添加简介
    static let addDescToSonglist = localized("addDescToSonglist")
    //请输入一个名字
    static let pleaseEnterName = localized("pleaseEnterName")
    //收藏歌曲到歌单
    static let addSongToSonglist = localized("addSongToSonglist")
    //暂无歌词
    static let noLyric = localized("noLyric")
    
    //MARK: Toast文案
    //播放失败
    static let failToPlay = localized("failToPlay")
    //删除成功
    static let deleteSucceed = localized("deleteSucceed")
    //删除失败
    static let deleteFailed = localized("deleteFailed")
    //添加成功
    static let addSuccess = localized("addSuccess")
    //添加失败
    static let addFailure = localized("addFailure")
    //部分歌曲已存在
    static let partSongExist = localized("partSongExist")
    //歌曲已存在
    static let songExist = localized("songExist")
    //创建成功
    static let createSuccess = localized("createSuccess")
    //创建失败
    static let createFailure = localized("createFailure")
    
    //MARK: 通用错误信息
    //未知错误
    static let unknownError = localized("unknownError")
    //网络错误
    static let networkError = localized("networkError")
    //没有推送权限
    static let withoutAccessToPush = localized("withoutAccessToPush")
    //没有日历权限
    static let withoutCalendar = localized("withoutCalendar")
    //没有提醒事项权限
    static let withoutReminder = localized("withoutReminder")
    //保存到iCloud失败
    static let saveToiCloudError = localized("saveToiCloudError")

    //MARK: 网络状态错误信息
    static let networkUndefinedStatus = localized("networkUndefinedStatus")
    static let networkUnavailable = localized("networkUnavailable")
    static let networkDataParseError = localized("networkDataParseError")
    static let networkOk = localized("networkOk")
    static let networkCreated = localized("networkCreated")
    static let networkAccepted = localized("networkAccepted")
    static let networkNotFound = localized("networkNotFound")
    static let networkBadRequest = localized("networkBadRequest")
    static let networkNeedAuth = localized("networkNeedAuth")
    static let networkForbidden = localized("networkForbidden")
    static let networkTimeout = localized("networkTimeout")
    static let networkSystemError = localized("networkSystemError")
    static let networkNoService = localized("networkNoService")
    static let networkBadGetway = localized("networkBadGetway")
    static let networkServiceUnavailable = localized("networkServiceUnavailable")
    
    //MARK: 长文案
    //青少年模式弹窗内容
    static let teenagerProtectContent = localized("teenagerProtectContent")
    //进入青少年模式文字
    static let enterTeenMode = localized("setTeenagerMode")
    




    //便利方法
    static func localized(_ originStr: String) -> String
    {
//        return NSLocalizedString(originStr, tableName: "Localizable", bundle: Bundle.main, value: originStr, comment: originStr)
        return NSLocalizedString(originStr, comment: originStr)
    }
    
}
