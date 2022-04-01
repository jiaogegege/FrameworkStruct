//
//  GraphicsManager.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/1/5.
//

/**
 * 系统绘图组件管理，绘制各种图形、表格等
 */
import UIKit

class GraphicsManager: OriginManager
{
    //MARK: 属性
    //单例
    static let shared = GraphicsManager()
    
    
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


//接口方法
extension GraphicsManager: ExternalInterface
{
    ///绘制一个简单表格
    func getSimpleTableView(frame: CGRect, data: Array<Array<String>>) -> SimpleTableView
    {
        let tbView = SimpleTableView(frame: frame)
        tbView.dataArray = data
        tbView.updateView()
        return tbView
    }
    
}
