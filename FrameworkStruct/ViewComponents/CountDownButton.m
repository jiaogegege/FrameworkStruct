//
//  CountDownButton.m
//  FrameworkStruct
//
//  Created by 蒋旭蛟 on 2018/5/11.
//  Copyright © 2018年 蒋雪姣. All rights reserved.
//

#import "CountDownButton.h"
#import "OCHeader.h"

///静态变量，记录已经创建的UIButton对象，强引用
static NSMutableDictionary *identifierKeyMap;
static int maxButtonCount = 5;          //最大可同时存在的倒计时按钮数量

@interface CountDownButton()
{
    NSTimer *_timer;        //倒计时
//当前在容器中的按钮的id，由于在新手机号界面id是可以改变的，所以需要记录进入容器时候的id，可以在倒计时结束后正确地从容器移除
    NSString *_currentIdentifierKey;
    
}
@end

@implementation CountDownButton

    ///返回是否达到了同时存在的定时器上限
+(BOOL)isFull
{
    BOOL ret = NO;
    if (identifierKeyMap && [identifierKeyMap count] >= maxButtonCount) //如果容器中存在大于等于5个定时器，说明已经满了
    {
        ret = YES;
    }
    return ret;
}

///当前identifier的按钮是否已经存在容器中
+(BOOL)isExist:(CountDownButton *)btn
{
    CountDownButton *obj = (CountDownButton *)identifierKeyMap[[btn getCurrentIdentifierKey]];
    if (obj)
    {
            //如果已经存在，那么用这个替换原来的，并且开始这个的倒计时
        btn.restTime = obj.restTime;    //获取剩余倒计时时间
        [obj cancel];   //取消容器中那个
        [btn startCountDown];   //开始这个倒计时并设置这个到容器中
        return YES;
    }
    else
    {
        return NO;
    }
}

    ///工厂方法
+(instancetype)buttonWithType:(UIButtonType)buttonType withNormalTitle:(NSString *)normalTitle withCountingTitle:(NSString *)countingTitle withIdentifier:(NSString *)identifier
{
    if (!identifierKeyMap)      //如果没有那么创建
    {
        identifierKeyMap = [NSMutableDictionary dictionary];
    }
    if ([identifierKeyMap objectForKey:identifier])      //如果有值那么不创建，返回已有的按钮
    {
        return [identifierKeyMap objectForKey:identifier];
    }
    //创建一个新的按钮
    CountDownButton *btn = [CountDownButton buttonWithType:buttonType];
    btn.identifierKey = identifier;
    btn.totalTime = 60;     //倒计时总时间默认60
    btn.countNormalTitle = normalTitle;
    btn.countingDownTitle = countingTitle;
    btn.countingStyle = CountDownButtonStyleLight;
    [btn setTitle:normalTitle forState:UIControlStateNormal];
    btn.backgroundColor = UIColor.cAccent;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    btn.layer.cornerRadius = btn.frame.size.height / 2.0;
    //添加点击事件
    [btn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        //成功的判断条件：同时存在的倒计时个数不足5个
        if (![CountDownButton isFull])
        {
            //如果容器不足5个，还需要判断这个identifier的按钮是否已经存在容器中，如果存在，那么直接开始倒计时
            if ([CountDownButton isExist:btn])
            {
                    //失败
                NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:ClickActionFailureCodeTooFrequent userInfo:@{NSLocalizedDescriptionKey: CLICK_ACTION_FAILURE_MESSAGE_TOO_FREQUENT, NSLocalizedFailureReasonErrorKey: CLICK_ACTION_FAILURE_MESSAGE_TOO_FREQUENT}];
                if (btn.onFailure)
                {
                    btn.onFailure(error);
                }
                else
                {
                    NSLog(@"未设置回调");
                }
            }
            else    //容器中还不存在，那么执行成功的回调
            {
                    //成功
                if (btn.onSuccess)
                {
                    btn.onSuccess(btn);
                }
                else
                {
                    NSLog(@"未设置回调");
                }
            }
        }
        else
        {
            //失败
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:ClickActionFailureCodeTooFrequent userInfo:@{NSLocalizedDescriptionKey: CLICK_ACTION_FAILURE_MESSAGE_TOO_FREQUENT, NSLocalizedFailureReasonErrorKey: CLICK_ACTION_FAILURE_MESSAGE_TOO_FREQUENT}];
            if (btn.onFailure)
            {
                btn.onFailure(error);
            }
            else
            {
                NSLog(@"未设置回调");
            }
        }
    }];
    return btn;
}

    ///用户如果点击了按钮，传入最大同时存在的倒计时个数，在成功和失败的回调中处理点击事件
