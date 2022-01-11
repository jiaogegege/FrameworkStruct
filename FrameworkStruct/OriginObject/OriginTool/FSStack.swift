//
//  FSStack.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/1/11.
//

/**
 * 栈
 */
import Foundation

class FSStack<T: Any>
{
    //容器
    fileprivate var stack = [T]()
}

//对外接口方法
extension FSStack
{
    //在栈顶推入一个元素
    func push(item: T?)
    {
        if let it = item
        {
            self.stack.append(it)
        }
    }
    
    //弹出栈顶的元素
    func pop() -> T?
    {
        if self.isEmpty()
        {
            return nil
        }
        else
        {
            let it = self.stack.last
            self.stack.removeLast()
            return it
        }
    }
    
    //弹出所有元素，按照栈的顺序放入一个数组中，最顶上的元素在`index:0`位置
    func popAll() -> [T]?
    {
        if self.isEmpty()
        {
            return nil
        }
        else
        {
            var newArr = [T]()
            for item in self.stack
            {
                newArr.append(item)
            }
            self.stack.removeAll()
            return newArr
        }
    }
    
    //获取最顶上的元素，还在容器中
    func top() -> T?
    {
        if self.isEmpty()
        {
            return nil
        }
        else
        {
            return self.stack.last
        }
    }
    
    //获取所有元素，元素还在容器中
    private func allItems() -> [T]
    {
        if self.isEmpty()
        {
            return []
        }
        else
        {
            let newArr = self.stack
            return newArr
        }
    }
    
    //栈是否为空
    func isEmpty()-> Bool
    {
        if self.stack.count > 0
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
            return self.stack.count
        }
    }

    //清空容器
    func clear()
    {
        self.stack.removeAll()
    }
    
}
