//
//  FileUtility.h
//  UtilityLayer
//
//  Created by 丁嘉睿 on 16/5/18.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtility : NSObject

+ (BOOL)createFile:(NSString *)path;
+ (BOOL)createFolder:(NSString *)path errStr:(NSString **)errStr;
+ (BOOL)fileExist:(NSString *)path;
+ (BOOL)directoryExist:(NSString *)path;
+ (BOOL)moveFileAtPath:(NSString *)atPath toPath:(NSString *)toPath;
+ (BOOL)copyFileAtPath:(NSString *)atPath toPath:(NSString *)toPath;
+ (BOOL)removeFile:(NSString *)path;
+ (void)writeLogToFile:(NSString *)filePath appendTxt:(NSString *)txt;
+ (u_int64_t)fileSizeForPath:(NSString *)path;

+ (NSArray *)findFile:(NSString *)path;
/** 遍历文件夹内的文件，将所有子目录的文件找出 */
+ (NSArray *)ergodicFolder:(NSString *)path;

/** 当前document路径 */
+ (NSString *)documentPath;
+ (BOOL)createFileWithName:(NSString *)name;
@end
