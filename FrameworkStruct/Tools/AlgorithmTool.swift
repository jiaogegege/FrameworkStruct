//
//  AlgorithmTool.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/12/2.
//

/**
 提供一些算法工具，比如排序算法、遍历算法等，一般用不着，多用于试验性质
 该文件中所有方法和变量以`a_`开头
 */
import Foundation

/**************************************** 排序算法 Section Begin ***************************************/

///冒泡排序，默认从小到大
///参数：arr：要排序的数组；asc：是否升序
func a_bubbleSort<T: Comparable>(_ arr: [T], asc: Bool = true) -> [T]
{
    var newArr = arr
    for i in 0..<arr.count - 1
    {
        for j in 0..<arr.count - 1 - i
        {
            if asc ? (newArr[j] > newArr[j + 1]) : (newArr[j] < newArr[j + 1])
            {
                newArr.swapAt(j, j + 1)
            }
        }
    }
    return newArr
}

///选择排序，默认从小到大
///参数：arr：要排序的数组；asc：是否升序
func a_selectSort<T: Comparable>(_ arr: [T], asc: Bool = true) -> [T]
{
    //如果只有一个直接返回
    if arr.count <= 1
    {
        return arr
    }
    else if arr.count == 2  //如果有两个，那么比较大小并返回
    {
        return asc ? (arr[0] <= arr[1] ? arr : [arr[1], arr[0]]) : (arr[0] >= arr[1] ? arr : [arr[1], arr[0]])
    }
    else
    {
        var leftArr: [T] = []
        var rightArr: [T] = []
        var originArr = arr
        while originArr.count > 0 {
            var min: T = originArr.first!
            var minIndex = 0
            var max: T = originArr.last!
            var maxIndex = originArr.count - 1
            for (index, item) in originArr.enumerated()   //找到最大最小值
            {
                if item <= min {
                    min = item
                    minIndex = index
                }
                if item > max {
                    max = item
                    maxIndex = index
                }
            }
            //获取最大最小值
            if asc
            {
                leftArr.append(min)
                if maxIndex != minIndex
                {
                    rightArr.insert(max, at: 0)
                }
            }
            else
            {
                leftArr.append(max)
                if minIndex != maxIndex
                {
                    rightArr.insert(min, at: 0)
                }
            }
            //删除originArr中的值
            if maxIndex > minIndex
            {
                originArr.remove(at: maxIndex)
                originArr.remove(at: minIndex)
            }
            else if maxIndex < minIndex
            {
                originArr.remove(at: minIndex)
                originArr.remove(at: maxIndex)
            }
            else    //index相等的情况，删一个就行
            {
                originArr.remove(at: minIndex)
            }
        }
        return leftArr + rightArr
    }
}

///插入排序，默认从小到大
///参数：arr：要排序的数组；asc：是否升序
func a_insertSort<T: Comparable>(_ arr: [T], asc: Bool = true) -> [T]
{
    var newArr: [T] = []
    for item in arr
    {
        var insertIndex = 0     //新元素应该被插入的位置
        for (index, it) in newArr.enumerated()
        {
            //如果是最后一个了，那么不需要检查`index + 1`
            if ((asc ? item >= it : item <= it) && index >= newArr.count - 1) || ((asc ? item >= it : item <= it) && (asc ? item < newArr[index + 1] : item > newArr[index + 1]))
            {
                insertIndex = index + 1
                break
            }
        }
        newArr.insert(item, at: insertIndex)
    }
    return newArr
}


/**************************************** 排序算法 Section End ***************************************/
