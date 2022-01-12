//
//  CKAlertView.h
//  FrameworkStruct
//
//  Created by 蒋旭蛟 on 2018/5/9.
//  Copyright © 2018年 蒋雪姣. All rights reserved.
//


/**
 弹出框
 */

#import <UIKit/UIKit.h>

@interface CKAlertView : UIAlertController

//对象的唯一识别key，用来标识每一个CKAlertView对象，做到唯一，防止重复创建该对象
@property(nonatomic, copy, readonly)NSString * _Nonnull identifierKey;

//工厂方法，创建弹窗
+(CKAlertView *_Nonnull)alertViewWithTitle:(NSString *_Nullable)title
                                   message:(NSString *_Nullable)message
                             identifierKey:(NSString *_Nonnull)key
                                 tintColor: (UIColor *_Nonnull)color
                               cancelTitle:( NSString *_Nullable)cancelTitle
                               cancelBlock:(void (^_Nullable)(UIAlertAction * _Nonnull action))cancel
                              confirmTitle:( NSString *_Nullable)confirmTitle
                              confirmBlock:(void (^_Nullable)(UIAlertAction * _Nonnull action))confirm
                          inViewController:(UIViewController *_Nullable)vc;

//工厂方法，创建弹窗，文字对齐
+(CKAlertView *_Nonnull)alertViewWithTitle:( NSString *_Nullable)title
                                   message:( NSString *_Nullable)message
                      messageAlign:(NSTextAlignment)align
                             identifierKey:(NSString *_Nonnull)key
                                 tintColor: (UIColor *_Nonnull)color
                               cancelTitle:( NSString *_Nullable)cancelTitle
                               cancelBlock:(void (^_Nullable)(UIAlertAction * _Nonnull action))cancel
                              confirmTitle:( NSString *_Nullable)confirmTitle
                              confirmBlock:(void (^_Nullable)(UIAlertAction * _Nonnull action))confirm
                          inViewController:(UIViewController *_Nullable)vc;

//消失掉所有的弹框
+(void)dismissAllAlertCompletion:(void(^_Nullable)(void))completion;


@end
