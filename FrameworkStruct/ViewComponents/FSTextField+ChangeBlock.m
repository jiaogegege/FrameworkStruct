//
//  FSTextField+ChangeBlock.m
//  FrameworkStruct
//
//  Created by 蒋旭蛟 on 2018/5/11.
//  Copyright © 2018年 蒋雪姣. All rights reserved.
//

#import "FSTextField+ChangeBlock.h"
#import <objc/runtime.h>

@implementation FSTextField (ChangeBlock)

static char blockKey;

    ///添加回调方法
-(void)addHandleControlEvent:(UIControlEvents)controlEvent withBlock:(TextFieldActionBlock)block
{
    objc_setAssociatedObject(self, &blockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(textFieldTextChange:) forControlEvents:controlEvent];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

///监听textField事件
-(void)textFieldTextChange:(FSTextField *)textField
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
