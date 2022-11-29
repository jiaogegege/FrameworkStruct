//
//  ThemeModel.h
//  FrameworkStruct
//
//  Created by  jggg on 2021/12/9.
//

/**
 * 从plist获取的主题对象，继承自NSObject，作为数据模型，方便使用copy等方法
 */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ThemeModel : NSObject

@property(nonatomic, copy)NSString *id;
@property(nonatomic, copy)NSString *fileName;
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *mainColor;
@property(nonatomic, copy)NSString *mainTitleColor;
@property(nonatomic, copy)NSString *subTitleColor;
@property(nonatomic, copy)NSString *contentTextColor;
@property(nonatomic, copy)NSString *hintTextColor;
@property(nonatomic, copy)NSString *backgroundColor;
@property(nonatomic, copy)NSString *contentBackgroundColor;
@property(nonatomic, copy)NSString *mainFont;
@property(nonatomic, copy)NSString *secondaryFont;
@property(nonatomic, copy)NSString *hintFont;
@property(nonatomic, copy)NSNumber *mainFontSize;
@property(nonatomic, copy)NSNumber *secondaryFontSize;
@property(nonatomic, copy)NSNumber *hintFontSize;
@property(nonatomic, copy)NSString *imageSuffix;

@end

NS_ASSUME_NONNULL_END
