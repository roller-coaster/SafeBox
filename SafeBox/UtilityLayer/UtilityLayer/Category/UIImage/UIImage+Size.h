//
//  UIImage+Size.h
//  UtilityLayer
//
//  Created by 丁嘉睿 on 16/7/8.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Size)

/** 根据图片大小和设置的最大宽imageSizeBySize度，返回缩放后的大小 */
+ (CGSize)imageSizeBySize:(CGSize)size maxWidth:(CGFloat)maxWidth;
/** 根据图片大小和设置的最大高度，返回缩放后的大小 */
+ (CGSize)imageSizeBySize:(CGSize)size maxHeight:(CGFloat)maxHeight;
/** 根据图片大小和设置的大小，返回拉伸或缩放后的大小 2边都必须达到设置大小 */
+ (CGSize)scaleImageSizeBySize:(CGSize)imageSize targetSize:(CGSize)size isBoth:(BOOL)isBoth;

@end
