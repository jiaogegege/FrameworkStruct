//
//  UIButton+ButtonBlock.m
//  PostpartumRehabilitation
//
//  Created by user on 2018/5/11.
//  Copyright © 2018年 dyimedical. All rights reserved.
//

#import "UIButton+ButtonBlock.h"

@implementation UIButton (ButtonBlock)

static char overviewKey;

- (void)handleControlEvent:(UIControlEvents)event withBlock:(ButtonActionBlock)block {
    objc_setAssociatedObject(self, &overviewKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}


- (void)callActionBlock:(id)sender {
    ButtonActionBlock block = (ButtonActionBlock)objc_getAssociatedObject(self, &overviewKey);
    if (block)
    {
        block(self);
    }
}



@end
