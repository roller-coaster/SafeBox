//
//  IMGCollectionViewCell.m
//  SafeBox
//
//  Created by 丁嘉睿 on 16/6/2.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "IMGCollectionViewCell.h"


@interface IMGCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *theImageView;

@end

@implementation IMGCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}
- (void)buildCellWithDataSource:(id)date{
    UIImage *image = (UIImage *)date;
    self.theImageView.image = image;
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    imageV.image = image;
}

- (void)setCellLayerWithNeed:(BOOL)need borderColor:(UIColor *)color borderWidth:(CGFloat)width{
    if (need){
        self.layer.cornerRadius = 5.0;
        self.layer.borderWidth = width;
        self.layer.borderColor = color.CGColor;
        
    }else{
        self.layer.cornerRadius = 0.0;
        self.layer.borderWidth = 0.0;
    }
}

@end
