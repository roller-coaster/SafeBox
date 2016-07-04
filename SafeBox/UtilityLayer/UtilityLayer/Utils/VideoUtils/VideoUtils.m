//
//  VideoUtils.m
//  UtilityLayer
//
//  Created by 丁嘉睿 on 16/5/31.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "VideoUtils.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVAsset.h>

@implementation VideoUtils

+ (void)GIFImageForVideo:(NSURL *)videoURL complete:(void (^)(UIImage *gifImage))complete
{
    
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    
    AVURLAsset *myAsset = [[AVURLAsset alloc] initWithURL:videoURL options:opts];
    CMTimeValue value = myAsset.duration.value;//总帧数
    CMTimeScale timeScale = myAsset.duration.timescale; //timescale为  fps
    long long second = value / timeScale; // 获取视频总时长,单位秒
    
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:myAsset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    assetImageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    
    NSMutableArray *images = [NSMutableArray array];
    NSMutableArray *times = [NSMutableArray array];
    for (float i = 1; i <= second; i++) {
        NSValue *value = [NSValue valueWithCMTime:CMTimeMakeWithSeconds(i, 60)];
        [times addObject:value];
    }
    __block NSInteger index = times.count;
    
    [assetImageGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:
     ^(CMTime requestedTime, CGImageRef image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error)
     {
         
         NSLog(@"actual got image at time:%f", CMTimeGetSeconds(actualTime));
         if (image)
         {
             [CATransaction begin];
             [CATransaction setDisableActions:YES];
             
             UIImage *img = [UIImage imageWithCGImage:image];
             //             NSString *path = [[GlobalConstants documentPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%f.jpg", CMTimeGetSeconds(actualTime)]];
             //             [UIImageJPEGRepresentation(img, 1.f) writeToFile:path atomically:YES];
             [images addObject:img];
             
             [CATransaction commit];
         }
         if (--index == 0) {
             if (complete && images.count) {
                 complete([UIImage animatedImageWithImages:images duration:second]);
             }
         }
     }];
}

#pragma mark - 压缩视频
+ (void)compress:(NSString *)path complere:(void (^)(NSError *error))complete
{
    if (path.length == 0) return;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSURL *saveUrl = [NSURL fileURLWithPath:path];
        
        // 通过文件的 url 获取到这个文件的资源
        AVURLAsset *avAsset = [[AVURLAsset alloc] initWithURL:saveUrl options:nil];
        // 用 AVAssetExportSession 这个类来导出资源中的属性
        NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
        
        // 压缩视频
        if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality]) { // 导出属性是否包含低分辨率
            // 通过资源（AVURLAsset）来定义 AVAssetExportSession，得到资源属性来重新打包资源 （AVURLAsset, 将某一些属性重新定义
            AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
            
            // 设置导出文件的存放路径
            NSString *outPutPath = [[path stringByDeletingPathExtension] stringByAppendingString:@"sad.mp4"];
            exportSession.outputURL = [NSURL fileURLWithPath:outPutPath];
            
            /** 压缩完成再删除原视频 */
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager removeItemAtPath:path  error:nil];            
            
            // 是否对网络进行优化
            exportSession.shouldOptimizeForNetworkUse = true;
            
            // 转换成MP4格式
            exportSession.outputFileType = AVFileTypeMPEG4;
            
            // 开始导出,导出后执行完成的block
            [exportSession exportAsynchronouslyWithCompletionHandler:^{
                // 如果导出的状态为完成
                if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (complete) {
                            complete(nil);
                        }
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (complete) {
                            NSError *error = [NSError errorWithDomain:@"压缩错误" code:(long)[exportSession status] userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"压缩出现其他错误，错误类型：%ld", (long)[exportSession status]]}];
                            complete(error);
                        }
                        NSLog(@"压缩出现其他错误，错误类型：%ld", (long)[exportSession status]);
                    });
                }
            }];
        } else {
            NSLog(@"压缩失败**:%@",path);
        }
    });
}


@end
