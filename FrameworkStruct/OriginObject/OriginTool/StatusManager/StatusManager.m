//
//  StatusManager.m
//  FrameworkStruct
//
//  Created by 蒋雪姣 on 2019/3/25.
//

#import "StatusManager.h"
#import "SMVector.h"


@interface StatusManager ()
//内部数据结构，保存状态，key是那个状态的指定key，value是一个`SMVector`对象，存储指定数量的状态
@property(nonatomic, strong)NSMutableDictionary *dict;

//订阅状态的action，key是指定状态的key，value是action数组，因为一个状态可能被多个aciton订阅
@property(nonatomic, strong)NSMutableDictionary *actionDict;


@end

@implementation StatusManager

    ///创建一个新的状态管理器，并初始化状态的容量
-(instancetype)initWithCapacity:(NSInteger)capacity
{
    if (self = [super init])
    {
        _dict = [NSMutableDictionary dictionary];
        _actionDict = [NSMutableDictionary dictionary];
        _capacity = capacity;       //每一个状态的最大容量
    }
    return self;
}

    ///插入一个状态，返回是否插入成功
-(BOOL)set:(id)status key:(id)key
{
    if (key && status)  //都有值才执行操作
    {
        id obj = [status copy]; //复制一下，防止引用了外部可变对象
        SMVector *vec = [_dict objectForKey:key];
        if (vec)    //已经保存过状态了
        {
            //直接插入一个新状态
            [vec push:obj];
        }
        else    //没有保存过状态
        {
            vec = [SMVector vectorWithCapacity:_capacity];
            [vec push:obj];
            [_dict setObject:vec forKey:key];
        }
        //插入状态后通知所有订阅者
        [self dispatchStatus:key];
        return YES;
    }
    return NO;
}

    ///获得当前某个指定key的状态，key一般是NSNumber/NSString类型；返回值是一个对象，没有返回nil
-(id)status:(id)key
{
    SMVector *vec = [_dict objectForKey:key];
    if (!vec)
    {
        return nil;
    }
    id obj = [[vec first] copy];
    return obj;
}

    ///获得上一次的状态
-(id)perviousStatus:(id)key
{
    SMVector *vec = [_dict objectForKey:key];
    if (!vec)
    {
        return nil;
    }
    id obj = [[vec objectAtIndex:1] copy];
    return obj;
}

    ///获得之前某次的状态，参数：times指定之前第几次，当前为0，上一次为1，上上一次为2，最大不超过指定容量，没有返回nil
-(id)before:(NSInteger)times status:(id)key
{
    SMVector *vec = [_dict objectForKey:key];
    if (!vec)
    {
        return nil;
    }
    id obj = [[vec objectAtIndex:times] copy];
    return obj;
}

    ///获得所有历史状态，没有返回nil
-(NSArray *)allStatus:(id)key
{
    SMVector *vec = [_dict objectForKey:key];
    if (vec)
    {
        NSInteger count = [vec count];
        if (count > 0)
        {
            NSMutableArray *ar = [NSMutableArray array];
            //遍历容器，取出所有的元素
            for (int i = 0; i < count; ++i)
            {
                id obj = [[vec objectAtIndex:i] copy];
                [ar addObject:obj];
            }
            return ar;
        }
    }
    return nil;
}

    ///清空某个状态
-(void)clear:(id)key
{
    [_dict removeObjectForKey:key];
}

    ///清空所有状态
-(void)reset
{
    [_dict removeAllObjects];
}

///清理所有资源
-(void)clear
{
    [self reset];
    [_actionDict removeAllObjects];
}

///订阅状态，如果在其他地方修改了该状态，那么会将变化结果发送到所有订阅者，包括新状态和上一个旧状态，如果是清空状态，那么返回nil
-(void)subscribe:(id)key action:(SubscribeAction)action
{
    NSMutableArray *actionArray = [_actionDict objectForKey:key];
    if (actionArray == nil) //如果为空，那么创建一个新的
    {
        actionArray = [NSMutableArray array];
        [_actionDict setObject:actionArray forKey:key];
    }
    if (![actionArray containsObject:action])
    {
        [actionArray addObject:action];
    }
}

///发送状态变化信息
-(void)dispatchStatus:(id)key
{
    //先找出有没有订阅者
    NSArray *actionArray = [_actionDict objectForKey:key];
    if (actionArray != nil && actionArray.count > 0)
    {
        //有订阅者，那么发送订阅信息
        id newValue = [self status:key];
        id oldValue = [self perviousStatus:key];
        for (SubscribeAction action in actionArray)
        {
            action(newValue, oldValue);
        }
    }
}

-(void)dealloc
{
    [self.dict removeAllObjects];
    self.dict = nil;
    [self.actionDict removeAllObjects];
    self.actionDict = nil;
//    NSLog(@"StatusManager: dealloc");
}


@end
