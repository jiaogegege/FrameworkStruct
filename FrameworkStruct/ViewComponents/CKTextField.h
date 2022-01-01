//
//  CKTextField.h
//  PostpartumRehabilitation
//
//  Created by user on 2018/5/11.
//  Copyright © 2018年 dyimedical. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CKTextField : UITextField
///标志符
@property(nonatomic, copy)NSString *identifier;

///工厂方法
+(CKTextField *)textFieldWithFrame:(CGRect)frame withIdentifier:(NSString *)identifier;


@end
