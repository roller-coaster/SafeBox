//
//  UIImage+Size.m
//  UtilityLayer
//
//  Created by 丁嘉睿 on 16/7/8.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "UIImage+Size.h"

@implementation UIImage (Size)

#pragma mark - /** 根据图片大小和设置的最大宽imageSizeBySize度，返回缩放后的大小 */
+ (CGSize)imageSizeBySize:(CGSize)size maxWidth:(CGFloat)maxWidth
{
    if (maxWidth == 0) return size;
    CGSize imageSize = size;
    if (imageSize.width > maxWidth) {
        /** 压缩比例 */
        CGSize aSize = imageSize;
        CGFloat width = 0;
        CGFloat height = 0;
        if (aSize.height > aSize.width){
            width = aSize.width/aSize.height * maxWidth;
            height = aSize.height/aSize.width * width;
        }else{
            height = aSize.height/aSize.width * maxWidth;
            width = aSize.width/aSize.height * height;
        }
        imageSize = CGSizeMake(ceilf(width), ceilf(height));
    }
    return imageSize;
}

#pragma mark - /** 根据图片大小和设置的最大高度，返回缩放后的大小 */
+ (CGSize)imageSizeBySize:(CGSize)size maxHeight:(CGFloat)maxHeight
{
    if (maxHeight == 0) return size;
    CGSize imageSize = size;
    if (imageSize.height > maxHeight) {
        /** 压缩比例 */
        CGSize aSize = imageSize;
        CGFloat width = 0;
        CGFloat height = 0;
        if (aSize.height > aSize.width){
            width = aSize.width/aSize.height * maxHeight;
            height = aSize.height/aSize.width * width;
        }else{
            height = aSize.height/aSize.width * maxHeight;
            width = aSize.width/aSize.height * height;
        }
        imageSize = CGSizeMake(ceilf(width), ceilf(height));
    }
    return imageSize;
}


#pragma mark - /** 根据图片大小和设置的大小，返回拉伸或缩放后的大小 2边都必须达到设置大小 */
+ (CGSize)scaleImageSizeBySize:(CGSize)imageSize targetSize:(CGSize)size isBoth:(BOOL)isBoth {
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (isBoth) {
            if(widthFactor > heightFactor){
                scaleFactor = widthFactor;
            }
            else{
                scaleFactor = heightFactor;
            }
        } else {
            if(widthFactor > heightFactor){
                scaleFactor = heightFactor;
            }
            else{
                scaleFactor = widthFactor;
            }
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    return CGSizeMake(ceilf(scaledWidth), ceilf(scaledHeight));
}

@end
