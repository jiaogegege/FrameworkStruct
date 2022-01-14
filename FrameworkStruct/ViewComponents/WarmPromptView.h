//
//  WarmPromptView.h
//  FrameworkStruct
//
//  Created by user on 2020/9/25.
//  Copyright © 2020 dyimedical. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WpAction)(void);

NS_ASSUME_NONNULL_BEGIN

@interface WarmPromptView : UIView

@property(nonatomic, copy)WpAction action;

- (IBAction)knownBtnAction:(UIButton *)sender;

+(WarmPromptView *)getViewWithAction:(WpAction)action;

@end

NS_ASSUME_NONNULL_END
