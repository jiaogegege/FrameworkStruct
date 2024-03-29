//
//  UnitTool.swift
//  FrameworkStruct
//
//  Created by jggg on 2022/3/16.
//

/**
 * 物理量和单位换算
 */
import Foundation

//MARK: 温度
///摄氏度to开尔文
func C2K(_ C: Double) -> Double
{
    return C + 273.15
}

///开尔文to摄氏度
func K2C(_ K: Double) -> Double
{
    return K - 273.15
}

///摄氏度to华氏度
func C2F(_ C: Double) -> Double
{
    return 32.0 + C * 1.8
}

///华氏度to摄氏度
func F2C(_ F: Double) -> Double
{
    return (F - 32.0) / 1.8
}


//MARK: 长度
///米to英尺
func m2feet(_ m: Double) -> Double
{
    return m / 0.3048
}

///英尺to米
func feet2m(_ feet: Double) -> Double
{
    return feet * 0.3048
}

///米to尺
func m2chi(_ m: Double) -> Double
{
    return m * 3.0
}

///尺to米
func chi2m(_ chi: Double) -> Double
{
    return chi / 3.0
}

///英寸to厘米
func inch2cm(_ inch: Double) -> Double
{
    return inch * 2.54
}

///厘米to英寸
func cm2inch(_ cm: Double) -> Double
{
    return cm / 2.54
}

///码to米
func yard2m(_ yard: Double) -> Double
{
    return yard * 0.9144
}

///米to码
func m2yard(_ m: Double) -> Double
{
    return m / 0.9144
}

///英里to千米
func mile2km(_ mile: Double) -> Double
{
    return mile * 1.609344
}

///千米to英里
func km2mile(_ km: Double) -> Double
{
    return km / 1.609344
}

///海里to千米
func nmi2km(_ nmi: Double) -> Double
{
    return nmi * 1.852
}

///千米to海里
func km2nmi(_ km: Double) -> Double
{
    return km / 1.852
}


//MARK: 速度
///千米/小时to米/秒
func kmh2ms(_ kmh: Double) -> Double
{
    return kmh * 0.277778
}

///米/秒to千米/小时
func ms2kmh(_ ms: Double) -> Double
{
    return ms / 0.277778
}

///英里/小时to千米/小时
func mileh2kmh(_ mileh: Double) -> Double
{
    return mileh * 1.6093427
}

///千米/小时to英里/小时
func kmh2mileh(_ kmh: Double) -> Double
{
    return kmh / 1.6093427
}

///节to千米/小时
func kn2kmh(_ kn: Double) -> Double
{
    return kn * 1.852
}

///千米/小时to节
func kmh2kn(_ kmh: Double) -> Double
{
    return kmh / 1.852
}

///马赫to米/秒
func M2ms(_ M: Double) -> Double
{
    return M * 340.3
}

///米/秒to马赫
func ms2M(_ ms: Double) -> Double
{
    return ms / 340.3
}


//MARK: 角度
///弧度to毫弧度
func rad2mrad(_ rad: Double) -> Double
{
    return rad * 1000.0
}

///毫弧度to弧度
func mrad2rad(_ mrad: Double) -> Double
{
    return mrad / 1000.0
}

///弧度to度
func rad2o(_ rad: Double) -> Double
{
    return rad * 57.29578
}

///度to弧度
func o2rad(_ o: Double) -> Double
{
    return o / 57.29578
}

///度to分
func o2min(_ o: Double) -> Double
{
    return o * 59.998800024
}

///分to度
func min2o(_ min: Double) -> Double
{
    return min / 59.998800024
}

///分to秒
func min2sec(_ min: Double) -> Double
{
    return min * 59.9964
}

///秒to分
func sec2min(_ sec: Double) -> Double
{
    return sec / 59.9964
}


//MARK: 面积
///亩to平方米
func mu2m2(_ mu: Double) -> Double
{
    return mu * 666.6667
}

///平方米to亩
func m22mu(_ m2: Double) -> Double
{
    return m2 / 666.6667
}

///顷to平方米
func qing2m2(_ qing: Double) -> Double
{
    return qing * 66666.6667
}

///平方米to顷
func m22qing(_ m2: Double) -> Double
{
    return m2 / 66666.6667
}

///公顷to平方米
func ha2m2(_ ha: Double) -> Double
{
    return ha * 10000.0
}

///平方米to公顷
func m22ha(_ m2: Double) -> Double
{
    return m2 / 10000.0
}

///公亩to平方米
func a2m2(_ a: Double) -> Double
{
    return a * 100.0
}

///平方米to公亩
func m22a(_ m2: Double) -> Double
{
    return m2 / 100.0
}

///平方千米to平方米
func km22m2(_ km2: Double) -> Double
{
    return km2 * 1000000.0
}

///平方米to平方千米
func m22km2(_ m2: Double) -> Double
{
    return m2 / 1000000.0
}


//MARK: 体积
///立方米to升
func m32L(_ m3: Double) -> Double
{
    return m3 * 1000.0
}

///升to立方米
func L2m3(_ L: Double) -> Double
{
    return L / 1000.0
}

///加仑to升
func gal2L(_ gal: Double) -> Double
{
    return gal * 4.54609
}

///升to加仑
func L2gal(_ L: Double) -> Double
{
    return L / 4.54609
}

///品脱to升
func pt2L(_ pt: Double) -> Double
{
    return pt * 0.568
}

///升to品脱
func L2pt(_ L: Double) -> Double
{
    return L / 0.568
}


