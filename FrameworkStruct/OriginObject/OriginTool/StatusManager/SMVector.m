//
//  SMVector.m
//  FrameworkStruct
//
//  Created by jggg on 2019/3/26.
//

#import "SMVector.h"

@interface SMVector ()
//内部数据结构
@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation SMVector

    ///创建一个新的容器
+(SMVector *)vectorWithCapacity:(NSInteger)capacity
{
    SMVector *vec = [[SMVector alloc] initWithCapacity:capacity];
    return vec;
}

-(instancetype)initWithCapacity:(NSInteger)capacity
{
    if (self = [super init])
    {
        _capacity = capacity;
        _dataArray = [[NSMutableArray alloc] initWithCapacity:capacity];
    }
    return self;
}

    ///添加一个元素，总是在容器头部添加
-(void)push:(id)obj
{
    if (obj)
    {
        if (_dataArray.count >= _capacity)   //如果超过了容量，那么删除最后一个元素
        {
            [_dataArray removeLastObject];
        }
        [_dataArray insertObject:obj atIndex:0];
    }
}

    ///删除一个元素，总是在容器尾部删除，并返回这个元素
-(id)pop
{
    if (![self isEmpty])    //不为空的时候才删除
    {
        id obj = [_dataArray lastObject];
        [_dataArray removeObject:obj];
        return obj;
    }
    return nil;
}

    ///清空容器
-(void)empty
{
    [_dataArray removeAllObjects];
}

    ///判断容器是否为空
-(BOOL)isEmpty
{
    if (_dataArray.count > 0)
    {
        return NO;
    }
    return YES;
}

    ///查找第一个元素，不删除，没找到返回nil
-(id)first
{
    if (![self isEmpty])
    {
        id obj = [_dataArray firstObject];
        return obj;
    }
    return nil;
}

    ///查找最后一个元素，不删除，没找到返回nil
-(id)last
{
    if (![self isEmpty])
    {
        id obj = [_dataArray lastObject];
        return obj;
    }
    return nil;
}

    ///查找某个位置的元素，找不到或者超过容量返回nil
-(id)objectAtIndex:(NSInteger)index
{
    if (![self isEmpty] && index < _dataArray.count)
    {
        id obj = [_dataArray objectAtIndex:index];
        return obj;
    }
    return nil;
}

    ///获得容器中元素个数，不是容量
-(NSInteger)count
{
    return _dataArray.count;
}





@end
