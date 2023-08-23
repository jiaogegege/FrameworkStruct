//
//  PriceEmbellisher.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/8/15.
//

/**
 价格修饰器，主要对价格进行不同样式的格式化
 */
import UIKit

class PriceEmbellisher: OriginEmbellisher {
    //MARK: 属性
    //单例
    static let shared = PriceEmbellisher()
    
    
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
extension PriceEmbellisher: InternalType
{
    static let ratioToYuan: Int = 100           //分到元的比率
    static let ratioToJiao: Int = 10            //分到角的比率
    
    //从数字分转换成字符串元后的格式设置
    enum PEPriceFormat {
        case autoAdjust                 //自动调整，如果计算结果只有整数，则只保留整数；只有一位小数则保留一位小数；两位小数则保留两位小数
        case adjust                     //适应调整，如果计算结果只有整数，则只保留整数；如果有小数则保留两位小数
        case integer                    //只保留整数部分
        case oneDecimal                 //保留一位小数
        case twoDecimal                 //保留两位小数
        
        //从数字分计算字符串元
        func getYuan(_ fen: Int) -> String
        {
            let fenD = Double(fen)
            switch self {
            case .autoAdjust:
                if fen % PriceEmbellisher.ratioToYuan == 0    //整数
                {
                    return String(format: "%d", fen / PriceEmbellisher.ratioToYuan)
                }
                else
                {
                    if fen % PriceEmbellisher.ratioToJiao == 0  //一位小数
                    {
                        return String(format: "%.1f", fenD / Double(PriceEmbellisher.ratioToYuan))
                    }
                    else //二位小数
                    {
                        return String(format: "%.02f", fenD / Double(PriceEmbellisher.ratioToYuan))
                    }
                }
            case .adjust:
                if fen % PriceEmbellisher.ratioToYuan == 0    //整数
                {
                    return String(format: "%d", fen / PriceEmbellisher.ratioToYuan)
                }
                else    //二位小数
                {
                    return String(format: "%.02f", fenD / Double(PriceEmbellisher.ratioToYuan))
                }
            case .integer:
                return String(format: "%d", fen / PriceEmbellisher.ratioToYuan)
            case .oneDecimal:
                return String(format: "%.1f", fenD / Double(PriceEmbellisher.ratioToYuan))
            case .twoDecimal:
                return String(format: "%.02f", fenD / Double(PriceEmbellisher.ratioToYuan))
            }
        }
    }
    
    ///正负号，加在整个价格字符串的最前面，比如`+¥12.12`、`-¥12.12`，如果本身计算的数字是负数，那么不建议设置正负号
    enum PESignType {
        case none           //不显示
        case positive       //显示正号
        case negative       //显示负号
        
        //返回符号
        var sign: String {
            switch self {
            case .none:
                return String.sEmpty
            case .positive:
                return String.sPlus
            case .negative:
                return String.sMinus
            }
        }
    }
    
}


//外部接口
extension PriceEmbellisher: ExternalInterface
{
    /**************************************** 人民币格式 Section Begin ***************************************/
    ///如果原来是元的数字，可以用这个方法转换成分的数字
    func yuanToFen(_ yuan: Double) -> Int
    {
        Int(yuan * Double(PriceEmbellisher.ratioToYuan))
    }
    
    ///价格一般以`分`为单位，需要格式化成`元`的字符串
    ///参数：format：格式化后数字的格式，整数/小数
    ///signType：正负号
    func toYuan(_ fen: Int, format: PEPriceFormat, signType: PESignType = .none) -> String
    {
        String(format: "%@%@", signType.sign, format.getYuan(fen))
    }
    
    ///格式化成带货币符号的元为单位的字符串
    ///参数：format：格式化后数字的格式，整数/小数
    ///signType：正负号
    ///symbol：货币符号
    func toPrice(_ fen: Int, format: PEPriceFormat = .twoDecimal, signType: PESignType = .none, symbol: String = String.sCNY) -> String
    {
        String(format: "%@%@%@", signType.sign, symbol, toYuan(fen, format: format))
    }
    
    ///格式化成带字体、颜色等的价格字符串
    ///参数：
    ///format：转换后的数字格式
    ///signType：正负号；signColor：正负号颜色；signFont：正负号字体
    ///hasSymbol：是否有货币符号
    ///symbol：货币符号，默认`¥`
    ///symbolColor：货币符号颜色；symbolFont：货币符号字体
    ///integerColor：整数部分颜色；integetFont：整数部分字体
    ///decimalColor：小数部分颜色；decimalFont：小数部分字体
    ///strokeLineType：删除线样式；strokeLineColor：删除线颜色
    ///underLineType：下划线样式；underlineColor：下划线颜色
    ///
    ///提示：在实际项目中可以将默认值设定为最常用的情况
    func toAttrPrice(_ fen: Int,
                     format: PEPriceFormat = .twoDecimal,
                     signType: PESignType = .none,
                     signColor: UIColor = .black,
                     signFont: UIFont = .systemFont(ofSize: 12),
                     hasSymbol: Bool = true,
                     symbol: String = String.sCNY,
                     symbolColor: UIColor = .black,
                     symbolFont: UIFont = .systemFont(ofSize: 12),
                     integerColor: UIColor = .black,
                     integetFont: UIFont = .systemFont(ofSize: 12),
                     decimalColor: UIColor = .black,
                     decimalFont: UIFont = .systemFont(ofSize: 12),
                     strokeLineType: NSUnderlineStyle = [],
                     strokeLineColor: UIColor = .clear,
                     underLineType: NSUnderlineStyle = [],
                     underlineColor: UIColor = .clear) -> NSAttributedString
    {
        let totalAttrStr = NSMutableAttributedString()
        //处理正负号
        let signAttrStr = NSAttributedString(string: signType.sign, attributes: [NSAttributedString.Key.foregroundColor: signColor, NSAttributedString.Key.font: signFont])
        totalAttrStr.append(signAttrStr)
        //处理货币符号
        if hasSymbol
        {
            let symbolStr = NSAttributedString(string: symbol, attributes: [NSAttributedString.Key.foregroundColor: symbolColor, NSAttributedString.Key.font: symbolFont])
            totalAttrStr.append(symbolStr)
        }
        //处理数字
        let priceStr = format.getYuan(fen)
        let priceAttrStr = NSMutableAttributedString(string: priceStr, attributes: [NSAttributedString.Key.foregroundColor: integerColor, NSAttributedString.Key.font: integetFont])    //先设置为整数部分的样式
        if let sepIndex = priceStr.firstIndex(of: String.cDot)  //获取小数点的位置
        {
            let deciRange = NSRange(sepIndex..<priceStr.endIndex, in: priceStr)
            //设置小数部分样式
            priceAttrStr.addAttributes([NSAttributedString.Key.foregroundColor: decimalColor, NSAttributedString.Key.font: decimalFont], range: deciRange)
        }
        totalAttrStr.append(priceAttrStr)
        //处理下划线和删除线
        totalAttrStr.addAttributes([NSAttributedString.Key.strikethroughStyle: NSNumber(value: strokeLineType.rawValue),
                                    NSAttributedString.Key.strikethroughColor: strokeLineColor,
                                    NSAttributedString.Key.underlineStyle: NSNumber(value: underLineType.rawValue),
                                    NSAttributedString.Key.underlineColor: underlineColor], range: NSRange(location: 0, length: totalAttrStr.length))
        return totalAttrStr
    }
    
    
    
    /**************************************** 人民币格式 Section End ***************************************/
    
}
