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

//弱引用宏定义
#define WS __weak typeof(self) weakSelf = self;
#define WO(obj) __weak typeof(obj) weakObj = obj;

//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]









#endif /* OCConst_h */
