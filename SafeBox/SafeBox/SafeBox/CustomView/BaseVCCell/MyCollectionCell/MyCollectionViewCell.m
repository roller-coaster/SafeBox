//
//  MyCollectionViewCell.m
//  SafeBox
//
//  Created by 丁嘉睿 on 16/6/2.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "MyCollectionViewCell.h"

@implementation MyCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

//! 根据消息类型获取对应的cell字符串
+ (NSString *)identifier
{
    return NSStringFromClass([self class]);
}
@end
