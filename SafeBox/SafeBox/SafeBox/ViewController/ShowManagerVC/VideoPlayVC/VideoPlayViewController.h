//
//  VideoPlayViewController.h
//  SafeBox
//
//  Created by 丁嘉睿 on 16/7/8.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "ZXBasicVC.h"



@interface VideoPlayViewController : ZXBasicVC

/** 视频地址 */
@property (nonatomic, copy) NSString *videoPath;

@property (copy, nonatomic) void(^removeVideoPlayerVCBlock)(VideoPlayViewController *target);

@end
