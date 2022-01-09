//
//  UIButton+ButtonBlock.h
//  FrameworkStruct
//
//  Created by 蒋旭蛟 on 2018/5/11.
//  Copyright © 2018年 蒋雪姣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

///回调类型
typedef void (^ButtonActionBlock)(UIButton *sender);

@interface UIButton (ButtonBlock)

///添加回调方法
- (void)handleControlEvent:(UIControlEvents)controlEvent withBlock:(ButtonActionBlock)action;


@end
