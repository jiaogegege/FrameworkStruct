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


///颜色工具方法定义
#define UIColorWithRGB(r,g,b) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:1.f]
#define UIColorWithRGBA(r,g,b,a) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]
#define UIColorWithHEX(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.f green:((float)((hex & 0xFF00) >> 8)) / 255.f blue:((float)(hex & 0xFF)) / 255.f alpha:1.f]
#define UIColorWithHEXA(hex,a) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.f green:((float)((hex & 0xFF00) >> 8)) / 255.f  blue:((float)(hex & 0xFF)) / 255.f  alpha:a]






#endif /* OCConst_h */
