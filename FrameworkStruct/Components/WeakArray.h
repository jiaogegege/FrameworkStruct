//
//  WeakArray.h
//  FrameworkStruct
//
//  Created by  蒋 雪姣 on 2022/1/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeakArray : NSObject

@property (nonatomic, readonly, copy)NSArray *allObjects;
@property (nonatomic, readonly)NSUInteger count;

- (id)objectAtIndex:(NSUInteger)index;
- (void)addObject:(id)object;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)insertObject:(id)object atIndex:(NSUInteger)index;
- (void)replaceObjectAtIndex:(NSUInteger)index withPointer:(id)object;
- (void)compact;

@end

NS_ASSUME_NONNULL_END
