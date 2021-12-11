//
//  GCWaterfallFlowLayout.m
//  pubutest
//
//  Created by zj on 2017/6/29.
//  Copyright © 2017年 zj. All rights reserved.
//

#import "GCWaterfallFlowLayout.h"
@interface GCWaterfallFlowLayout()

//存储所有的items;
@property (nonatomic, strong) NSMutableArray *allItems;
//储存没一列的最高值
@property (nonatomic, strong) NSMutableArray *maxColums;
//判断应该出现的列数
@property (nonatomic, assign) NSInteger currentColumnNumber;
//整个表的最高值
@property (nonatomic, assign) NSInteger maxHeight;

@end

@implementation GCWaterfallFlowLayout
#pragma mark-------系统方法------

- (void)prepareLayout
{
    
    [super prepareLayout];
    
    [self.allItems removeAllObjects];
    self.maxHeight = 0;
    //找出一共所少分区
    NSInteger sectionCount = [self.collectionView numberOfSections];
    //找出距离上下左右多少距离

    //找出每个分区的排列

    for (int i = 0 ; i <sectionCount; i++)
    {
        
        UIEdgeInsets edgeInsets = [self getSectionInsets:[NSIndexPath indexPathForItem:0 inSection:i]];
        //添加表头表位
        UICollectionViewLayoutAttributes *headAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
        [self.allItems addObject:headAttributes];
        
        
        [self columnNumberFromSizeWidth:[NSIndexPath indexPathForItem:0 inSection:i]];
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:i];
        CGFloat interitemSpacing = [self getInteritemSpacing:[NSIndexPath indexPathForItem:0 inSection:i]];//最小列间距 如果不设置 就会默认
        CGFloat Spacing = [self getMinlineSpace:[NSIndexPath indexPathForItem:0 inSection:i]];//最小行间距

        CGFloat itemX = edgeInsets.left;
        for (int index = 0; index <itemCount; index++)
        {
           
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:i];
            CGSize itemSize = [self getItemSize:indexPath];
            
            //判断item的fram
            NSInteger  currentMinColumn =  [self minColumn];
            CGFloat columnX = itemX+(itemSize.width+interitemSpacing)*currentMinColumn;
            
            CGFloat columnY = [self.maxColums[currentMinColumn] floatValue];
            
            //todo-- 这里有问题所以导致布局不对
            [self.maxColums replaceObjectAtIndex:currentMinColumn withObject:[NSString stringWithFormat:@"%f",columnY+itemSize.height+Spacing]];

            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes
                                                                layoutAttributesForCellWithIndexPath:indexPath];
            itemAttributes.frame = CGRectMake(columnX,columnY, itemSize.width,itemSize.height);
            [self.allItems addObject:itemAttributes];
        }
        UICollectionViewLayoutAttributes *footAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
        [self.allItems addObject:footAttributes];
        //进入第另一个分区的时候,吧所有的高度都相应的加之前的最高值
        
    }

}
//集合返回
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //添加表头表位进数组
    
    
    return self.allItems;
}
//设置contensize的大小 不然不能滑动
- (CGSize)collectionViewContentSize
{
    //查看是否有top 如果有就加上
    
    return CGSizeMake(self.collectionView.bounds.size.width, self.maxHeight);
}
//设置表头和表位的大小
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    //获取表头表位的高度//同时计算一下最高的值
    CGSize headSize = [self getHeadSize:indexPath];
    CGSize footSize = [self getFootSize:indexPath];
    UIEdgeInsets edgInsets = [self getSectionInsets:indexPath];

    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes
                                                    layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        attributes.frame = CGRectMake(0, self.maxHeight, headSize.width, headSize.height);
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        CGFloat maxYHeight = [self maxYHeight];
        attributes.frame = CGRectMake(0,maxYHeight+edgInsets.bottom-[self getMinlineSpace:indexPath] , footSize.width, footSize.height);
        //因为执行循序 我可以在每一次的表尾开始的时候都计算出高的点,然后方便下一次使用
        self.maxHeight = attributes.frame.origin.y+footSize.height;
    }
    return attributes;
}




