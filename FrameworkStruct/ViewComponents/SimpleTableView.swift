//
//  SimpleTableView.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/1/17.
//

/**
 * 简单表格视图
 * 输入数据后创建一个简单表格
 * 大部分情况下是两列，如果有多列，除去第一列是标题，剩余的列平分剩余宽度，一般建议不超过3列，因为这是简单表格
 *
 * 注意：请确保初始化时传入的frame的宽度是正确的，高度会根据数据变化
 *
 * 创建的表格如下图：
 * -------------------------------------------
 * | 标题                                     |
 * -------------------------------------------
 * | 副标题  ｜ 文本文本文本                     |
 * -------------------------------------------
 * | 副标题  ｜ 文本文本文本1234234              |
 * -------------------------------------------
 * | 标题                                     |
 * -------------------------------------------
 * | 副标题  ｜ 文本文本内容     | 文本          |
 * -------------------------------------------
 */
import UIKit

class SimpleTableView: UIView
{
    //MARK: 属性
    //整个view的背景色
    var bgColor: UIColor = .white
    
    //每一行的颜色，只能统一设置，暂不支持单独定制每一个单元格颜色
    var rowColor: UIColor = .clear
    //奇数行的颜色，从1开始
    var oddRowColor: UIColor = .white
    //偶数行颜色，从2开始
    var evenRowColor: UIColor = .cGray_f4
    //奇偶行是否分色显示，默认不分色显示，如果设置为true，将忽略`rowColor`，使用`oddRowColor`和`evenRowColor`
    var isOddEvenIsolate: Bool = false
    
    //边框线宽
    var borderWidth: CGFloat = 1.0
    //边框颜色
    var borderColor: UIColor = .cGray_E7E7E7
    
    //组文字颜色
    var groupTitleColor: UIColor = .cBlack_6
    //第一列文字颜色
    var rowHeadColor: UIColor = .cBlack_9
    //内容文字颜色
    var contentColor: UIColor = .cBlack_6
    
    //组字体
    var groupFont: UIFont = UIFont.boldSystemFont(ofSize: fitX(12.0))
    //第一列字体
    var rowHeadFont: UIFont = UIFont.systemFont(ofSize: fitX(12.0))
    //内容字体
    var contentFont: UIFont = UIFont.systemFont(ofSize: fitX(12.0))
    
    //文字间行距
    var lineSpace: CGFloat = fitX(8.0)
    
    //列头占表格总长的比例
    var rowHeadRatio: CGFloat = 110.0 / 386.0
    //内容距离表格的左右最小边距，如果内容没有填满空间，那么左对齐，如果空间不能放下内容，那么换行
    var contentLeftRight: CGFloat = fitX(20.0)
    //内容距离表格上下的最小边距，如果内容没有填满空间，那么居中，如果空间不能放下内容，那么换行
    var contentTopBottom: CGFloat = fitX(14.0)
    
    /**
     * 数据说明
     * 数据源是一个数组，数组的每一个元素也是一个数组，称为行数组，代表了表格的每一行；行数组元素是字符串，代表了一行中要显示的单元格内容
     * 如果行数组中只有一个元素，那么认为这一行是组标题，这一行只有一个单元格
     * 如果行数组中有多余1个元素，那么第一个元素是表头，后面的元素是表格内容，一般建议行数组不超过3个元素
     * 如果行数组中没有元素，那么忽略这一行
     * 表格会根据数据从上到下一行行创建，所以请保证输入数据的顺序是正确的
     */
    var dataArray: Array<Array<String>>? = nil
    
    //每一行的view数组
    var rowArray: Array<UIView> = []
    
    //表格总高度
    var totalHeight: CGFloat = 0.0
    
    //UI组件
    var bgView: UIView!     //背景视图，上面不放任何内容，主要用于调节背景的显示，比如颜色，图片等
    var containerView: UIView!  //内容视图，所有内容放在这里，透明色
    
    
    //MARK: 方法
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.createView()
        self.configView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createView() {
        bgView = UIView()
        self.addSubview(bgView)
        
        containerView = UIView()
        self.addSubview(containerView)
    }
    
