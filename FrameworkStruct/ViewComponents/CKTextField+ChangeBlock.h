//
//  CKTextField+ChangeBlock.h
//  FrameworkStruct
//
//  Created by 蒋旭蛟 on 2018/5/11.
//  Copyright © 2018年 蒋雪姣. All rights reserved.
//

#import "CKTextField.h"

typedef void(^TextFieldActionBlock)(NSString *text);

@interface CKTextField (ChangeBlock)

///添加回调方法
-(void)addHandleControlEvent:(UIControlEvents)controlEvent withBlock:(TextFieldActionBlock)block;

@end
