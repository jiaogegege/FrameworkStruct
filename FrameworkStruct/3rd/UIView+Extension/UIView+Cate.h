//
//  UIView+Cate.h
//  JFCrowdFunding
//
//  Created by Ink on 2021/7/2.
//  Copyright © 2021 Bge. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ViewShadowPathSide) {
    ViewShadowPathSideLeft,
    ViewShadowPathSideRight,
    ViewShadowPathSideTop,
    ViewShadowPathSideBottom,
    ViewShadowPathSideAll,
};

/*!
 *  设置 viewRectCornerType 样式，
 *  注意：BAKit_ViewRectCornerType 必须要先设置 viewCornerRadius，才能有效，否则设置无效，
 */
typedef NS_ENUM(NSInteger, BAKit_ViewRectCornerType) {
    /*!
     *  设置下左角 圆角半径
     */
    BAKit_ViewRectCornerTypeBottomLeft = 0,
    /*!
     *  设置下右角 圆角半径
     */
    BAKit_ViewRectCornerTypeBottomRight,
    /*!
     *  设置上左角 圆角半径
     */
    BAKit_ViewRectCornerTypeTopLeft,
    /*!
     *  设置下右角 圆角半径
     */
    BAKit_ViewRectCornerTypeTopRight,
    /*!
     *  设置下左、下右角 圆角半径
     */
    BAKit_ViewRectCornerTypeBottomLeftAndBottomRight,
    /*!
     *  设置上左、上右角 圆角半径
     */
    BAKit_ViewRectCornerTypeTopLeftAndTopRight,
    /*!
     *  设置下左、上左角 圆角半径
     */
    BAKit_ViewRectCornerTypeBottomLeftAndTopLeft,
    /*!
     *  设置下右、上右角 圆角半径
     */
    BAKit_ViewRectCornerTypeBottomRightAndTopRight,
    /*!
     *  设置下左、上右角 圆角半径
     */
    BAKit_ViewRectCornerTypeBottomLeftAndTopRight,
    /*!
     *  设置上左、上右、下右角 圆角半径
     */
    BAKit_ViewRectCornerTypeBottomRightAndTopRightAndTopLeft,
    /*!
     *  设置下右、上右、下左角 圆角半径
     */
    BAKit_ViewRectCornerTypeBottomRightAndTopRightAndBottomLeft,
    /*!
     *  设置全部四个角 圆角半径
     */
    BAKit_ViewRectCornerTypeAllCorners
};


@interface UIView (Cate)


/**
 设置 viewRectCornerType 样式，注意：BAKit_ViewRectCornerType 必须要先设置 viewCornerRadius，才能有效，否则设置无效，如果是 xib，需要要有固定 宽高，要不然 iOS 10 设置无效
 */
@property (nonatomic, assign) BAKit_ViewRectCornerType ba_viewRectCornerType;

/**
 设置 view ：圆角，如果要全部设置四个角的圆角，可以直接用这个方法，必须要在设置 frame 之后，注意：如果是 xib，需要要有固定 宽高，要不然 iOS 10 设置无效
 */
@property (nonatomic, assign) CGFloat ba_viewCornerRadius;

/**
  设置 view ：边框边线宽度
 */
@property(nonatomic, assign) CGFloat ba_viewBorderWidth;

/**
 设置 view ：边框边线颜色
 */
@property(nonatomic, strong) UIColor *ba_viewBorderColor;


/**
 快速切圆角
 
 @param type 圆角样式
 @param viewCornerRadius 圆角角度
 */
- (void)ba_view_setViewRectCornerType:(BAKit_ViewRectCornerType)type
                     viewCornerRadius:(CGFloat)viewCornerRadius;

/**
 快速切圆角，带边框、边框颜色

 @param type 圆角样式
 @param viewCornerRadius 圆角角度
 @param borderWidth 边线宽度
 @param borderColor 边线颜色
 */
- (void)ba_view_setViewRectCornerType:(BAKit_ViewRectCornerType)type
                     viewCornerRadius:(CGFloat)viewCornerRadius
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor;

/*
 * shadowColor 阴影颜色
 * shadowPathWidth 阴影的半径，
 */
- (void)drawShadowWithColor:(UIColor *)color shadowRadius:(CGFloat)shadowRadius;

/* 设置渐变视图
 * side 从深色方向渐变
 * fromColor 深色颜色，
 * toColor 浅色颜色，
 */
- (void)setGradualChangingFrom:(ViewShadowPathSide)side fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor;

/**
 *  通过 CAShapeLayer 方式绘制虚线
 *
 *  param lineLength:     虚线的宽度
 *  param lineSpacing:    虚线的间距
 *  param lineColor:      虚线的颜色
 *  param lineDirection   虚线的方向  YES 为水平方向， NO 为垂直方向
 **/
- (void)drawLineOfDashWithlineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor lineDirection:(BOOL)isHorizonal;




@end

NS_ASSUME_NONNULL_END