-(void)setAttemptToStartTimerWithMaxCount:(int)maxCount onSuccess:(ClickActionSuccessBlock)onSuccess onFailure:(ClickActionFailureBlock)onFailure
{
    _onSuccess = onSuccess;
    _onFailure = onFailure;
    if (maxCount > 0)   //当最大个数大于0时才设置，处理负数和0的情况，必须要大于0
    {
        maxButtonCount = maxCount;
    }
}

///设置倒计时时间
-(void)setTotalTime:(int)totalTime
{
    _totalTime = totalTime;
    self.restTime = totalTime;
}

    ///获得当前正在倒计时的按钮的id
-(NSString *)getCurrentIdentifierKey
{
    return _currentIdentifierKey ? _currentIdentifierKey : self.identifierKey;
}

    ///开始倒计时，就把自己加入唯一识别map中
-(void)startCountDown
{
    if (!_timer)        //如果没有值，那么创建并开始倒计时
    {
        //设定初始状态
        [self setDisabled];
        [self setTitle:[NSString stringWithFormat:@"%@(%d)", _countingDownTitle, _restTime] forState:UIControlStateNormal];
        
        _currentIdentifierKey = self.identifierKey;
        [identifierKeyMap setObject:self forKey:_currentIdentifierKey];        //加入唯一map中，防止重复创建
        
        __weak typeof(self) weak = self;
        _timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            self -> _restTime = --self -> _restTime;
            [weak setTitle:[NSString stringWithFormat:@"%@(%d)", self -> _countingDownTitle, self -> _restTime] forState:UIControlStateNormal];
                //倒计时回调
            if (self -> _countingBlock)
            {
                self -> _countingBlock(self -> _restTime);
            }
            if (self -> _restTime < 0)
            {
                [self -> _timer invalidate];
                self -> _timer = nil;
                NSAssert(self -> _currentIdentifierKey, @"倒计时当前identifier为空");
                [identifierKeyMap removeObjectForKey:self -> _currentIdentifierKey];       //从唯一列表中移除
                [weak setNormalState];
            }
        }];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

///取消倒计时
-(void)cancel
{
    [_timer invalidate];
    _timer = nil;
    self.countingBlock = nil;
    self.onSuccess = nil;
    self.onFailure = nil;
    [identifierKeyMap removeObjectForKey:[self getCurrentIdentifierKey]];       //从唯一列表中移除
}

    ///是否在倒计时
-(BOOL)isCountingDown
{
    return _timer ? YES : NO;
}

    ///是否可以倒计时，需要考虑的情况：如果此按钮正在倒计时，那么不应该开始倒计时；如果容器中已经满了，那么也不应该开始倒计时。这个方法主要用于外部判断是否可以开始倒计时，比如语音验证码
-(BOOL)canStartCountDown
{
    BOOL ret = YES;
    if (self.isCountingDown)
    {
        ret = NO;
    }
    else if ([CountDownButton isFull])
    {
        ret = NO;
    }
    return ret;
}

    ///设置为不可点击
-(void)setDisabled
{
    switch (self.countingStyle) {
        case CountDownButtonStyleLight:
        {
            self.layer.borderColor = [UIColor.cGray_D6D6D9 CGColor];
            self.layer.borderWidth = 1;
            self.backgroundColor = [UIColor whiteColor];
            [self setTitleColor:UIColor.cGray_D6D6D9 forState:UIControlStateNormal];
            self.enabled = NO;
            break;
        }
        case CountDownButtonStyleDark:
        {
            self.layer.borderColor = [UIColor.cGray_D6D6D9 CGColor];
            self.layer.borderWidth = 0;
            self.backgroundColor = UIColor.cGray_D6D6D9;
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.enabled = NO;
            break;
        }
        default:
            break;
    }

}
    ///设置为可点击
-(void)setEnabled
{
    if (!_timer)    //只有剩余时间为60的时候可以设置为可点击
    {
        [self setNormalState];
    }
    
}

///设置为原始状态
-(void)setNormalState
{
    self.layer.borderWidth = 0;
    self.layer.borderColor = [UIColor.cAccent CGColor];
    self.restTime =self.totalTime;       //剩余时间创建的时候60，倒计时开始后递减
    [self setTitle:self.countNormalTitle forState:UIControlStateNormal];
    self.backgroundColor = UIColor.cAccent;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.enabled = YES;
}

@end
