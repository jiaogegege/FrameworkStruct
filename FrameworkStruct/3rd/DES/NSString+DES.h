//
//  NSString+DES.h
//  BabyBluetoothAppDemo
//
//  Created by user on 2018/4/23.
//  Copyright © 2018年 刘彦玮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DES)


+(NSString *)des:(NSString *)str key:(NSString *)key;

+(NSString *)decryptDes:(NSString*)str key:(NSString*)key;

@end
