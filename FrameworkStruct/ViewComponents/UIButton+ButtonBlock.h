//
//  UIButton+ButtonBlock.h
//  PostpartumRehabilitation
//
//  Created by user on 2018/5/11.
//  Copyright © 2018年 dyimedical. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

///回调类型
typedef void (^ButtonActionBlock)(UIButton *sender);

@interface UIButton (ButtonBlock)

///添加回调方法
- (void)handleControlEvent:(UIControlEvents)controlEvent withBlock:(ButtonActionBlock)action;


@end
