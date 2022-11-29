//
//  SMVector.h
//  FrameworkStruct
//
//  Created by jggg on 2019/3/26.
//

/**
 1. 状态管理器所使用的内部数据结构，类似一个队列，但是只能存放固定数量的元素，总是从头push元素，超过容量自动从尾部删除，容量在初始化的时候设定；
 2. 未打算提供容量修改功能；
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMVector : NSObject

//容量，只读
@property(nonatomic, assign, readonly)NSInteger capacity;

///创建一个新的容器
+(SMVector *)vectorWithCapacity:(NSInteger)capacity;

///添加一个元素，总是在容器头部添加
-(void)push:(id)obj;

///删除一个元素，总是在容器尾部删除，并返回这个元素
-(id)pop;

///清空容器
-(void)empty;

///判断容器是否为空
-(BOOL)isEmpty;

///查找第一个元素，不删除，没找到返回nil
-(id)first;

///查找最后一个元素，不删除，没找到返回nil
-(id)last;

///查找某个位置的元素，找不到或者超过容量返回nil
-(id)objectAtIndex:(NSInteger)index;

///获得容器中元素个数，不是容量
-(NSInteger)count;



@end

NS_ASSUME_NONNULL_END
