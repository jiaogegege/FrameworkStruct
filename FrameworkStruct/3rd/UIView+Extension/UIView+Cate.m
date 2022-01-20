//
//  UIView+Cate.m
//  JFCrowdFunding
//
//  Created by Ink on 2021/7/2.
//  Copyright © 2021 Bge. All rights reserved.
//

#import "UIView+Cate.h"
#import <objc/runtime.h>
/*! runtime set */
#define BAKit_Objc_setObj(key, value) objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC)

/*! runtime setCopy */
#define BAKit_Objc_setObjCOPY(key, value) objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_COPY)

/*! runtime get */
#define BAKit_Objc_getObj objc_getAssociatedObject(self, _cmd)

@implementation UIView (Cate)

- (void)ba_view_setViewRectCornerType:(BAKit_ViewRectCornerType)type
                     viewCornerRadius:(CGFloat)viewCornerRadius {
    self.ba_viewCornerRadius = viewCornerRadius;
    self.ba_viewRectCornerType = type;
}

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
                          borderColor:(UIColor *)borderColor {
    self.ba_viewCornerRadius = viewCornerRadius;
    self.ba_viewRectCornerType = type;
    self.ba_viewBorderWidth = borderWidth;
    self.ba_viewBorderColor = borderColor;
}

#pragma mark - view 的 角半径，默认 CGSizeMake(0, 0)
- (void)setupViewCornerType {
    UIRectCorner corners;
    CGSize cornerRadii;
    
    cornerRadii = CGSizeMake(self.ba_viewCornerRadius, self.ba_viewCornerRadius);
    if (self.ba_viewCornerRadius == 0) {
        cornerRadii = CGSizeMake(0, 0);
    }
    
    switch (self.ba_viewRectCornerType) {
        case BAKit_ViewRectCornerTypeBottomLeft: {
            corners = UIRectCornerBottomLeft;
        }
            break;
        case BAKit_ViewRectCornerTypeBottomRight: {
            corners = UIRectCornerBottomRight;
        }
            break;
        case BAKit_ViewRectCornerTypeTopLeft: {
            corners = UIRectCornerTopLeft;
        }
            break;
        case BAKit_ViewRectCornerTypeTopRight: {
            corners = UIRectCornerTopRight;
        }
            break;
        case BAKit_ViewRectCornerTypeBottomLeftAndBottomRight: {
            corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
        }
            break;
        case BAKit_ViewRectCornerTypeTopLeftAndTopRight: {
            corners = UIRectCornerTopLeft | UIRectCornerTopRight;
        }
            break;
        case BAKit_ViewRectCornerTypeBottomLeftAndTopLeft: {
            corners = UIRectCornerBottomLeft | UIRectCornerTopLeft;
        }
            break;
        case BAKit_ViewRectCornerTypeBottomRightAndTopRight: {
            corners = UIRectCornerBottomRight | UIRectCornerTopRight;
        }
            break;
        case BAKit_ViewRectCornerTypeBottomLeftAndTopRight: {
            corners = UIRectCornerBottomLeft | UIRectCornerTopRight;
        }
            break;
        case BAKit_ViewRectCornerTypeBottomRightAndTopRightAndTopLeft: {
            corners = UIRectCornerBottomRight | UIRectCornerTopRight | UIRectCornerTopLeft;
        }
            break;
        case BAKit_ViewRectCornerTypeBottomRightAndTopRightAndBottomLeft: {
            corners = UIRectCornerBottomRight | UIRectCornerTopRight | UIRectCornerBottomLeft;
        }
            break;
        case BAKit_ViewRectCornerTypeAllCorners: {
            corners = UIRectCornerAllCorners;
        }
            break;
            
        default:
            break;
    }
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                     byRoundingCorners:corners
                                                           cornerRadii:cornerRadii];

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.frame = self.bounds;
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.path = bezierPath.CGPath;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = self.ba_viewBorderColor.CGColor;
    borderLayer.lineWidth = self.ba_viewBorderWidth;
    borderLayer.frame = self.bounds;
    
    self.layer.mask = shapeLayer;
    [self.layer addSublayer:borderLayer];
