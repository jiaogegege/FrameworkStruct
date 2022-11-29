//
//  OCConst.h
//  FrameworkStruct
//
//  Created by jggg on 2022/1/1.
//

/**
 * 项目中OC定义的常量和宏
 */
#ifndef OCConst_h
#define OCConst_h


//替换NSLog打印日志，在Release环境下不打印
// 保证 #ifdef __OBJC__ 中的宏定义只会在 OC 的代码中被引用,否则，一旦引入 C/C++ 的代码或者框架，就会出错！
#ifdef __OBJC__

#ifdef DEBUG
#define NSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define NSLog(...)
#endif

#endif


///弱引用宏定义
#define WS __weak typeof(self) weakSelf = self;
#define WO(obj) __weak typeof(obj) weakObj = obj;


///获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]


///是否支持数据库加密
//#define DATABASE_ENCRYPTION
//数据库加密key
#define DATABASE_ENCRYPTION_KEY @"DATABASE_ENCRYPTION_KEY_jxj_1989"


///颜色工具方法定义
#define UIColorWithRGB(r,g,b) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:1.f]
#define UIColorWithRGBA(r,g,b,a) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]
#define UIColorWithHEX(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.f green:((float)((hex & 0xFF00) >> 8)) / 255.f blue:((float)(hex & 0xFF)) / 255.f alpha:1.f]
#define UIColorWithHEXA(hex,a) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.f green:((float)((hex & 0xFF00) >> 8)) / 255.f  blue:((float)(hex & 0xFF)) / 255.f  alpha:a]






#endif /* OCConst_h */
