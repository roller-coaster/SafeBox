//
//  ArchiverUtils.h
//  UtilityLayer
//
//  Created by 丁嘉睿 on 16/6/5.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArchiverUtils : NSObject

/** 创建文件 */
+ (void)ArchiverObject:(id)object filePath:(NSString *)filePath;

/** 读取文件 */
+ (id)UnarchiverObjectWithFilePath:(NSString *)filePath;


@end