//    self.clipsToBounds = YES;
}

#pragma mark - setter / getter
- (void)setBa_viewRectCornerType:(BAKit_ViewRectCornerType)ba_viewRectCornerType {
    BAKit_Objc_setObj(@selector(ba_viewRectCornerType), @(ba_viewRectCornerType));
    [self setupViewCornerType];
}

- (BAKit_ViewRectCornerType)ba_viewRectCornerType {
    return [BAKit_Objc_getObj integerValue];
}

- (void)setBa_viewCornerRadius:(CGFloat)ba_viewCornerRadius {
    BAKit_Objc_setObj(@selector(ba_viewCornerRadius), @(ba_viewCornerRadius));
}

- (CGFloat)ba_viewCornerRadius {
    return [BAKit_Objc_getObj integerValue];
}

- (void)setBa_viewBorderWidth:(CGFloat)ba_viewBorderWidth {
    BAKit_Objc_setObj(@selector(ba_viewBorderWidth), @(ba_viewBorderWidth));
    [self setupViewCornerType];
}

- (CGFloat)ba_viewBorderWidth {
    return [BAKit_Objc_getObj floatValue];
}

- (void)setBa_viewBorderColor:(UIColor *)ba_viewBorderColor {
    BAKit_Objc_setObj(@selector(ba_viewBorderColor), ba_viewBorderColor);
    [self setupViewCornerType];
}

- (UIColor *)ba_viewBorderColor {
    return BAKit_Objc_getObj;
}

- (void)drawShadowWithColor:(UIColor *)color shadowRadius:(CGFloat)shadowRadius{
    self.layer.shadowColor = color.CGColor;//shadowColor阴影颜色
    self.layer.shadowOffset = CGSizeMake(0, 2);//shadowOffset阴影偏移，默认(0, 2),这个跟shadowRadius配合使用
    self.layer.shadowOpacity = 1;//阴影透明度，默认1
    self.layer.shadowRadius = shadowRadius;
}

- (void)setGradualChangingFrom:(ViewShadowPathSide)side fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor{
    //    CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(__bridge id)fromColor.CGColor,(__bridge id)toColor.CGColor];
    if (side == ViewShadowPathSideLeft) {
        //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
        gradientLayer.startPoint = CGPointMake(0, 0.5);
        gradientLayer.endPoint = CGPointMake(1, 0.5);
    }else if (side == ViewShadowPathSideTop){
        //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
        gradientLayer.startPoint = CGPointMake(0.5, 0);
        gradientLayer.endPoint = CGPointMake(0.5, 1);
    }else if (side == ViewShadowPathSideRight){
        //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
        gradientLayer.startPoint = CGPointMake(1, 0.5);
        gradientLayer.endPoint = CGPointMake(0, 0.5);
    }else if (side == ViewShadowPathSideBottom){
        //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
        gradientLayer.startPoint = CGPointMake(0.5, 1);
        gradientLayer.endPoint = CGPointMake(0.5, 0);
    }
    //  设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0,@1];
    [self.layer addSublayer:gradientLayer];
}

- (void)drawLineOfDashWithlineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor lineDirection:(BOOL)isHorizonal{
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.bounds];
    if (isHorizonal) {
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame))];
    } else{
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame)/2)];
    }
    
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    if (isHorizonal) {
        [shapeLayer setLineWidth:CGRectGetHeight(self.frame)];
    } else {
        [shapeLayer setLineWidth:CGRectGetWidth(self.frame)];
    }
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    
    if (isHorizonal) {
        CGPathAddLineToPoint(path, NULL,CGRectGetWidth(self.frame), 0);
    } else {
        CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(self.frame));
    }
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [self.layer addSublayer:shapeLayer];
}

@end
