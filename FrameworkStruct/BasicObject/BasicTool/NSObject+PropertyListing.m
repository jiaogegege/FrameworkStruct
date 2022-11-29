//
//  NSObject+PropertyListing.m
//  FrameworkStruct
//
//  Created by jggg on 2018/8/20.
//  Copyright © 2018年 jggg. All rights reserved.
//

#import "NSObject+PropertyListing.h"
/* 注意：要先导入ObjectC运行时头文件，以便调用runtime中的方法*/
#import <objc/runtime.h>


@implementation NSObject (PropertyListing)

/* 获取对象的所有属性，不包括属性值 */
- (NSArray *)getAllProperties
{
    u_int count;
    objc_property_t *properties  =class_copyPropertyList([self class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return propertiesArray;
}

/* 获取对象的所有属性以及属性值 */
- (NSDictionary *)properties_aps
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];        //获得属性名字
        id propertyValue = [self valueForKey:(NSString *)propertyName];             //获得属性值
        if (propertyValue)
        {
            [props setObject:propertyValue forKey:propertyName];
        }
    }
    free(properties);
    return props;
}

/* 获取对象的所有方法 */
-(void)printMothList
{
    unsigned int mothCout_f =0;
    Method* mothList_f = class_copyMethodList([self class], &mothCout_f);
    for(int i = 0; i < mothCout_f; i++)
    {
        Method temp_f = mothList_f[i];  //获得某一个方法
//        IMP imp_f = method_getImplementation(temp_f);   //获得某个方法的实现
//        SEL name_f = method_getName(temp_f);    //获得某个方法的名字SEL
        const char* name_s = sel_getName(method_getName(temp_f));       //获得方法的CString格式名字
        int arguments = method_getNumberOfArguments(temp_f);        //获得参数个数
        const char* encoding = method_getTypeEncoding(temp_f);      //获得方法参数和返回值的字符串描述
        NSLog(@"方法名：%@,参数个数：%d,编码方式：%@",[NSString stringWithUTF8String:name_s], arguments,[NSString stringWithUTF8String:encoding]);
    }
    free(mothList_f);
}

    ///重写复制方法
-(id)copyWithZone:(NSZone *)zone
{
    id instance = [[[self class] allocWithZone:zone] init];
    NSArray *properties = [self getAllProperties];
    NSDictionary *propertyValues = [self properties_aps];
    for (NSString *prot in properties)     //遍历属性列表
    {
        id proV = propertyValues[prot];
        if (proV)
        {
            if ([proV respondsToSelector:@selector(copy)])
            {
                [instance setValue:[proV copy] forKey:prot];
            }
            else
            {
                [instance setValue:proV forKey:prot];
            }
        }
    }
    return instance;
}

-(id)mutableCopyWithZone:(NSZone *)zone
{
    id instance = [[[self class] allocWithZone:zone] init];
    NSArray *properties = [self getAllProperties];
    NSDictionary *propertyValues = [self properties_aps];
    for (NSString *prot in properties)     //遍历属性列表
    {
        id proV = propertyValues[prot];
        if (proV)
        {
            if ([proV respondsToSelector:@selector(mutableCopy)])
            {
                [instance setValue:[proV mutableCopy] forKey:prot];
            }
            else
            {
                [instance setValue:proV forKey:prot];
            }
        }
    }
    return instance;
}



@end
