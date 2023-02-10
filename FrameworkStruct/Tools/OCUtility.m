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

//获取带行高的属性文本
+ (NSMutableAttributedString *)textAttrLine:(NSString *)text attributes:(NSDictionary *)attr lineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString *textAttr = [[NSMutableAttributedString alloc] initWithString:text attributes:attr];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = lineSpacing;
    [textAttr addAttribute:NSParagraphStyleAttributeName
                                     value:paragraph
                                     range:NSMakeRange(0, [textAttr length])];
    return textAttr;
}

//计算文本行数和每行文本
+ (NSArray *)getLinesArrayOfString:(NSString *)string font:(UIFont *)font labelWidth:(CGFloat)labelWidth lineSpace:(CGFloat)lineSpace
{
    CTFontRef myFont = CTFontCreateWithName(( CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [self textAttrLine:string attributes:@{NSFontAttributeName: font} lineSpacing:lineSpace];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge  id)myFont range:NSMakeRange(0, attStr.length)];
    CFRelease(myFont);
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(( CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,labelWidth,100000));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = ( NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    for (id line in lines) {
        CTLineRef lineRef = (__bridge  CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        NSString *lineString = [string substringWithRange:range];
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithFloat:0.0]));
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithInt:0.0]));
        [linesArray addObject:lineString];
    }
    
    CGPathRelease(path);
    CFRelease( frame );
    CFRelease(frameSetter);
    return (NSArray *)linesArray;
}


@end
