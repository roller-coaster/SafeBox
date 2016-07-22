//
//  CustomButtonTableViewCell.h
//  SafeBox
//
//  Created by 丁嘉睿 on 16/7/18.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomButtonTableViewCellDelegate <NSObject>

- (void)customButtonTableViewCellWithText:(NSString *)text;

@end

@interface CustomButtonTableViewCell : UITableViewCell

@property (weak, nonatomic) id<CustomButtonTableViewCellDelegate>delegate;

/**
 *  @author djr
 *  
 *  显示cell的内容
 *  @param titles titles 按钮数组
 *  @param headers headers 标题
 */
- (void)showCustomViewWithHeaders:(NSString *)headers titles:(NSArray <NSString *>*)titles;


/**
 *  @author djr
 *  
 *  计算cell的高度，必须得实现，在heightForRowAtIndexPath代理实现。
 *  @param headers headers 按钮数组
 *  @param titles titles  标题
 *  @return cell的高度
 */
+ (CGFloat)customCellForHeightWithHeaders:(NSString *)headers titles:(NSArray <NSString *>*)titles;

/**
 *  @author djr
 *  
 *  获取类名
 *  @return @"CustomButtonTableViewCell"
 */
+ (NSString *)identifier;
@end
