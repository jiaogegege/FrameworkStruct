//
//  StatusManager.h
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2019/3/25.
//


/**
 状态管理器
 1. 这是一个常用工具，所有的界面和需要状态管理的模块都可以使用该工具来实现状态管理；
 2. 状态的key必须是可hash的，一般是NSNumber/NSString类型；
 3. 状态的value是id类型，所以可以是任意对象；但是有个问题，对象一般是指针类型，所以状态value建议使用基础类型的包装类，防止状态value在外部被改变，或者使用深复制；
 4. 状态管理器支持历史状态回溯，可以查看历史状态列表（该功能有时间再实现）；
 */

#import <Foundation/Foundation.h>

//建议使用该类型作为状态管理器的key
typedef NSString * StatusKeyType;

NS_ASSUME_NONNULL_BEGIN

@interface StatusManager : NSObject

///最多可以保存的状态，初始化时确定
@property(nonatomic, assign, readonly)NSInteger maxCount;

///创建一个新的状态管理器，并初始化容量
-(instancetype)initWithCapacity:(NSInteger)capacity;

///插入一个状态
-(BOOL)setStatus:(id)status ForKey:(id)key;

///获得当前某个指定key的状态，key一般是NSNumber/NSString类型；返回值是一个对象
-(id)statusForKey:(id)key;

///获得上一次的状态
-(id)perviousStatusForKey:(id)key;

///获得之前某次的状态，参数：times指定之前第几次，当前为0，上一次为1，上上一次为2，最大不超过指定容量，没有返回nil
-(id)beforeTimes:(NSInteger)times StatusForKey:(id)key;

///获得所有历史状态，没有返回nil
-(NSArray *)allStatusForKey:(id)key;

///清空某个状态
-(void)clearForKey:(id)key;

///清空所有状态
-(void)reset;









@end

NS_ASSUME_NONNULL_END