#pragma mark-------数据处理-------
// 找出最小的
- (NSInteger)minColumn
{
    NSUInteger shortestIndex = 0;
    CGFloat shortestValue = MAXFLOAT;
    for (int i = 0 ; i<self.currentColumnNumber; i++) {
        if ([self.maxColums[i] floatValue] < shortestValue) {
            shortestValue = [self.maxColums[i] floatValue];
            shortestIndex = i;
        }

    }
    return shortestIndex;
}
//找出最高的列的y+height
- (NSUInteger)maxYHeight
{

    NSUInteger shortestIndex = 0;
    CGFloat shortestValue = 0;
    for (int i = 0 ; i<self.currentColumnNumber; i++)
    {
        if ([self.maxColums[i] floatValue] > shortestValue)
        {
            shortestValue = [self.maxColums[i] floatValue];
            shortestIndex = i;
        }
        
    }
    return shortestValue;
}
//一共分成几列
- (void)columnNumberFromSizeWidth:(NSIndexPath*)index
{

    CGSize itemSize = [self getItemSize:index];
    UIEdgeInsets inset = [self getSectionInsets:index];
    CGSize headSize = [self getHeadSize:index];
    self.currentColumnNumber = (self.collectionView.frame.size.width-inset.left-inset.right)/itemSize.width;
    if(self.currentColumnNumber==0){
        self.currentColumnNumber = 1;
    }
//    NSLog(@"%ld", (long)self.currentColumnNumber);
    self.maxColums = [NSMutableArray arrayWithCapacity:self.currentColumnNumber];
    

    for (int i = 0; i<self.currentColumnNumber;i++ )
    {
        if(index.section == 0)
        {
            [self.maxColums addObject:[NSString stringWithFormat:@"%f",headSize.height]];
        }else{
            [self.maxColums addObject:[NSString stringWithFormat:@"%f",(long)self.maxHeight+headSize.height+inset.top]];
        }
    }
    
}

//delegate的设置优先级大于属性设置的
- (CGSize)getItemSize:(NSIndexPath *)index
{
    
    if([self.delegate respondsToSelector:@selector(GCWaterfallSizeForItemAtIndex:collectionView:)])
    {
        
        return [self.delegate GCWaterfallSizeForItemAtIndex:index collectionView:self.collectionView];
    }else
    {
        return CGSizeZero;
    }
}
//保证edgeInset的优先级 要是都不设置 都是0
- (UIEdgeInsets)getSectionInsets:(NSIndexPath *)index
{
    if([self.delegate respondsToSelector:@selector(GCWaterfallInsetForItemAtIndex:CollectionView:)]){
        return  [self.delegate GCWaterfallInsetForItemAtIndex:index CollectionView:self.collectionView];
    }
    else
    {
        //获得缝隙的间距同时设置给
        return UIEdgeInsetsZero;
    }
}
//最小行间距
-(CGFloat)getMinlineSpace:(NSIndexPath *)index
{

    if([self.delegate respondsToSelector:@selector(GCWaterfallMinimumLineSpacingForSectionAtIndex:collectionView:)])
    {
        return [self.delegate GCWaterfallMinimumLineSpacingForSectionAtIndex:index collectionView:self.collectionView];
    }
    else
    {
        return 0;
    }
}
//获取表头的大小
- (CGSize)getHeadSize:(NSIndexPath *)index
{
    if([self.delegate respondsToSelector:@selector(GCWaterfallReferenceSizeForHeaderInSection:collectionView:)])
    {
        return [self.delegate GCWaterfallReferenceSizeForHeaderInSection:index collectionView:self.collectionView];
    }
    else
    {
        return CGSizeZero;
    }
}

//获取表尾巴大小
- (CGSize)getFootSize:(NSIndexPath *)index
{
    if([self.delegate respondsToSelector:@selector(GCWaterfallReferenceSizeForFooterInSection:collectionView:)])
    {
        return [self.delegate GCWaterfallReferenceSizeForFooterInSection:index collectionView:self.collectionView];
    }
    else
    {
        return CGSizeZero;
    }
}


-(CGFloat)getInteritemSpacing:(NSIndexPath *)index
{
    UIEdgeInsets inset = [self getSectionInsets:index];
    if(self.currentColumnNumber>1){
        return (self.collectionView.bounds.size.width -
                self.currentColumnNumber*[self getItemSize:index].width - inset.left-inset.right)/(self.currentColumnNumber-1);
    }else {
        return 0;
    }
        
}
- (NSMutableArray *)allItems
{
    if(!_allItems)
    {
        _allItems = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _allItems;
}


@end
