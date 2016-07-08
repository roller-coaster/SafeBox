//
//  FileItem.h
//  SafeBoxBusinessLogicLayer
//
//  Created by 丁嘉睿 on 16/7/8.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "BaseModel.h"
#import <UIKit/UIKit.h>

//文件类型
typedef NS_ENUM(NSInteger, FileType) {
    FileTypeNotAnalysis = -1,    //未分析
    FileType_document,
    FileType_photo,
    FileType_video,
    FileType_audio,
    FileTypeUnknown,
};


@interface FileItem : BaseModel

@property (nonatomic, copy) NSString *filePath;

//! 文件保存时间
@property (assign, nonatomic)             long long                fileSaveTime;
//! 文件创建时间
@property (nonatomic ,assign)             long long                fileCreateTime;

//! 文件大小，单位b
@property (assign, nonatomic)               float                 fileTotalSize;

//! 文件名
@property (copy, nonatomic)               NSString                *fileName;
//! 文件类型枚举
@property (assign, readonly ,nonatomic)     FileType        fileType;
//! 扩展名
@property (copy, readonly, nonatomic)     NSString        *extension;

//! 根据文件名返回文件类型
+ (FileType)analyseFileType:(NSString *)aFileName;

/**
 *  @author djr
 *  
 *  根据文件地址初始化
 *  @param path 地址
 *  @return FileItem
 */
- (instancetype)initWithFilePath:(NSString *)path;
@end


#pragma mark - 图片文件Model
@interface FileImageItem : FileItem

/** 图片宽度 */
@property (assign, nonatomic)               float            imageWidth;
/** 图片高度 */
@property (assign, nonatomic)               float            imageHeight;
/** 图片 */
@property (strong, nonatomic)               UIImage          *image;

@end

#pragma mark - 视频文件Model
@interface FileVideoItem : FileItem

//! 视频时长
@property (assign, nonatomic)               NSTimeInterval  videoDuration;
/** 视频宽度 */
@property (assign, nonatomic)               float           videoWidth;
/** 视频高度 */
@property (assign, nonatomic)               float           videoHeight;

@end
