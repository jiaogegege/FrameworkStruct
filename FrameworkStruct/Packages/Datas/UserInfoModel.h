//
//  UserInfoModel.h
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/1/28.
//

/**
 定义用户相关的数据对象
 */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoModel : NSObject

@property(nonatomic, copy)NSString *id;
@property(nonatomic, copy)NSString *userPhone;
@property(nonatomic, copy)NSString *userPassword;
@property(nonatomic, copy)NSString *updateDate;
@property(nonatomic, copy)NSString *createDate;

@end

NS_ASSUME_NONNULL_END
