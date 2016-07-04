//
//  UIBarButtonItem+Create.m
//  UtilityLayer
//
//  Created by 丁嘉睿 on 16/5/30.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "UIBarButtonItem+Create.h"

@implementation UIBarButtonItem (Create)

#pragma mark - 文字创建

#pragma mark - 根据图片创建
+ (UIBarButtonItem *)newImageBarBtn:(UIImage *)img target:(id)target action:(SEL)action {
    
    if (!img) return nil;
    
    UIImageView *imgV = [[UIImageView alloc] initWithImage:img];
    imgV.userInteractionEnabled = TRUE;
    [imgV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:target action:action]];
    return [[UIBarButtonItem alloc] initWithCustomView:imgV];
}

@end
