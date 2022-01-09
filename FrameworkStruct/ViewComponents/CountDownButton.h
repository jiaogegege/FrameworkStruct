//
//  CountDownButton.h
//  FrameworkStruct
//
//  Created by 蒋旭蛟 on 2018/5/11.
//  Copyright © 2018年 蒋雪姣. All rights reserved.
//


/**
 倒计时按钮，倒计时的时候，这个按钮一直存在，即使退出界面也可以存在，直到倒计时结束，恢复可点击
 */

#import <UIKit/UIKit.h>

///倒计时按钮显示风格，控制倒计时的时候显示的外表
typedef NS_ENUM(NSInteger, CountDownButtonStyle) {
    CountDownButtonStyleLight,
    CountDownButtonStyleDark,
    CountDownButtonStyleSpeech,
};

typedef void(^CountDownBlock)(int restTime);    //倒计时回调方法
typedef void(^ClickActionSuccessBlock)(UIButton *button);      //点击按钮后成功的回调
typedef void(^ClickActionFailureBlock)(NSError *error);     //点击按钮后失败的回调

//验证码发送失败的错误码
typedef NS_ENUM(NSInteger, ClickActionFailureCode) {
    ClickActionFailureCodeTooFrequent = 1         //验证码发送过于频繁
};
#define CLICK_ACTION_FAILURE_MESSAGE_TOO_FREQUENT @"验证码发送过于频繁，请稍候重试"

@interface CountDownButton : UIButton

///倒计时剩余时间
@property(nonatomic, assign)int restTime;
///唯一识别码
@property(nonatomic, copy)NSString *identifierKey;
///倒计时时长，默认60，可自定义
@property(nonatomic, assign)int totalTime;
///倒计时的时候显示的文字
@property(nonatomic, copy)NSString *countingDownTitle;
///非倒计时的时候显示的文字
@property(nonatomic, copy)NSString *countNormalTitle;
///倒计时显示风格
@property(nonatomic, assign)CountDownButtonStyle countingStyle;
///倒计时回调
@property(nonatomic, copy)CountDownBlock countingBlock;
///点击按钮试图开始倒计时成功的回调
@property(nonatomic, copy)ClickActionSuccessBlock onSuccess;
///点击按钮试图开始倒计时失败的回调，失败的原因是超过了同时最多5个的限制
@property(nonatomic, copy)ClickActionFailureBlock onFailure;

///工厂方法
+(CountDownButton *)buttonWithType:(UIButtonType)buttonType withNormalTitle:(NSString *)normalTitle withCountingTitle:(NSString *)countingTitle withIdentifier:(NSString *)identifier;

///返回是否达到了同时存在的定时器上限
+(BOOL)isFull;

    ///当前identifier的按钮是否已经存在容器中
+(BOOL)isExist:(CountDownButton *)btn;

///用户如果点击了按钮，传入最大同时存在的倒计时个数，在成功和失败的回调中处理点击事件
-(void)setAttemptToStartTimerWithMaxCount:(int)maxCount onSuccess:(ClickActionSuccessBlock)onSuccess onFailure:(ClickActionFailureBlock)onFailure;

///开始倒计时
-(void)startCountDown;

///获得当前正在倒计时的按钮的id
-(NSString *)getCurrentIdentifierKey;

///设置为不可点击
-(void)setDisabled;

///设置为可点击
-(void)setEnabled;

///是否在倒计时
-(BOOL)isCountingDown;

///是否可以倒计时，需要考虑的情况：如果此按钮正在倒计时，那么不应该开始倒计时；如果容器中已经满了，那么也不应该开始倒计时。这个方法主要用于外部判断是否可以开始倒计时，比如语音验证码
-(BOOL)canStartCountDown;

@end
