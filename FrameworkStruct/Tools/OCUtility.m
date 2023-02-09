//
//  OCUtility.m
//  FrameworkStruct
//
//  Created by  jggg on 2022/5/10.
//

#import "OCUtility.h"
#import "FSException.h"
#import <CoreText/CoreText.h>

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

//获取文本行数
+ (int)getNumberOfLinesWithText:(NSAttributedString *)text andLabelWidth:(CGFloat)width
{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)text);
    CGMutablePathRef Path = CGPathCreateMutable();
    CGPathAddRect(Path, NULL ,CGRectMake(0 , 0 , width, INT_MAX));
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    // 得到字串在frame中被自动分成了多少个行。
    CFArrayRef rows = CTFrameGetLines(frame);
    // 实际行数
    int numberOfLines = (int)CFArrayGetCount(rows);
    CFRelease(frame);
    CGPathRelease(Path);
    CFRelease(framesetter);
    return numberOfLines;
}


@end
