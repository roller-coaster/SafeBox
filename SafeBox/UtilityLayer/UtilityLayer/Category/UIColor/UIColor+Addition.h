//
//  UIColor+Addition.h
//  UtilityLayer
//
//  Created by 丁嘉睿 on 16/5/30.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Addition)

/**
 *  @author djr
 *  
 *  获取颜色
 *  @param color 字符串
 *  @return 返回颜色
 */
+ (UIColor *)colorFromHexString: (NSString *)color;

+ (UIImage *)createImageWithColor:(UIColor*)color;

@end

