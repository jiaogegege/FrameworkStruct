//
//  FSTextField.h
//  FrameworkStruct
//
//  Created by jggg on 2018/5/11.
//  Copyright © 2018年 jggg. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FSTextField : UITextField
///标志符
@property(nonatomic, copy)NSString *identifier;

///工厂方法
+(FSTextField *)textFieldWithFrame:(CGRect)frame withIdentifier:(NSString *)identifier;


@end
