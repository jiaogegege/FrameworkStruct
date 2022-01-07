//
//  WeakDictionary.m
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/1/7.
//

#import "WeakDictionary.h"

@interface WeakDictionary () {

    NSMapTable  *_mapTable;
}

@end

@implementation WeakDictionary

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        _mapTable = [NSMapTable strongToWeakObjectsMapTable];
    }
    
    return self;
}

- (id)objectForKey:(id)aKey {

    return [_mapTable objectForKey:aKey];
}

- (void)removeObjectForKey:(id)aKey {

    [_mapTable removeObjectForKey:aKey];
}

- (void)setObject:(id)anObject forKey:(id)aKey {

    [_mapTable setObject:anObject forKey:aKey];
}

- (NSEnumerator *)keyEnumerator {

    return [_mapTable keyEnumerator];
}

- (NSEnumerator *)objectEnumerator {

    return [_mapTable objectEnumerator];
}

- (void)removeAllObjects {

    [_mapTable removeAllObjects];
}

- (NSDictionary *)dictionaryRepresentation {

    return [_mapTable dictionaryRepresentation];
}

@synthesize count = _count;
- (NSUInteger)count {

    return _mapTable.count;
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"%@", _mapTable.dictionaryRepresentation];
}

@end
