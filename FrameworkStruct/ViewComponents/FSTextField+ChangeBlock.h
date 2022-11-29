//
//  FSTextField+ChangeBlock.h
//  FrameworkStruct
//
//  Created by jggg on 2018/5/11.
//  Copyright © 2018年 jggg. All rights reserved.
//

#import "FSTextField.h"

typedef void(^TextFieldActionBlock)(NSString *text);

@interface FSTextField (ChangeBlock)

///添加回调方法
-(void)addHandleControlEvent:(UIControlEvents)controlEvent withBlock:(TextFieldActionBlock)block;

@end
