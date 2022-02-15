//
//  NSData+DataToHexString.m
//  BabyBluetoothAppDemo
//
//  Created by user on 2018/4/23.
//  Copyright © 2018年 刘彦玮. All rights reserved.
//

#import "NSData+DataToHexString.h"

@implementation NSData (DataToHexString)

-(NSString *)dataToHexString{
    NSUInteger len = [self length];
    char *chars = (char *)[self bytes];
    NSMutableString *hexString = [[NSMutableString alloc]init];
    for (NSUInteger i=0; i<len; i++) {
        [hexString appendString:[NSString stringWithFormat:@"%0.2hhx",chars[i]]];
    }
    return hexString;
}

@end
