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



@end

@implementation StatusManager

    ///创建一个新的状态管理器，并初始化状态的容量
-(instancetype)initWithCapacity:(NSInteger)capacity
{
    if (self = [super init])
    {
        _dict = [NSMutableDictionary dictionary];
        _maxCount = capacity;       //每一个状态的最大容量
    }
    return self;
}

    ///插入一个状态，返回是否插入成功
-(BOOL)setStatus:(id)status ForKey:(id)key
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
            vec = [SMVector vectorWithCapacity:_maxCount];
            [vec push:obj];
            [_dict setObject:vec forKey:key];
        }
        return YES;
    }
    return NO;
}

    ///获得当前某个指定key的状态，key一般是NSNumber/NSString类型；返回值是一个对象，没有返回nil
-(id)statusForKey:(id)key
{
    SMVector *vec = [_dict objectForKey:key];
    if (!vec)
    {
        return nil;
    }
    id obj = [vec first];
    return obj;
}

    ///获得上一次的状态
-(id)perviousStatusForKey:(id)key
{
    SMVector *vec = [_dict objectForKey:key];
    if (!vec)
    {
        return nil;
    }
    id obj = [vec objectAtIndex:1];
    return obj;
}

    ///获得之前某次的状态，参数：times指定之前第几次，当前为0，上一次为1，上上一次为2，最大不超过指定容量，没有返回nil
-(id)beforeTimes:(NSInteger)times StatusForKey:(id)key
{
    SMVector *vec = [_dict objectForKey:key];
    if (!vec)
    {
        return nil;
    }
    id obj = [vec objectAtIndex:times];
    return obj;
}

    ///获得所有历史状态，没有返回nil
-(NSArray *)allStatusForKey:(id)key
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
                id obj = [vec objectAtIndex:i];
                [ar addObject:obj];
            }
            return ar;
        }
    }
    return nil;
}

    ///清空某个状态
-(void)clearForKey:(id)key
{
    [_dict removeObjectForKey:key];
}

    ///清空所有状态
-(void)reset
{
    [_dict removeAllObjects];
}




@end
