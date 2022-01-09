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
@property(nonatomic, copy, readonly)NSString *identifierKey;

//工厂方法，创建弹窗
+(CKAlertView *)alertViewWithTitle:( NSString *)title
                           message:( NSString *)message
                     identifierKey:(NSString *)key
                       cancelTitle:( NSString *)cancelTitle
                       cancelBlock:(void (^)(UIAlertAction *action))cancel
                      confirmTitle:( NSString *)confirmTitle
                      confirmBlock:(void (^)(UIAlertAction *action))confirm
                  inViewController:(UIViewController *)vc;

//工厂方法，创建弹窗，文字对齐
+(CKAlertView *)alertViewWithTitle:( NSString *)title
                           message:( NSString *)message
                      messageAlign:(NSTextAlignment)align
                     identifierKey:(NSString *)key
                       cancelTitle:( NSString *)cancelTitle
                       cancelBlock:(void (^)(UIAlertAction *action))cancel
                      confirmTitle:( NSString *)confirmTitle
                      confirmBlock:(void (^)(UIAlertAction *action))confirm
                  inViewController:(UIViewController *)vc;

//消失掉所有的弹框
+(void)dismissAllAlertCompletion:(void(^)(void))completion;


@end
