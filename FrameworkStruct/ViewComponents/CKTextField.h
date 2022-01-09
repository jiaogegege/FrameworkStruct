//
//  CKTextField.h
//  FrameworkStruct
//
//  Created by 蒋旭蛟 on 2018/5/11.
//  Copyright © 2018年 蒋雪姣. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CKTextField : UITextField
///标志符
@property(nonatomic, copy)NSString *identifier;

///工厂方法
+(CKTextField *)textFieldWithFrame:(CGRect)frame withIdentifier:(NSString *)identifier;


@end
