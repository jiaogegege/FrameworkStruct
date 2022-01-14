//
//  FSTextField.m
//  FrameworkStruct
//
//  Created by 蒋旭蛟 on 2018/5/11.
//  Copyright © 2018年 蒋雪姣. All rights reserved.
//

#import "FSTextField.h"


@interface FSTextField()<UITextFieldDelegate>

@end

@implementation FSTextField

    ///工厂方法
+(FSTextField *)textFieldWithFrame:(CGRect)frame withIdentifier:(NSString *)identifier
{
    FSTextField *textField = [[FSTextField alloc] initWithFrame:frame];
    textField.identifier = identifier;
    return textField;
}

    // 返回placeholderLabel的bounds，改变返回值，是调整placeholderLabel的位置
- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return CGRectMake(0, 0 , self.bounds.size.width, self.bounds.size.height);
}
    // 这个函数是调整placeholder在placeholderLabel中绘制的位置以及范围
- (void)drawPlaceholderInRect:(CGRect)rect {
    [super drawPlaceholderInRect:CGRectMake(0, 0 , self.bounds.size.width, self.bounds.size.height)];
}



@end
