//
//  NSDate+Analyse.h
//  MiracleMessenger
//
//  Created by GZMLUser on 15-3-25.
//  Copyright (c) 2015年 Anson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Analyse)

/** 解析日期 */
- (NSString *)analyseDate;
/** nsstring转换nsdate */
+ (NSDate *)dateFromString:(NSString *)dateString;
/** nsdate转换nsstring */
+ (NSString *)stringFromDate:(NSDate *)date;
/**时间戳计算*/
+ (NSString *)dateWithDateString:(NSString *)dateString;
- (NSString *)getMsgDateForDetailListSinceNow;
- (NSString *)getMsgDateForCellListSinceNow;
/**
 *  @author djr
 *  
 *  计算秒数
 *  @param second 秒数
 *  @return 返回00:00格式，如果大于或等于一个小时时，返回00:00:00格式
 */
+ (NSString *)getSecondWith:(int)second;
@end
