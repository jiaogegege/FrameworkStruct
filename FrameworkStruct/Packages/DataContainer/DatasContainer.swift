//
//  DatasContainer.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/2/15.
//

/**
 * 集中的通用数据容器
 * 对于小规模的数据，可以将项目中使用的所有数据模型都放在这个容器中；对于大型项目，数据模型很多，可以根据模块划分创建多个数据容器，然后综合到这个集中的数据容器中，当然也可以独立访问，根据实际情况取舍
 */
import UIKit

class DatasContainer: OriginContainer
{
    //MARK: 属性
    //单例
    static let shared = DatasContainer()
    
    //数据库存取器
    fileprivate lazy var dba = DatabaseAccessor.shared
    
    
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

//接口方法，提供具体的数据访问方法
extension DatasContainer: ExternalInterface
{
    ///获取本地所有用户信息
    func getAllUserInfo(_ completion: @escaping ((_ users: [UserInfoModel]?) -> Void))
    {
        if let users = self.get(key: DCDataKey.allUserInfo)
        {
            completion(users as? [UserInfoModel])
        }
        else    //如果容器中没有，那么从数据库中获取
        {
            dba.queryAllUsersInfo { users in
                //查询到后先保存到容器中
                if let users = users {
                    self.mutate(key: DCDataKey.allUserInfo, value: users)
                }
                completion(users)   //可能为nil
            }
        }
    }
    
    ///获取当前登录的用户信息,可能为nil
    func getCurrentUserInfo() -> UserInfoModel?
    {
        guard let user = self.get(key: DCDataKey.currentUserInfo) as? UserInfoModel else {
            return nil
        }
        return user
    }
    
    
    
    
    
}
