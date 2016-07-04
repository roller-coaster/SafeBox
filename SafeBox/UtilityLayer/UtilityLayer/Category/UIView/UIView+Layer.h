//
//  UIView+Layer.h
//  UtilityLayer
//
//  Created by 丁嘉睿 on 16/5/30.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Layer)

/** 描边 */
- (void)addBorder;
- (void)addBorder:(UIColor *)color borderWidth:(float)width;
- (void)addBorder:(UIColor *)color borderWidth:(float)width isRadius:(BOOL)isRadius alpha:(float)alpha;
- (void)addBorder:(UIColor *)color borderWidth:(float)width cornerRadius:(float)cornerRadius alpha:(float)alpha;

/**
 
 描边－单边
 
 @param direction 0:上 1:左 2:下 3:右
 
 */
- (void)addBorder:(int)direction;
/**
 
 描边－单边
 
 @param direction 0:上 1:左 2:下 3:右
 @param color 描边颜色
 @param borderWidth 描边线粗
 
 */
- (void)addBorder:(int)direction color:(UIColor *)color borderWidth:(float)width;

/** 内描边 */
- (void)addInsideBorder:(UIColor *)color isRadius:(BOOL)isRadius alpha:(float)alpha;
- (void)addInsideBorder:(UIColor *)color borderWidth:(float)width isRadius:(BOOL)isRadius alpha:(float)alpha;

/** 分割线 */
- (void)addTopSeparatorLine;
- (void)addTopSeparatorLine:(UIColor *)color lineWidth:(float)width;

@end
