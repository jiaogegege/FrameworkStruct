//
//  CKActionSheet.h
//  PostpartumRehabilitation
//
//  Created by user on 2018/5/9.
//  Copyright © 2018年 dyimedical. All rights reserved.
//


/**
 底部选择条，用于选择照片等
 */


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CKActionSheetType) {
    CKActionSheetTypeDefault,       //默认，只有取消按钮
    CKActionSheetTypeTakePhoto     //获取照片，相机和相册
    
};

@interface CKActionSheet : UIAlertController

///弹框的唯一标志符
@property(nonatomic, copy)NSString *identifierKey;

///工厂方法，创建弹窗
+(instancetype)actionSheetWithTitle:( NSString *)title actionArray:(NSArray<UIAlertAction *> *)actionArray identifierKey:(NSString *)key withTintColor:(UIColor *)tintColor inViewController:(UIViewController *)vc;

@end
