//
//  ArchiverUtils.m
//  UtilityLayer
//
//  Created by 丁嘉睿 on 16/6/5.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "ArchiverUtils.h"

@implementation ArchiverUtils

+ (void)ArchiverObject:(id)object filePath:(NSString *)filePath{
    if (filePath) {
        [NSKeyedArchiver archiveRootObject:object toFile:filePath];
    }
}

+ (id)UnarchiverObjectWithFilePath:(NSString *)filePath{
    if (filePath) {
        id object = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        return object;
    }
    return nil;
}
@end
