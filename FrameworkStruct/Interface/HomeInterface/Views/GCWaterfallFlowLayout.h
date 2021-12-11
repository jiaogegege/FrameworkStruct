//
//  GCWaterfallFlowLayout.h
//  pubutest
//
//  Created by zj on 2017/6/29.
//  Copyright © 2017年 zj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GCWaterfallFlowLayoutDeleagte <NSObject>

/**
 传入Item的大小
 @param index 当前的index
 @param collectionView 当前的collectionView
 @return 需要设置的Item的大小
 */
- (CGSize )GCWaterfallSizeForItemAtIndex:(NSIndexPath *)index
                               collectionView:(UICollectionView *)collectionView;

/**
 传入距上下左右的边距
 @param collectionView 当前的collectionView
 @return 需要设置的Item的大小
 */
- (UIEdgeInsets)GCWaterfallInsetForItemAtIndex:(NSIndexPath *)index
                                CollectionView:(UICollectionView *)collectionView;


/**
 传入最小的行间距
 @param index 当前的index
 @param collectionView 当前的collectionView
 @return 需要设置的Item的大小
 */
- (CGFloat )GCWaterfallMinimumLineSpacingForSectionAtIndex:(NSIndexPath *)index
                                      collectionView:(UICollectionView *)collectionView;

/**
 传入最小的列间距 可以不传 自动计算列间距
 @param index 当前的index
 @param collectionView 当前的collectionView
 @return 需要设置的Item的大小

- (CGFloat)GCWaterfallMinimumInteritemSpacingForSectionAtIndex:(NSIndexPath *)index
                                      collectionView:(UICollectionView *)collectionView;

 */

/**
 传入表头大小
 @param index 当前的index
 @param collectionView 当前的collectionView
 @return 需要设置的Item的大小
 */
- (CGSize)GCWaterfallReferenceSizeForHeaderInSection:(NSIndexPath *)index
                                      collectionView:(UICollectionView *)collectionView;


/**
 传入表尾的大小
 @param index 当前的index
 @param collectionView 当前的collectionView
 @return 需要设置的Item的大小
 */
- (CGSize)GCWaterfallReferenceSizeForFooterInSection:(NSIndexPath *)index
                                        collectionView:(UICollectionView *)collectionView;



@end


@interface GCWaterfallFlowLayout : UICollectionViewLayout
/*
 */

@property (nonatomic, weak)id<GCWaterfallFlowLayoutDeleagte>delegate;
/*
 */
@property (nonatomic,readonly) CGSize headerReferenceSize;
/*
 */
@property (nonatomic,readonly) CGSize footerReferenceSize;

@end
