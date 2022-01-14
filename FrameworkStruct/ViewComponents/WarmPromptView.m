//
//  WarmPromptView.m
//  FrameworkStruct
//
//  Created by user on 2020/9/25.
//  Copyright © 2020 dyimedical. All rights reserved.
//

#import "WarmPromptView.h"
#import "OCHeader.h"

@implementation WarmPromptView

+(WarmPromptView *)getViewWithAction:(WpAction)action
{
    NSArray *nibView =  [[NSBundle mainBundle] loadNibNamed:@"WarmPromptView"owner:nil options:nil];
    WarmPromptView *upView = (WarmPromptView *)[nibView objectAtIndex:0];
    upView.frame = [Utility getWindow].bounds;
    upView.action = action;
    return upView;
}

- (IBAction)knownBtnAction:(UIButton *)sender {
    if (_action)
    {
        _action();
    }
    [self dismiss];
}

-(void)dismiss
{
    _action = nil;
    [self removeFromSuperview];
}


@end
