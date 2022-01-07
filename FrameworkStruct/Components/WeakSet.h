//
//  WeakSet.h
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/1/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeakSet : NSObject

/**
 *  元素个数
 */
@property (readonly)NSUInteger count;

/**
 *  所有对象
 */
@property (readonly, copy)NSArray *allObjects;

/**
 *  获取一个对象
 */
@property (readonly, nonatomic)id anyObject;

/**
 *  获取集合
 */
@property (readonly, copy)NSSet *setRepresentation;

- (id)member:(id)object;
- (NSEnumerator *)objectEnumerator;
- (void)addObject:(id)object;
- (void)removeObject:(id)object;
- (void)removeAllObjects;
- (BOOL)containsObject:(id)anObject;

@end

NS_ASSUME_NONNULL_END
