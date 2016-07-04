//
//  TextSize.m
//  UtilityLayer
//
//  Created by 丁嘉睿 on 16/5/31.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "TextSize.h"

@implementation TextSize

+ (CGSize)getTheSizeWithContent:(NSString *)content font:(UIFont *)font{
    
    CGSize size = CGSizeZero;
    if (content.length == 0 && font == nil){
        return size;
    }else{
        if (IOS7_OR_LATER) {
            size = [content sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
        }else{
            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:content attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
            size = [attributedString size];
        }
        return size; 
    }
}
@end
