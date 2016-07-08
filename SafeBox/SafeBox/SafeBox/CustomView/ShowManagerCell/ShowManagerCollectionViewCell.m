//
//  ShowManagerCollectionViewCell.m
//  SafeBox
//
//  Created by 丁嘉睿 on 16/7/8.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "ShowManagerCollectionViewCell.h"

@interface ShowManagerCollectionViewCell ()


@property (weak, nonatomic) IBOutlet UIImageView *showImageView;

@end
@implementation ShowManagerCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setItem:(id)aItem{
    if ([aItem isKindOfClass:[FileItem class]]) {
        FileItem *item = (FileItem *)aItem;
        if (item.fileType == FileType_photo) {
            FileImageItem *imageItem = (FileImageItem *)item;
            _showImageView.image = imageItem.image;
        }else if (item.fileType == FileType_video){
            
        }
    }
    
}
@end
