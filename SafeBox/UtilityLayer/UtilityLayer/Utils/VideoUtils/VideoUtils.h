//
//  VideoUtils.h
//  UtilityLayer
//
//  Created by 丁嘉睿 on 16/5/31.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VideoUtils : NSObject


/*
 * 获取第N帧的图片
 *videoURL:视频地址(本地/网络)
 *time      :第N帧
 */
+ (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;

/**
 *  @author djr
 *  
 *  压缩视频
 *  @param path 路径
 *  @param complete 压缩结果回调
 */
+ (void)compress:(NSString *)path complere:(void (^)(NSError *error))complete;

@end