    override func configView() {
        bgView.frame = self.bounds
        bgView.backgroundColor = bgColor
        
        containerView.frame = self.bounds
        containerView.backgroundColor = .clear
    }
    
    //获取row的背景色
    //index从1开始，数组的index从0开始，传入时需要转换
    fileprivate func rowColor(rowNum: Int) -> UIColor
    {
        if self.isOddEvenIsolate    //奇偶分色显示
        {
            return isOdd(rowNum) ? self.oddRowColor : self.evenRowColor
        }
        else    //每一行颜色相同
        {
            return self.rowColor
        }
    }
    
    //获取字符串的属性字符串，带有行距和字体
    fileprivate func getAttrStrArray(strArr: Array<String>) -> Array<NSAttributedString>
    {
        var attrArray = [NSAttributedString]()
        for (index, str) in strArr.enumerated()
        {
            //如果是第一列，字体取`rowHeadFont`，如果行只有一列，字体取`groupFont`，其他列字体取`contentFont`
            var font = self.contentFont
            var textColor = self.contentColor
            if index == 0  //第一列
            {
                font = self.rowHeadFont
                textColor = self.rowHeadColor
            }
            if strArr.count == 1    //一行只有一个元素
            {
                font = self.groupFont
                textColor = self.groupTitleColor
            }
            attrArray.append(str.attrString(font: font, color: textColor, lineSpace: self.lineSpace))
        }
        return attrArray
    }
    
    //计算属性字符串的最大高度
    fileprivate func getMaxHeight(attrStrArray: Array<NSAttributedString>) -> CGFloat
    {
        //准备常量
        //左右空白
        let leftRightPadding: CGFloat = 2.0 * contentLeftRight
        //其他列宽度，如果有多列，那么剩余宽度平分，如果只有一列，那么宽度为0
        let columnWidth: CGFloat = attrStrArray.count == 1 ? 0.0 : (self.width - self.width * rowHeadRatio) / CGFloat((attrStrArray.count - 1))
        //其他列内容宽度
        let columnContentWidth: CGFloat = columnWidth - leftRightPadding
        
        var maxHeight: CGFloat = 0.0
        for (index, attrStr) in attrStrArray.enumerated()
        {
            var contentWidth: CGFloat = columnContentWidth
            if index == 0  //第一列
            {
                contentWidth = self.width * rowHeadRatio - leftRightPadding
            }
            if attrStrArray.count == 1  //一行只有一个元素
            {
                contentWidth = self.width - leftRightPadding
            }
            let height = attrStr.calcSize(originSize: CGSize(width: contentWidth, height: CGFloat.greatestFiniteMagnitude)).height
            //判断是否最大高度
            if height > maxHeight
            {
                maxHeight = height
            }
        }
        return maxHeight
    }
    
