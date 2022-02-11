//
//  HomeDataModel.m
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/2/11.
//

#import "HomeDataModel.h"

@implementation HomeInfoModel

@end

@implementation ActivityGoodInfoModel

@end

@implementation ActivityInfoModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"contentList": @"ActivityGoodInfoModel"
    };
}
@end

@implementation CycleImageModel

@end

@implementation ActivityModuleInfoModel

@end

@implementation HomeDataModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"mainList": @"HomeInfoModel",
        @"activityList": @"ActivityInfoModel",
        @"homeBanner": @"CycleImageModel"
    };
}
@end
