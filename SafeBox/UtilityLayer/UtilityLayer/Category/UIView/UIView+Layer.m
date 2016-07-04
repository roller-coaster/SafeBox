//
//  UIView+Layer.m
//  UtilityLayer
//
//  Created by 丁嘉睿 on 16/5/30.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "UIView+Layer.h"
@implementation UIView (Layer)


#pragma mark - 描边
- (void)addBorder
{
    [self addBorder:[UIColor colorFromHexString:@"#a7a7ab"] borderWidth:0.5f];
}

- (void)addBorder:(UIColor *)color borderWidth:(float)width
{
    [self addBorder:color borderWidth:width isRadius:NO alpha:1.f];
}

- (void)addBorder:(UIColor *)color borderWidth:(float)width isRadius:(BOOL)isRadius alpha:(float)alpha
{
    //设置layer
    CALayer *layer = [self layer];
    //设置边框线的宽
    [layer setBorderWidth:width];
    //设置边框线的颜色
    [layer setBorderColor:[color CGColor]];
    if (isRadius) {
        //是否设置边框以及是否可见
        [layer setMasksToBounds:YES];
        layer.cornerRadius = CGRectGetHeight(layer.frame)/2;
    }
    layer.opacity = alpha;
}

- (void)addBorder:(UIColor *)color borderWidth:(float)width cornerRadius:(float)cornerRadius alpha:(float)alpha
{
    //设置layer
    CALayer *layer = [self layer];
    //设置边框线的宽
    [layer setBorderWidth:width];
    //设置边框线的颜色
    [layer setBorderColor:[color CGColor]];
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    layer.cornerRadius = cornerRadius;
    layer.opacity = alpha;
    
}

- (void)addBorder:(int)direction
{
    [self addBorder:direction color:[UIColor colorFromHexString:@"#a7a7ab"] borderWidth:0.5f];
}

- (void)addBorder:(int)direction color:(UIColor *)color borderWidth:(float)width
{
    int tag = 5678900+direction;
    NSString *kTag = @"tag";
    BOOL isAdd = YES;
    CALayer *TopBorder = nil;
    
    for (CALayer *layer in [self.layer sublayers]) {
        int layerTag = [[layer valueForKey: kTag] intValue];
        if (layerTag == tag) {
            TopBorder = layer;
            isAdd = NO;
            break;
        }
    }
    if (TopBorder == nil) {
        TopBorder = [CALayer layer];
        [TopBorder setValue:@(tag) forKey:kTag];
    }
    if (direction == 0) { /** 上 */
        TopBorder.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, width);
    } else if (direction == 1) { /** 左 */
        TopBorder.frame = CGRectMake(0.0f, 0.0f, width, self.frame.size.height);
    } else if (direction == 2) { /** 下 */
        TopBorder.frame = CGRectMake(0.0f, self.frame.size.height-width, self.frame.size.width, width);
    } else if (direction == 3) { /** 右 */
        TopBorder.frame = CGRectMake(self.frame.size.width-width, 0, width, self.frame.size.height);
    }
    
    TopBorder.backgroundColor = color.CGColor;
    if (isAdd) {
        [self.layer addSublayer:TopBorder];
    }
}

#pragma mark - 内描边
- (void)addInsideBorder:(UIColor *)color isRadius:(BOOL)isRadius alpha:(float)alpha
{
    [self addInsideBorder:color borderWidth:3.0f isRadius:isRadius alpha:alpha];
}

- (void)addInsideBorder:(UIColor *)color borderWidth:(float)width isRadius:(BOOL)isRadius alpha:(float)alpha
{
    float margin = -1;
    CALayer *borderLayer = [[CALayer alloc] init];
    borderLayer.frame = CGRectInset(self.bounds, margin, margin);
    borderLayer.borderWidth = width-margin;
    borderLayer.borderColor = color.CGColor;
    if (isRadius) {
        borderLayer.masksToBounds = YES;
        borderLayer.cornerRadius = CGRectGetHeight(borderLayer.frame)/2;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = CGRectGetHeight(self.layer.frame)/2;
    }
    borderLayer.opacity = alpha;
    [[self.layer sublayers] makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.layer addSublayer:borderLayer];
}

#pragma mark - 新增分割线
- (void)addTopSeparatorLine
{
    [self addTopSeparatorLine:[UIColor colorFromHexString:@"#cecfda"] lineWidth:0.5f];
}

- (void)addTopSeparatorLine:(UIColor *)color lineWidth:(float)width
{
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), 0)];
    [bezierPath closePath];
    CAShapeLayer *lineLayer = [[CAShapeLayer alloc] init];
    lineLayer.frame = self.bounds;
    lineLayer.path = bezierPath.CGPath;
    lineLayer.strokeColor = color.CGColor;
    lineLayer.lineWidth = width;
    [self.layer addSublayer:lineLayer];
}

@end
