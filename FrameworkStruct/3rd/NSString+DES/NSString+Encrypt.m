//
//  NSString+Encrypt.m
//  FrameworkStruct
//
//  Created by 蒋旭蛟 on 2018/4/23.
//  Copyright © 2018年 蒋旭蛟. All rights reserved.
//

#import "NSString+Encrypt.h"
#import "GTMBase64.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import "NSData+DataToHexString.h"


@implementation NSString (Encrypt)

///des加密
+(NSString *)des:(NSString *)str key:(NSString *)key
{
    NSString *ciphertext = nil;
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess)
    {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
//        NSLog(@"data = %@",data);
        ciphertext = [data dataToHexString];
//        NSLog(@"ciphertext = %@",ciphertext);
    }
    free(buffer);
    return ciphertext;
}


//des解密
+(NSString *)decryptDes:(NSString*)hexString key:(NSString*)key
{
    NSData *data = [self hexStringToData:hexString];
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES, kCCOptionPKCS7Padding|kCCOptionECBMode, keyPtr, kCCBlockSizeDES, NULL, [data bytes], dataLength, buffer, bufferSize, &numBytesEncrypted);
    if(cryptStatus == kCCSuccess)
    {
        NSString *string = [[NSString alloc] initWithData:[NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted] encoding:NSUTF8StringEncoding];
//        NSLog(@"string = %@",string);
        return string;
    }
    free(buffer);
    return nil;
}

+(NSData *)hexStringToData:(NSString *)hexString
{
    const char *chars = [hexString UTF8String];
    int i = 0;
    int len = (int)hexString.length;
    NSMutableData *data = [NSMutableData dataWithCapacity:len/2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    
    while (i<len) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    return data;
}

#pragma mark - md5加密
    ///32位 小写
+(NSString *)MD5ForLower32Bate:(NSString *)str
{
        //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    CC_MD5(input, (CC_LONG)strlen(input), result);
#pragma clang diagnostic pop
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [digest appendFormat:@"%02x", result[i]];
    }
    return digest;
}

///32位 大写
+(NSString *)MD5ForUpper32Bate:(NSString *)str
{
        //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    CC_MD5(input, (CC_LONG)strlen(input), result);
#pragma clang diagnostic pop
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [digest appendFormat:@"%02X", result[i]];
    }
    return digest;
}

///16位 大写
+(NSString *)MD5ForUpper16Bate:(NSString *)str
{
    NSString *md5Str = [self MD5ForUpper32Bate:str];
    NSString  *string;
    for (int i=0; i<24; i++)
    {
        string=[md5Str substringWithRange:NSMakeRange(8, 16)];
    }
    return string;
}

///16位 小写
+(NSString *)MD5ForLower16Bate:(NSString *)str
{
    NSString *md5Str = [self MD5ForLower32Bate:str];
    NSString  *string;
    for (int i=0; i<24; i++)
    {
        string=[md5Str substringWithRange:NSMakeRange(8, 16)];
    }
    return string;
}

@end
