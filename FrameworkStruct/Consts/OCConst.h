//
//  OCConst.h
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2022/1/1.
//

/**
 * 项目中OC定义的常量和宏
 */
#ifndef OCConst_h
#define OCConst_h

///弱引用宏定义
#define WS __weak typeof(self) weakSelf = self;
#define WO(obj) __weak typeof(obj) weakObj = obj;

///获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

///是否支持数据库加密
//#define DATABASE_ENCRYPTION
//数据库加密key
#define DATABASE_ENCRYPTION_KEY @"DATABASE_ENCRYPTION_KEY_jxj_1989"








#endif /* OCConst_h */
