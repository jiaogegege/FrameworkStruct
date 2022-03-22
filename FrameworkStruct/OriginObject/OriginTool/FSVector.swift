//
//  FSVector.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/12/16.
//

/**
 * 向量容器：序列存储
 * 1.可以返回头尾元素，有一个指针可以移动用来操作容器中的元素
 * 2.在头尾都可添加元素，一般在尾部添加
 */
import UIKit

class FSVector<T: Equatable>
{
    fileprivate var vector = [T]()
    fileprivate var currentIndex = 0
    
}

/**
 * 对外接口方法
 */
extension FSVector: ExternalInterface
{
    ///在头部添加一个元素
    func pushFront(_ item: T?)
    {
        if let it = item
        {
            self.vector.insert(it, at: 0)
        }
    }

    ///在尾部添加一个元素
    func pushBack(_ item: T?)
    {
        if let it = item
        {
            self.vector.append(it)
        }
    }

    ///返回头部元素，元素还在容器中，不存在返回nil
    func first() -> T?
    {
        if self.isEmpty()
        {
            return nil
        }
        else
        {
            return self.vector.first
        }
    }

    ///返回尾部元素，元素还在容器中，不存在返回nil
    func last() -> T?
    {
        if self.isEmpty()
        {
            return nil
        }
        else
        {
            return self.vector.last
        }
    }

    ///返回index的元素，元素还在容器中
    func itemAt(_ index: Int) -> T?
    {
        if !self.isEmpty() && index < self.count()
        {
            return self.vector[index]
        }
        return nil
    }
    
    //获取所有元素，元素还在容器中
    func allItems() -> [T]
    {
        if self.isEmpty()
        {
            return []
        }
        else
        {
            let newArr = self.vector
            return newArr
        }
    }

    ///弹出头部元素，元素不在容器中
    func popFirst() -> T?
    {
        if self.isEmpty()
        {
            return nil
        }
        else
        {
            let it = self.vector.first
            self.vector.removeFirst()
            return it
        }
    }

    ///弹出尾部元素，元素不在容器中
    func popLast() -> T?
    {
        if self.isEmpty()
        {
            return nil
        }
        else
        {
            let it = self.vector.last
            self.vector.removeLast()
            return it
        }
    }
    
    ///弹出某个元素，元素不在容器中，如果元素不存在容器中，返回NO
    func pop(item: T) -> Bool
    {
        if !self.isEmpty()
        {
            if self.vector.contains(item)
            {
                let index = self.indexOf(item)
                if index >= 0
                {
                    self.vector.remove(at: index)
                    return true
                }
            }
        }
        return false
    }

    ///弹出index的某个元素，元素不在容器中，如果index的元素不存在，返回nil
    func popAt(_ index: Int) -> T?
    {
        if !self.isEmpty() && index < self.count()
        {
            let it = self.vector[index]
            self.vector.remove(at: index)
            return it
        }
        else
        {
            return nil
        }
    }

    ///获得下一个元素，元素还在容器中，如果index超过容器最大范围或容器为空，返回nil，并自动返回容器头部，返回当前index成功后index再+1
    func next() -> T?
    {
        if self.currentIndex < self.count() && self.count() > 0
        {
            let it = self.vector[self.currentIndex]
            self.currentIndex += 1
            return it
        }
        else
        {
            //重置指针到头部
            self.moveToFront()
            return nil
        }
    }

    ///重置指针为容器头部元素，index为0
    func moveToFront()
    {
        self.currentIndex = 0
    }

    ///获得元素在容器中的index，不存在返回-1
    func indexOf(_ item: T) -> Int
    {
        if !self.isEmpty()
        {
            if self.vector.contains(item)
            {
                return self.vector.firstIndex(of: item) ?? -1
            }
        }
        return -1
    }

    ///判断容器是否为空
    func isEmpty() -> Bool
    {
        if self.vector.count > 0
        {
            return false
        }
        return true
    }

    ///获得元素个数
    func count() -> Int
    {
        if self.isEmpty()
        {
            return 0
        }
        else
        {
            return self.vector.count
        }
    }

    ///清空容器
    func clear()
    {
        self.vector.removeAll()
    }

}
