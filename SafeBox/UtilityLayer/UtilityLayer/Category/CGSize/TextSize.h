//
//  TextSize.h
//  UtilityLayer
//
//  Created by 丁嘉睿 on 16/5/31.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextSize : NSObject

/**
 *  @author djr
 *  
 *  根据文字内容获取文字宽高
 *  @param content 文字内容
 *  @param font 文字大小
 *  @return size
 */
+ (CGSize)getTheSizeWithContent:(NSString *)content font:(UIFont *)font;

@end
