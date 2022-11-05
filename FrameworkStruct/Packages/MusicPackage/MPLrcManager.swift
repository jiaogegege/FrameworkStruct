//
//  MPLrcManager.swift
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/11/5.
//

/**
 歌词管理
 目前只支持自己下载然后上传到iCloud，注意文件名保持一致
 
 可参考的歌词搜索网站：
 https://www.gecimao.com/search/%E5%A4%95%E6%97%A5%E5%9D%82
 https://www.gecimao.com/search/夕日坂
 */
import UIKit

class MPLrcManager: OriginManager
{
    //MARK: 属性
    //单例
    static let shared = MPLrcManager()
    
    
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


extension MPLrcManager: ExternalInterface
{
    
}
