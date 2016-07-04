//
//  MyTableViewCell.m
//  MiracleMessenger
//
//  Created by GZMLUser on 15-4-21.
//  Copyright (c) 2015年 GZMiracle. All rights reserved.
//

#import "MyTableViewCell.h"

@interface MyTableViewCell ()

@end

@implementation MyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)identifier
{
    return NSStringFromClass([self class]);
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
  
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

#pragma mark - /** 设置Cell相关数据*/
- (void)setCellData:(id)cellData
{
    
}

//#pragma mark - /** 设置ImageView圆角 **/
//- (void)setImageViewCorner:(ImageCornerType)type {
//    self.imgCornerType = type;
//}


@end