    /**
     * 创建表格的每一行
     * 确认每一行的元素个数
     * 绘制每一行的left top right表格边框
     *
     * - Parameters:
     *  - strArray: 行数组，元素是字符串
     *  - isLast: 是否最后一行，用来绘制底部边框
     *
     * - returns: 表格的一行
     */
    fileprivate func createRow(strArray: Array<String>, isLast: Bool) -> UIView
    {
        //先准备数据
        //左右空白
        let leftRightPadding: CGFloat = 2.0 * contentLeftRight
        //上下空白
        let topBottomPadding: CGFloat = 2.0 * contentTopBottom
        //第一列宽度，如果只有一列，那么占据全宽；否则取全宽的一定比例
        let rowHeadWidth: CGFloat = strArray.count == 1 ? self.width : self.width * rowHeadRatio
        //第一列内容宽度
        let rowHeadContentWidth: CGFloat = rowHeadWidth - leftRightPadding
        //其他列宽度，如果有多列，那么剩余宽度平分
        let columnWidth: CGFloat = strArray.count == 1 ? 0.0 : (self.width - rowHeadWidth) / CGFloat((strArray.count - 1))
        //其他列内容宽度
        let columnContentWidth: CGFloat = columnWidth - leftRightPadding
        //获取属性字符串列表
        let attrStrArr = self.getAttrStrArray(strArr: strArray)
        //计算属性字符串的最大高度
        let maxContentHeight = self.getMaxHeight(attrStrArray: attrStrArr)
        //计算最大行高
        let maxRowHeight = maxContentHeight + topBottomPadding
        
        //创建文本标签
        let contentView = UIView()
        //x/y都设置为0，当返回view之后，会再进行设置，这里主要确定宽高
        contentView.frame = CGRect(x: 0, y: 0, width: self.width, height: maxRowHeight)
        contentView.backgroundColor = self.rowColor
        //一行当前的实际内容宽度，用于创建label时确定位置
        var x: CGFloat = contentLeftRight
        for (index, attrStr) in attrStrArr.enumerated()
        {
            let label = UILabel(frame: CGRect(x: x, y: contentTopBottom, width: (index == 0 ? rowHeadContentWidth : columnContentWidth), height: maxContentHeight))
            label.numberOfLines = 0
            label.attributedText = attrStr
            contentView.addSubview(label)
            //每一个label添加自身的左边框
            let leftBorder = UIView(frame: CGRect(x: x - contentLeftRight, y: 0.0, width: borderWidth, height: maxRowHeight))
            leftBorder.backgroundColor = self.borderColor
            contentView.addSubview(leftBorder)
            
            x += label.width + leftRightPadding //加上标签宽度和左右两个空白
        }
        //添加上边框
        let topBorder = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.width, height: borderWidth))
        topBorder.backgroundColor = borderColor
        contentView.addSubview(topBorder)
        //添加右边框
        let rightBorder = UIView(frame: CGRect(x: self.width - borderWidth, y: 0.0, width: borderWidth, height: maxRowHeight))
        rightBorder.backgroundColor = borderColor
        contentView.addSubview(rightBorder)
        
        //如果是最后一行，添加底边框
        if isLast
        {
            let bottomBorder = UIView(frame: CGRect(x: 0.0, y: maxRowHeight - borderWidth, width: self.width, height: borderWidth))
            bottomBorder.backgroundColor = borderColor
            contentView.addSubview(bottomBorder)
        }
        
        return contentView
    }
    
}


//接口方法
extension SimpleTableView: ExternalInterface
{
    ///计算前几行的高度，如果实际行数小于指定行数，那么返回实际高度；如果参数小于1，那么最小取1行
    func getTopRowHeight(rowCount: Int) -> CGFloat
    {
        //限制区间 1-array.count
        let count = limitInterval(rowCount, min: 1, max: self.rowArray.count)
        //累加前 count 行的高度
        var height: CGFloat = 0.0
        for i in 0..<count
        {
            height += self.rowArray[i].height
        }
        if count < totalRowCount    //如果不是最后一行，要加上上边框的宽度
        {
            height += borderWidth
        }
        return height
    }
    
    ///计算属性，返回一共的行数
    var totalRowCount: Int {
        self.rowArray.count
    }
    
    ///传入数据后更新view
    override func updateView()
    {
        if let daArray = self.dataArray
        {
            for (index, arr) in daArray.enumerated()
            {
                if arr.count > 0    //排除空行
                {
                    let view = self.createRow(strArray: arr, isLast: index >= daArray.count - 1)
                    //对row的显示属性进行设置，背景色，frame等
                    view.y = self.totalHeight
                    if isOddEvenIsolate //支持奇偶行变色
                    {
                        view.backgroundColor = isOdd(index) ? self.oddRowColor : self.evenRowColor
                    }
                    self.containerView.addSubview(view)
                    self.rowArray.append(view)
                    
                    totalHeight += view.height
                }
            }
            //table创建完成后，更新self高度
            self.containerView.height = totalHeight
            self.bgView.height = totalHeight
            self.height = totalHeight
        }
    }
    
}
