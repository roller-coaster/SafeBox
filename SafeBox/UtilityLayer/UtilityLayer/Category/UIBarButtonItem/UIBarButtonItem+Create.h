//
//  UIBarButtonItem+Create.h
//  UtilityLayer
//
//  Created by 丁嘉睿 on 16/5/30.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Create)

/**
 *  @author djr
 *  
 *  文字创建UIBarButtonItem（最大宽为50）
 *  @param title title
 *  @param target target
 *  @param action action
 *  @return UIBarButtonItem
 */
+ (instancetype)newNormalBarBtnTitle:(NSString *)title target:(id)target action:(SEL)action;

/**
 *  @author djr
 *  
 *  图片创建UIBarButtonItem
 *  @param img img
 *  @param target target
 *  @param action action
 *  @return UIBarButtonItem
 */
+ (instancetype)newImageBarBtn:(UIImage *)img target:(id)target action:(SEL)action;

@end
