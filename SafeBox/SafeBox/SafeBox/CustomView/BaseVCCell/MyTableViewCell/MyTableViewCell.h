//
//  MyTableViewCell.h
//  MiracleMessenger
//
//  Created by LamTsanFeng on 14/12/19.
//  Copyright (c) 2014年 Anson. All rights reserved.
//


#import <UIKit/UIKit.h>

#define MarginX    10 // 距左边框间距 和右边框间距
#define MarginY    6  // 距上边框和下边框间距
#define Contact_Margin_width 10 // 子控制器间距

#define TimeLabel_Width     62 // 姓名Label大小
#define NameLabel_Height    20 // 姓名Label高度


@interface MyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UITextField *rightTextField;

/** cell重用标识 */
+ (NSString *)identifier;

/** 设置Cell相关数据*/
- (void)setCellData:(id)cellData;

@end
