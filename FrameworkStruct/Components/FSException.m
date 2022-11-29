//
//  FSException.m
//  FrameworkStruct
//
//  Created by  jggg on 2022/5/10.
//

#import "FSException.h"

@implementation FSException

/**初始化方法*/
-(instancetype)initWithName:(NSExceptionName)aName code:(FSExceptionCode)code rank:(FSExceptionSeverityRank)rank reason:(NSString *)aReason userInfo:(NSDictionary *)aUserInfo;
{
    if (self = [super initWithName:aName reason:aReason userInfo:aUserInfo])
    {
        _code = code;
        _rank = rank;
    }
    return self;
}

///对于预定义的异常,使用该便利方法
+(FSException *)exceptionWithCode:(FSExceptionCode)code userInfo:(NSDictionary *)aUserInfo;
{
    NSString *name = [FSException getExceptionName:code];
    FSExceptionSeverityRank rank = [FSException getExceptionRank:code];
    FSException *exp = [[FSException alloc] initWithName:name code:code rank:rank reason:name userInfo:aUserInfo];
    return exp;
}

//获取异常的名字
+(NSString *_Nonnull)getExceptionName:(FSExceptionCode)code
{
    switch (code) {
        case FSExceptionCodeNone:
            return @"No Exception";
            break;
            
        default:
            return @"Unknown Exception";
            break;
    }
}

//获取异常等级
+(FSExceptionSeverityRank)getExceptionRank:(FSExceptionCode)code
{
    switch (code) {
        case FSExceptionCodeNone:
            return FSExceptionSeverityRankVeryLow;
            break;
            
        default:
            return FSExceptionSeverityRankVeryLow;
            break;
    }
}


@end
