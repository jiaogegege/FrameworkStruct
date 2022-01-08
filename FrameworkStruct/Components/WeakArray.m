//
//  WeakArray.m
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/1/7.
//

#import "WeakArray.h"

@interface WeakArray () {

    NSPointerArray *_pointerArray;
}

@end

@implementation WeakArray

- (instancetype)init {
    
    self = [super init];
    if (self) {
    
        _pointerArray = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsWeakMemory];
    }
    
    return self;
}

- (id)objectAtIndex:(NSUInteger)index {

    return [_pointerArray pointerAtIndex:index];
}

- (void)addObject:(id)object {

    [_pointerArray addPointer:(__bridge void *)(object)];
}

- (void)removeObjectAtIndex:(NSUInteger)index {

    [_pointerArray removePointerAtIndex:index];
}

- (void)insertObject:(id)object atIndex:(NSUInteger)index {

    [_pointerArray insertPointer:(__bridge void *)(object) atIndex:index];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withPointer:(id)object {

    [_pointerArray replacePointerAtIndex:index withPointer:(__bridge void *)(object)];
}

- (void)compact {
    [_pointerArray addPointer:NULL];
    [_pointerArray compact];
}

//@synthesize count = _count;
- (NSUInteger)count {

    return _pointerArray.count;
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"%@", _pointerArray.allObjects];
}

//@synthesize allObjects = _allObjects;
- (NSArray *)allObjects {

    return _pointerArray.allObjects;
}

@end
