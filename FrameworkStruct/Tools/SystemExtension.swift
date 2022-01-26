//
//  SystemExtension.swift
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2021/12/11.
//

/**
 * 主要对各种系统组件进行扩展
 */
import Foundation

/**
 * NSObject
 */
extension NSObject
{
    ///获取对象的类名，计算属性
    var className: String {
        let typeName = type(of: self).description()
        if(typeName.contains("."))
        {
            return typeName.components(separatedBy: ".").last!
        }
        else
        {
            return typeName
        }
    }
}


/**
 * String
 */
extension String
{
    ///去除字符串头尾空格和换行
    func trim() -> String
    {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    ///计算字符串尺寸大小
    func sizeWith(font: UIFont, maxWidth: CGFloat) -> CGSize
    {
        let rect = self.boundingRect(with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font : font], context: nil)
        return rect.size
    }
    
    ///计算字符串高度
    func heightWith(font: UIFont, maxWidth: CGFloat) -> CGFloat
    {
        let size = self.sizeWith(font: font, maxWidth: maxWidth)
        return size.height
    }
    
    ///计算文本高度
    func calcHeight(font: UIFont, size: CGSize) -> CGFloat
    {
        var height:CGFloat = 0.0
        let rect = (self as NSString).boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        height = rect.height
        return height
    }
    
    ///计算文本宽度
    func calcWidth(font: UIFont, size: CGSize) -> CGFloat
    {
        var width:CGFloat = 0.0
        let rect = (self as NSString).boundingRect(with: size, options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: font], context: nil)
        width = rect.width
        return width
    }
    
    ///带有行间距、颜色和字体的属性字符串
    func attrString(font: UIFont, color: UIColor = .black, lineSpace: CGFloat) -> NSAttributedString
    {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = lineSpace
        let attrStr = NSAttributedString.init(string: self, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.paragraphStyle: paragraph])
        return attrStr
    }
    
}


/**
 * NSAttributedString
 */
extension NSAttributedString
{
    ///计算属性字符串的位置大小，请保证设置了属性字体
    func calcSize(originSize: CGSize) -> CGSize
    {
        let rect = self.boundingRect(with: originSize, options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil)
        return rect.size
    }
    
}


/**
 * Array
 */
extension Array
{
    ///实现复制方法，返回一个新数组和新元素
    func copy() -> Array<Any>
    {
        var newArray = [Any]()
        for item in self
        {
            newArray.append(getCopy(origin: item))
        }
        return newArray
    }
    
    ///让Array支持contains方法
    func contains<T>(item: T) -> Bool where T: Equatable
    {
        return self.filter({$0 as? T == item}).count > 0
    }
    
}


/**
 * Dictionary
 */
extension Dictionary
{
    ///实现复制方法，返回一个新的字典和新元素
    func copy() -> Dictionary<AnyHashable, Any>
    {
        var newDic = Dictionary<AnyHashable, Any>()
        for (k, v) in self
        {
            newDic[k] = getCopy(origin: v)
        }
        return newDic
    }
    
}


/**
 * NSPointerArray
 */
extension NSPointerArray
{
    ///向弱引用数组添加对象
    func addObject(_ object: AnyObject?)
    {
        guard let strongObject = object else { return }
        let pointer = Unmanaged.passUnretained(strongObject).toOpaque()
        addPointer(pointer)
    }
 
    ///向弱引用数组的index位置插入对象
    func insertObject(_ object: AnyObject?, at index: Int)
    {
        guard index < count, let strongObject = object else { return }
        let pointer = Unmanaged.passUnretained(strongObject).toOpaque()
        insertPointer(pointer, at: index)
    }
 
    ///替换弱引用数组index位置的对象
    func replaceObject(at index: Int, withObject object: AnyObject?)
    {
        guard index < count, let strongObject = object else { return }
        let pointer = Unmanaged.passUnretained(strongObject).toOpaque()
        replacePointer(at: index, withPointer: pointer)
    }
 
    ///获取弱引用数组index位置的对象
    func object(at index: Int) -> AnyObject?
    {
        guard index < count, let pointer = self.pointer(at: index) else { return nil }
        return Unmanaged<AnyObject>.fromOpaque(pointer).takeUnretainedValue()
    }
 
    ///删除弱引用数组index位置的对象
    func removeObject(at index: Int)
    {
        guard index < count else { return }
        removePointer(at: index)
    }
    
}
