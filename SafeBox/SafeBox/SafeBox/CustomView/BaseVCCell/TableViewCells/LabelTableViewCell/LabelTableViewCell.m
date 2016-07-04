//
//  LabelTableViewCell.m
//  SafeBox
//
//  Created by 丁嘉睿 on 16/6/2.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "LabelTableViewCell.h"

@interface LabelTableViewCell ()


@end
@implementation LabelTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self setUIFrame];
}
#pragma mark - 公共
- (void)setCellData:(id)cellData{
}

#pragma mark - private
#pragma mark 设置控件frame
- (void)setUIFrame{
    CGSize size = CGSizeZero;
    if (IOS7_OR_LATER) {
        size = [self.numLabe.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.numLabe.font,NSFontAttributeName, nil]];
    }
    self.numLabe.frame = CGRectMake(CGRectGetMinX(self.numLabe.frame), CGRectGetMinY(self.numLabe.frame), size.width, size.height);
    [self.contentView addSubview:self.numLabe];
}
@end
