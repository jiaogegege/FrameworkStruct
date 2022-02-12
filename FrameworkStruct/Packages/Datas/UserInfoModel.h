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

@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *token;      //登录有效性标识
@property (copy, nonatomic) NSString *refreshToken;   //刷新标识
@property (assign, nonatomic) BOOL isAuth;      //是否认证为卖家
@property (assign, nonatomic) BOOL canLoan;     //是否可贷款用户

@property(nonatomic, copy)NSString *id;
@property(nonatomic, copy)NSString *userPhone;
@property(nonatomic, copy)NSString *userPassword;
@property(nonatomic, copy)NSString *updateDate;
@property(nonatomic, copy)NSString *createDate;

@end

NS_ASSUME_NONNULL_END
