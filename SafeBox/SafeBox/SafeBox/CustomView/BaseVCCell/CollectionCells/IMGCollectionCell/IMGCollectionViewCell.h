//
//  IMGCollectionViewCell.h
//  SafeBox
//
//  Created by 丁嘉睿 on 16/6/2.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "MyCollectionViewCell.h"

@interface IMGCollectionViewCell : MyCollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *editingImg;

- (void)buildCellWithDataSource:(id)date;

- (void)setCellLayerWithNeed:(BOOL)need borderColor:(UIColor *)color borderWidth:(CGFloat)width;
@end
