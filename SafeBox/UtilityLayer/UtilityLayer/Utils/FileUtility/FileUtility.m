//
//  FileUtility.m
//  UtilityLayer
//
//  Created by 丁嘉睿 on 16/5/18.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "FileUtility.h"


@implementation FileUtility



+ (BOOL)createFolder:(NSString *)path errStr:(NSString **)errStr
{
    if (path.length == 0) return FALSE;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    if (![fileManager fileExistsAtPath:path]) {
        
        if (![fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
            if (errStr) (*errStr) = [error localizedDescription];
            NSLog(@"createFolder error: %@ \n",[error localizedDescription]);
            return FALSE;
        }
    }
    return TRUE;
}

+ (BOOL)createFile:(NSString *)path {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        
        return [fileManager createFileAtPath:path contents:nil attributes:nil];
    }
    return TRUE;
}

+ (BOOL)fileExist:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return ([fileManager fileExistsAtPath:path]);
}

+ (BOOL)directoryExist:(NSString *)path {
    BOOL isDirectory = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL exist = ([fileManager fileExistsAtPath:path isDirectory:&isDirectory]);
    return (exist && isDirectory);
}

+ (BOOL)moveFileAtPath:(NSString *)atPath toPath:(NSString *)toPath{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (atPath.length > 0 && toPath.length > 0) {/** 如果文件路径为空就不操作 */
        return ([fileManager moveItemAtPath:atPath toPath:toPath error:nil]);
    } else {
        return NO;
    }
}

+ (BOOL)copyFileAtPath:(NSString *)atPath toPath:(NSString *)toPath{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (atPath.length > 0 && toPath.length > 0) {/** 如果文件路径为空就不复制 */
        NSError *error = nil;
        BOOL isYES = [fileManager copyItemAtPath:atPath toPath:toPath error:&error];
        if (isYES && error == nil) {
            return YES;
        }else{
            NSLog(@"%@",error.localizedDescription);
            return NO;
        }
    }else{
        return NO;
    }
}

+ (BOOL)removeFile:(NSString *)path {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        return ([fileManager removeItemAtPath:path error:nil]);
    } else {
        return NO;
    }
}

+ (void)writeLogToFile:(NSString *)filePath appendTxt:(NSString *)txt {
    
    @synchronized(self) {
        NSDate *today = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *content = [NSString stringWithFormat:@"%@     _%@\n", [formatter stringFromDate:today], txt];
        NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
        
        NSFileManager *filemgr = [NSFileManager defaultManager];
        if ([filemgr fileExistsAtPath: filePath ] == FALSE)
        {
            NSLog (@"File not found");
            [filemgr createFileAtPath:filePath contents:contentData attributes:nil];
            
        }else {
            
            NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
            if (myHandle == nil) {
                NSLog(@"Failed to open file");
                return;
            }
            [myHandle seekToEndOfFile];
            [myHandle writeData:contentData];
            [myHandle closeFile];
        }
    }
}

+ (u_int64_t)fileSizeForPath:(NSString *)path
{
    signed long long fileSize = 0;
    NSFileManager *fileManager = [NSFileManager new]; // default is not thread safe
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileSize = [fileDict fileSize];
        }
    }
    return fileSize;
}

+ (NSArray *)findFile:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *array = [fileManager contentsOfDirectoryAtPath:path error:nil];
    return array;
}

#pragma mark -
#pragma mark - 当前document路径
+ (NSString *)documentPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
}
#pragma mark - 当前document路径创建文件夹
+ (BOOL) createFileWithName:(NSString *)name{
    if (name.length == 0) return NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *document = [FileUtility documentPath];
    
    NSString *createPath = [NSString stringWithFormat:@"%@/%@", document,name];
    
    if (![fileManager fileExistsAtPath:createPath]) {
       return [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return YES;
}


+ (NSArray *)ergodicFolder:(NSString *)path
{
    NSMutableArray *dirArray = [NSMutableArray array];
    [self ergodicFolder:path list:&dirArray];
    return [dirArray copy];
}

#pragma mark - 遍历文件夹内的文件，将所有子目录的文件找出
+ (void)ergodicFolder:(NSString *)documentDir list:(NSMutableArray **)dirArray
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    NSArray *fileList = [fm contentsOfDirectoryAtPath:documentDir error:&error];
    if (error == nil) {
        //在上面那段程序中获得的fileList中列出文件夹名
        for (NSString *file in fileList) {
            NSString *path = [documentDir stringByAppendingPathComponent:file];
            
            BOOL isDir,isPath;
            //检查路径是否正确
            isPath = [fm fileExistsAtPath:path isDirectory:&isDir];
            if (isPath) {
                //判断路径是文件夹还是文件
                if (isDir) {
                    //文件夹
                    [self ergodicFolder:path list:dirArray];
                } else {
                    /** 文件 */
                    [*dirArray addObject:path];
                }
            } else {
                NSLog(@"%@不存在", path);
            }
        }
    } else {
        NSLog(@"%@", [error localizedDescription]);
    }
}

@end
