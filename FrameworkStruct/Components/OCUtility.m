//
//  OCUtility.m
//  FrameworkStruct
//
//  Created by  jggg on 2022/5/10.
//

#import "OCUtility.h"
#import "FSException.h"

@implementation OCUtility

///提供给swift使用的捕获NSException的方法
+ (BOOL)catchException:(void(^)(void))tryBlock error:(__autoreleasing NSError **)error
{
    @try {
        tryBlock();
        return YES;
    }
    @catch (FSException *exception) {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[NSLocalizedDescriptionKey] = exception.name;
        userInfo[NSLocalizedFailureReasonErrorKey] = exception.reason;
        [userInfo addEntriesFromDictionary:exception.userInfo];
        *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:exception.code userInfo:userInfo];
        return NO;
    }
}


@end
