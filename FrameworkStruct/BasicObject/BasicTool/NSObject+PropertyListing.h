//
//  NSObject+PropertyListing.h
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2018/8/20.
//  Copyright © 2018年 蒋雪姣. All rights reserved.
//


/**
 *使NSObject对象能够动态获取所有的属性和方法列表
 *实现copy和mutableCopying协议，使其支持复制操作
 */

#import <Foundation/Foundation.h>

@interface NSObject (PropertyListing)<NSCopying, NSMutableCopying>

@end
