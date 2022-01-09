//
//  CKPhotoSelectSheet.h
//  FrameworkStruct
//
//  Created by 蒋旭蛟 on 2018/5/11.
//  Copyright © 2018年 蒋雪姣. All rights reserved.
//

#import "CKActionSheet.h"

@interface CKPhotoSelectSheet : CKActionSheet

///工厂方法，创建照片选择器
+(CKPhotoSelectSheet *)photoSelectWithCameraAction:(void (^)(UIAlertAction * action))handle1
                                   withPhotoAction:(void (^)(UIAlertAction * action))handle2
                                     withTintColor:(UIColor *)tintColor
                                  inViewController:(UIViewController *)vc;

@end