//MARK: 重量
///吨to千克
func t2kg(_ t: Double) -> Double
{
    return t * 1000.0
}

///千克to吨
func kg2t(_ kg: Double) -> Double
{
    return kg / 1000.0
}

///担to千克
func dan2kg(_ dan: Double) -> Double
{
    return dan * 100.0
}

///千克to担
func kg2dan(_ kg: Double)-> Double
{
    return kg / 100.0
}

///磅to千克
func pound2kg(_ pound: Double) -> Double
{
    return pound * 0.45359237
}

///千克to磅
func kg2pound(_ kg: Double) -> Double
{
    return kg / 0.45359237
}

///英石to千克
func st2kg(_ st: Double) -> Double
{
    return st * 6.3502932
}

///千克to英石
func kg2st(_ kg: Double) -> Double
{
    return kg / 6.3502932
}

///千克to斤
func kg2jin(_ kg: Double) -> Double
{
    return kg * 2.0
}

///斤to千克
func jin2kg(_ jin: Double) -> Double
{
    return jin / 2.0
}

///斤to两
func jin2liang(_ jin: Double) -> Double
{
    return jin * 10.0
}

///两to斤
func liang2jin(_ liang: Double) -> Double
{
    return liang / 10.0
}

///两to钱
func liang2qian(_ liang: Double) -> Double
{
    return liang * 10.0
}

///钱to两
func qian2liang(_ qian: Double) -> Double
{
    return qian / 10.0
}

///两to克
func liang2g(_ liang: Double) -> Double
{
    return liang * 50.0
}

///克to两
func g2liang(_ g: Double)-> Double
{
    return g / 50.0
}

///常衡盎司to克
func ozav2g(_ ozav: Double) -> Double
{
    return ozav * 28.3495231
}

///克to常衡盎司
func g2ozav(_ g: Double) -> Double
{
    return g / 28.3495231
}

///金衡盎司to克
func ozt2g(_ ozt: Double) -> Double
{
    return ozt * 31.103
}

///克to金衡盎司
func g2ozt(_ g: Double) -> Double
{
    return g / 31.103
}

///克to格令
func g2gr(_ g: Double) -> Double
{
    return g * 15.4323584
}

///格令to克
func gr2g(_ gr: Double) -> Double
{
    return gr / 15.4323584
}

///克to克拉
func g2ct(_ g: Double)-> Double
{
    return g * 5.0
}

///克拉to克
func ct2g(_ ct: Double) -> Double
{
    return ct / 5.0
}

///克拉to分
func ct2fen(_ ct: Double) -> Double
{
    return ct * 100.0
}

///分to克拉
func fen2ct(_ fen: Double) -> Double
{
    return fen / 100.0
}

///克to微克
func g2μg(_ g: Double) -> Double
{
    return g * 1000000.0
}

///微克to克
func μg2g(_ μg: Double) -> Double
{
    return μg / 1000000.0
}

///克to分
func g2fen(_ g: Double) -> Double
{
    return g * 500.0
}

///分to克
func fen2g(_ fen: Double) -> Double
{
    return fen / 500.0
}


//MARK: 压强
///毫米汞柱to千帕
func mmHg2kPa(_ mmHg: Double) -> Double
{
    return mmHg / 7.5006168
}

///千帕to毫米汞柱
func kPa2mmHg(_ kPa: Double) -> Double
{
    return kPa * 7.5006168
}

///标准大气压to千帕
func atm2kPa(_ atm: Double) -> Double
{
    return atm * 101.325
}

///千帕to标准大气压
func kPa2atm(_ kPa: Double) -> Double
{
    return kPa / 101.325
}

///标准大气压to毫米汞柱
func atm2mmHg(_ atm: Double) -> Double
{
    return atm * 760.0
}

///毫米汞柱to标准大气压
func mmHg2atm(_ mmHg: Double) -> Double
{
    return mmHg / 760.0
}


//MARK: 能量
///卡路里to焦耳
func cal2J(_ cal: Double) -> Double
{
    return cal * 4.184
}

///焦耳to卡路里
func J2cal(_ J: Double) -> Double
{
    return J / 4.184
}

///度(千瓦·时)to焦耳
func kWh2J(_ kWh: Double) -> Double
{
    return kWh * 3600000.0
}

///焦耳to度(千瓦·时)
func J2kWh(_ J: Double) -> Double
{
    return J / 3600000.0
}

///千卡to千焦
func kcal2kJ(_ kcal: Double) -> Double
{
    return kcal * 4.1858518
}

///千焦to千卡
func kJ2kcal(_ kJ: Double) -> Double
{
    return kJ / 4.1858518
}

///千克·米to焦耳
func kgm2J(_ kgm: Double) -> Double
{
    return kgm * 9.8039216
}

///焦耳to千克·米
func J2kgm(_ J: Double) -> Double
{
    return J / 9.8039216
}


//MARK: 功率
///瓦to焦耳/秒
func W2Js(_ W: Double) -> Double
{
    return W * 1.0
}

///焦耳/秒to瓦
func Js2W(_ Js: Double) -> Double
{
    return Js / 1.0
}

///千卡/秒to瓦
func kcals2W(_ kcals: Double) -> Double
{
    return kcals * 4184.1004
}

///瓦to千卡/秒
func W2kcals(_ W: Double) -> Double
{
    return W / 4184.1004
}

///千瓦to马力
func kW2hp(_ kW: Double) -> Double
{
    return kW * 1.341022
}

///马力to千瓦
func hp2kW(_ hp: Double) -> Double
{
    return hp / 1.341022
}
