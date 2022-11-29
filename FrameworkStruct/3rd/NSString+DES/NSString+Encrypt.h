//
//  NSString+Encrypt.h
//  FrameworkStruct
//
//  Created by jggg on 2018/4/23.
//  Copyright © 2018年 jggg. All rights reserved.
//

/**
 * 字符串的DES和MD5加密
 */
#import <Foundation/Foundation.h>

@interface NSString (Encrypt)

///des加密
+(NSString *)des:(NSString *)str key:(NSString *)key;

///des解密
+(NSString *)decryptDes:(NSString*)str key:(NSString*)key;

#pragma mark - md5加密
///32位 大写
+(NSString *)MD5ForUpper32Bate:(NSString *)str;

///32位 小写
+(NSString *)MD5ForLower32Bate:(NSString *)str;

///16位 大写
+(NSString *)MD5ForUpper16Bate:(NSString *)str;

///16位 小写
+(NSString *)MD5ForLower16Bate:(NSString *)str;

@end
