//
//  CKTextField+ChangeBlock.h
//  PostpartumRehabilitation
//
//  Created by user on 2018/5/11.
//  Copyright © 2018年 dyimedical. All rights reserved.
//

#import "CKTextField.h"

typedef void(^TextFieldActionBlock)(NSString *text);

@interface CKTextField (ChangeBlock)

///添加回调方法
-(void)addHandleControlEvent:(UIControlEvents)controlEvent withBlock:(TextFieldActionBlock)block;

@end
