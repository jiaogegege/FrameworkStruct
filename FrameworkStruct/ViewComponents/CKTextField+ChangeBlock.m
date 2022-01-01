//
//  CKTextField+ChangeBlock.m
//  PostpartumRehabilitation
//
//  Created by user on 2018/5/11.
//  Copyright © 2018年 dyimedical. All rights reserved.
//

#import "CKTextField+ChangeBlock.h"
#import <objc/runtime.h>

@implementation CKTextField (ChangeBlock)

static char blockKey;

    ///添加回调方法
-(void)addHandleControlEvent:(UIControlEvents)controlEvent withBlock:(TextFieldActionBlock)block
{
    objc_setAssociatedObject(self, &blockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(textFieldTextChange:) forControlEvents:controlEvent];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

///监听textField事件
-(void)textFieldTextChange:(CKTextField *)textField
{
    TextFieldActionBlock block = objc_getAssociatedObject(textField, &blockKey);
    if (block)
    {
        if ([textField.identifier isEqualToString:self.identifier])
        {
            block(textField.text);
        }
        
    }
}

@end
