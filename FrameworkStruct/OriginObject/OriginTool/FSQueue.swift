//
//  FSQueue.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2021/12/16.
//

/**
 * 基础队列，先进先出
 */
import UIKit

//对元素类型没有要求，可以存储任何类型
class FSQueue<T: Any>
{
    //默认队列容器
    fileprivate var queue = [T]()
    
}

//对外接口方法
extension FSQueue: ExternalInterface
{
    //追加一个元素到容器尾部
    func push(_ item: T?)
    {
        if let it = item
        {
            self.queue.append(it)
        }
    }

    //弹出最前面一个元素，弹出后该元素不再存在容器中，如果没有元素则返回nil
    func pop() -> T?
    {
        if self.isEmpty()
        {
            return nil
        }
        else
        {
            let it = self.queue[0]
            self.queue.remove(at: 0)
            return it
        }
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
            let newArr = self.queue
            return newArr
        }
    }

    //获取所有元素，如果容器为空，返回nil；容器中不再保存元素
    func popAll() -> [T]?
    {
        if self.isEmpty()
        {
            return nil
        }
        else
        {
            let newArr = self.queue //Array是结构体，赋值后拷贝一份
            self.queue.removeAll()
            return newArr
        }
    }

    //获得容器最前面的元素，元素还在容器中
    func first() -> T?
    {
        if self.isEmpty()
        {
            return nil
        }
        else
        {
            return self.queue.first
        }
    }

    //判断容器是否为空
    func isEmpty()-> Bool
    {
        if self.queue.count > 0
        {
            return false
        }
        return true
    }

    //获得元素个数
    func count() -> Int
    {
        if self.isEmpty()
        {
            return 0
        }
        else
        {
            return self.queue.count
        }
    }

    //清空容器
    func clear()
    {
        self.queue.removeAll()
    }

}
