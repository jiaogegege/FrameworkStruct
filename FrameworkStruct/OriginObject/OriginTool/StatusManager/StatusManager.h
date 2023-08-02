//
//  StatusManager.h
//  FrameworkStruct
//
//  Created by jggg on 2019/3/25.
//


/**
 状态管理器
 1. 这是一个常用工具，所有的界面和需要状态管理的模块都可以使用该工具来实现状态管理；
 2. 状态的key必须是可hash的，一般是NSNumber/NSString类型；
 3. 状态的value是id类型，所以可以是任意对象；但是有个问题，对象一般是指针类型，所以状态value建议使用基础类型的包装类，防止状态value在外部被改变，或者使用深复制；
 4. 状态管理器支持历史状态回溯，可以查看历史状态列表；
 5. 支持状态订阅，当状态改变时自动执行订阅的动作；
 */
#import <Foundation/Foundation.h>

//状态管理器代理协议
@protocol StatusManagerDelegate <NSObject>
//状态管理器更新了某个状态，通知所有订阅对象，返回新状态和上一个旧状态，可能为nil
-(void)statusManagerDidUpdateStatus:(id _Nonnull)key newValue:(id _Nullable)newValue oldValue:(id _Nullable)oldValue;

@end

//建议使用该类型作为状态管理器的key
typedef NSString * SMKeyType;

//订阅者block类型
typedef void(^SMSubscribeAction)(id _Nullable newStatus,id _Nullable oldStatus);

NS_ASSUME_NONNULL_BEGIN

@interface StatusManager : NSObject

///最多可以保存的状态，初始化时确定
@property(nonatomic, assign, readonly)NSInteger capacity;

///创建一个新的状态管理器，并初始化容量
-(instancetype)initWithCapacity:(NSInteger)capacity;

///插入一个状态
-(BOOL)set:(id)status key:(id)key;

///获得当前某个指定key的状态，key一般是NSNumber/NSString类型；返回值是一个对象
-(id)status:(id)key;

///获得上一次的状态
-(id)perviousStatus:(id)key;

///获得之前某次的状态，参数：times指定之前第几次，当前为0，上一次为1，上上一次为2，最大不超过指定容量，没有返回nil
-(id)before:(NSInteger)times status:(id)key;

///获得所有历史状态，没有返回nil
-(NSArray *)allStatus:(id)key;

///清空某个状态
-(void)clear:(id)key;

///清空所有状态
-(void)clear;

///清空所有资源，包括状态和action和delegate
-(void)reset;

///订阅状态，如果在其他地方修改了该状态，那么会将变化结果发送到所有订阅者，包括新状态和上一个旧状态，如果是清空状态，那么返回nil
-(void)subscribe:(id)key action:(SMSubscribeAction)action;

///订阅状态，如果在其他地方修改了该状态，那么会将变化结果发送到所有订阅者，包括新状态和上一个旧状态，如果是清空状态，那么返回nil
-(void)subscribe:(id)key delegate:(id<StatusManagerDelegate>)delegate;



@end

NS_ASSUME_NONNULL_END
