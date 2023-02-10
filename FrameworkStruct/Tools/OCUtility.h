//
//  OCUtility.h
//  FrameworkStruct
//
//  Created by  jggg on 2022/5/10.
//

/**
 OC特定工具类方法
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCUtility : NSObject

/**
 提供给swift使用的捕获NSException的方法,使用示例:
 
 do {
     try OCUtility.catchException {

        // calls that might throw an NSException
     }
 }
 catch {
     print("An error ocurred: \(error)")
 }
 */
+ (BOOL)catchException:(void(^)(void))tryBlock error:(__autoreleasing NSError **)error;

//获取带行高的属性文本
+ (NSMutableAttributedString *)textAttrLine:(NSString *)text attributes:(NSDictionary *)attr lineSpacing:(CGFloat)lineSpacing;

//计算文本行数和每行文本
+ (NSArray *)getLinesArrayOfStringInLabel:(NSString *)string font:(UIFont *)font andLableWidth:(CGFloat)lableWidth andLineSpace:(CGFloat)lineSpace;

@end

NS_ASSUME_NONNULL_END
