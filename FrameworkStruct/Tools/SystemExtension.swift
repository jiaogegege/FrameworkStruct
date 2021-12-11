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
 * Array
 */
extension Array
{
    //实现复制方法，返回一个新数组和新元素
    func copy() -> Array<Any>
    {
        var newArray = [Any]()
        for item in self
        {
            newArray.append(Utility.getCopy(origin: item))
        }
        return newArray
    }
    
}


/**
 * Dictionary
 */
extension Dictionary
{
    //实现复制方法，返回一个新的字典和新元素
    func copy() -> Dictionary<AnyHashable, Any>
    {
        var newDic = Dictionary<AnyHashable, Any>()
        for (k, v) in self
        {
            newDic[k] = Utility.getCopy(origin: v)
        }
        return newDic
    }
    
}


/**
 * NSPointArray
 */
extension NSPointerArray
{
    func addObject(_ object: AnyObject?) {
        guard let strongObject = object else { return }
        let pointer = Unmanaged.passUnretained(strongObject).toOpaque()
        addPointer(pointer)
    }
 
    func insertObject(_ object: AnyObject?, at index: Int) {
        guard index < count, let strongObject = object else { return }
 
        let pointer = Unmanaged.passUnretained(strongObject).toOpaque()
        insertPointer(pointer, at: index)
    }
 
    func replaceObject(at index: Int, withObject object: AnyObject?) {
        guard index < count, let strongObject = object else { return }
 
        let pointer = Unmanaged.passUnretained(strongObject).toOpaque()
        replacePointer(at: index, withPointer: pointer)
    }
 
    func object(at index: Int) -> AnyObject? {
        guard index < count, let pointer = self.pointer(at: index) else { return nil }
        return Unmanaged<AnyObject>.fromOpaque(pointer).takeUnretainedValue()
    }
 
    func removeObject(at index: Int) {
        guard index < count else { return }
        removePointer(at: index)
    }
}
