//
//  FSException.h
//  FrameworkStruct
//
//  Created by  jggg on 2022/5/10.
//

/**
 异常对象，包含异常等级，异常状态码等
 */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FSExceptionCode) {
    FSExceptionCodeNone = 0,        //无异常
    
};

typedef NS_ENUM(NSInteger, FSExceptionSeverityRank)
{
    FSExceptionSeverityRankVeryHigh = 1000,         //非常高的严重程度
    FSExceptionSeverityRankHigh = 100,        //错误严重程度高，需要特殊处理
    FSExceptionSeverityRankNormal = 0,         //一般严重程度
    FSExceptionSeverityRankLow = -100,         //比较低的严重程度，可以以Toast提醒的方式告知外部，比如电池电量低
    FSExceptionSeverityRankVeryLow = -1000      //非常低的严重程度，认为无异常，比如一切正常
};

@interface FSException : NSException
/**
 异常码
 */
@property(nonatomic, assign, readonly)FSExceptionCode code;
/**
 异常等级
 */
@property(nonatomic, assign, readonly)FSExceptionSeverityRank rank;

/**通用初始化方法*/
-(instancetype)initWithName:(NSExceptionName)aName code:(FSExceptionCode)code rank:(FSExceptionSeverityRank)rank reason:(NSString *)aReason userInfo:(NSDictionary *)aUserInfo;

///对于预定义的异常,使用该便利方法
+(FSException *)exceptionWithCode:(FSExceptionCode)code userInfo:(NSDictionary *)aUserInfo;

//获取异常的名字
+(NSString *_Nonnull)getExceptionName:(FSExceptionCode)code;

//获取异常等级
+(FSExceptionSeverityRank)getExceptionRank:(FSExceptionCode)code;


@end

NS_ASSUME_NONNULL_END
