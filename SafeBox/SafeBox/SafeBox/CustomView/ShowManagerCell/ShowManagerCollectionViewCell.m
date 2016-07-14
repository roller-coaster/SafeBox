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

@property (weak, nonatomic) IBOutlet UIImageView *playImageView;

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
            _playImageView.hidden = YES;
            FileImageItem *imageItem = (FileImageItem *)item;
            _showImageView.image = imageItem.image;
            
        }else if (item.fileType == FileType_video){
            _playImageView.hidden = NO;
            NSString *firstImgPath = [[item.filePath stringByDeletingPathExtension] stringByAppendingFormat:@".png"];
            if ([FileUtility fileExist:firstImgPath]) {
                _showImageView.image = [UIImage imageWithContentsOfFile:firstImgPath];
            }else{
                NSURL *url = [NSURL fileURLWithPath:item.filePath
                              ];
                UIImage *image = [VideoUtils thumbnailImageForVideo:url atTime:1.0f];
                _showImageView.image = image;
                [UIImagePNGRepresentation(image) writeToFile:firstImgPath atomically:YES];
            }
        }
    }
    
}
@end
