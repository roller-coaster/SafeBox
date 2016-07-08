//
//  FileItem.m
//  SafeBoxBusinessLogicLayer
//
//  Created by 丁嘉睿 on 16/7/8.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "FileItem.h"

/** 判断文件后缀类型 */
#define kTypeArray @[@"docx doc pdf ppt pptx txt rtf xls xlsx", @"jpg jpeg png gif bmp", @"H.264 M4V MP4 MOV MPEG-4 AVI mp4 mov m4v avi", @"aac mp3 aiff wav"]

@interface FileItem()
@property (assign, nonatomic)    FileType    fileType;   //文件类型枚举
@property (copy, nonatomic)    NSString    *extension; //扩展名
@end

@implementation FileItem

#pragma mark - Public Method
#pragma mark 根据文件名返回文件类型
+ (FileType)analyseFileType:(NSString *)aFileName{
    
    NSString *extension = [aFileName pathExtension];
    FileType type = FileTypeUnknown;
    if (aFileName.length > 0) {
        for (NSString *typeString in kTypeArray){
            NSArray *arrays = [typeString componentsSeparatedByString:@" "];
            for (NSString *typeName in arrays) {
                if ([typeName isEqualToString:[extension lowercaseString]]) {
                    type = [kTypeArray indexOfObject:typeString];
                    break;
                }
            }
        }
    }
    return type;
}

#pragma mark 初始化
- (instancetype)initWithFilePath:(NSString *)path{
    if (path.length == 0) return nil;
    self = [super init];
    if (self) {
        _filePath = path;
        _fileType = [FileItem analyseFileType:path];
        NSString *exestr = nil;
        // 从路径中获得完整的文件名（带后缀）      
        exestr = [path lastPathComponent];
        // 获得文件名（不带后缀）  
        _fileName = [exestr stringByDeletingPathExtension];
        _extension = [path pathExtension];
    }return self;
}

@end


@implementation FileImageItem

/** 重写initWithFilePath */
- (instancetype)initWithFilePath:(NSString *)path{
    self = [super initWithFilePath:path];
    if (self) {
        _image = [UIImage imageWithContentsOfFile:path];
        _imageWidth = _image.size.width;
        _imageHeight = _image.size.height;
    }return self;
}

@end
