//
//  NSDate+Analyse.m
//  MiracleMessenger
//
//  Created by GZMLUser on 15-3-25.
//  Copyright (c) 2015年 Anson. All rights reserved.
//

#import "NSDate+Analyse.h"
#import "NSDate+Common.h"


#define kDicKeys @[@"0今天", @"1昨天", @"2一周以内", @"3一周到一个月", @"4一个月到三个月", @"5三个月到半年", @"6半年到一年", @"7一年多"]

@implementation NSDate (Analyse)

#pragma mark - 解析日期
- (NSString *)analyseDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour)
                                               fromDate:self
                                                 toDate:[NSDate date]
                                                options:0];
    
    NSInteger hour = [components hour];
    NSInteger day = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    
    NSDateComponents *courrentComponents = [calendar components:NSCalendarUnitHour fromDate:self];
    NSInteger courrentHour = [courrentComponents hour];
   
    //    @[@"0今天", @"1昨天", @"2一周以内", @"3一周到一个月", @"4一个月到三个月", @"5三个月到半年", @"6半年到一年", @"7一年多"]
    if (year>0) {
        if (month>0||day>0) {
            return kDicKeys[7];
        } else {
            return kDicKeys[6];
        }
    } else if (month>0) {
        if (month>=6) {
            if (month==6 && day==0) {
                return kDicKeys[5];
            }
            return kDicKeys[6];
        } else if (month>=3) {
            if (month==3 && day==0) {
                return kDicKeys[4];
            }
            return kDicKeys[5];
        } else if (month>=1) {
            if (month==1 && day==0) {
                return kDicKeys[3];
            }
            return kDicKeys[4];
        }
    } else if (day>7) {
        return kDicKeys[3];
    } else if (day<=7 && day>=2) {
        return kDicKeys[2];
    } else if (day==1) {
        return kDicKeys[1];
        
    } else if (24 - courrentHour < hour) { // 在当天内
        
        return kDicKeys[1];
    } else
        return kDicKeys[0];
        
    return kDicKeys[0];
}

//nsstring 转 nsdate
+ (NSDate *)dateFromString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

//nadate 转 nsstring
+ (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

// 时间戳转换
+ (NSString *)dateWithDateString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval timeInt = [dateString doubleValue]/1000;

    NSDate * getDate = [NSDate dateWithTimeIntervalSince1970:timeInt];

    NSString * getDateString = [dateFormatter stringFromDate:getDate];
 
    return getDateString;
}

- (NSString *)getMsgDateForDetailListSinceNow
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSString *dateString = nil;
    
    NSDate *nowDate = [[NSDate date] todayEndTime];
    NSInteger days = [nowDate daysDifferentFromOtherDate:self];
    
    if (![self sameYearWithDate:nowDate]) { /** 不同年份 */
        [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
        dateString = [dateFormatter stringFromDate:self];
    } else if (![self sameMonthWithDate:nowDate]) {/** 不同月份 */
//        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
        dateString = [dateFormatter stringFromDate:self];
    } else {
        [dateFormatter setDateFormat:@"HH:mm"];
        dateString = [dateFormatter stringFromDate:self];
        if (days == 0) { /** 今天 */
            
        } else if (days == 1) {/** 昨天 */
            dateString = [@"昨天" stringByAppendingFormat:@" %@", dateString];
        } else if (days > 0 && days < 7) {/** 一周内 */
            NSInteger var = [self weekday];
            dateString = [[NSDate getWeekDay:var] stringByAppendingFormat:@" %@", dateString ];
        } else { /** 其他 */
            [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
            dateString = [dateFormatter stringFromDate:self];
        }
    }
    
    return dateString;
}

- (NSString *)getMsgDateForCellListSinceNow
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSString *dateString = nil;

    NSDate *nowDate = [[NSDate date] todayEndTime];
    
    
    NSInteger days = [nowDate daysDifferentFromOtherDate:self];
    
    if (days == 0) { /** 今天 */
        [dateFormatter setDateFormat:@"HH:mm"];
        dateString = [dateFormatter stringFromDate:self];
    } else if (days == 1) {/** 昨天 */
        dateString = @"昨天";
    } else if (days > 0 && days < 7) {/** 一周内 */
        NSInteger var = [self weekday];
        dateString = [NSDate getWeekDay:var];
    } else { /** 其他 */
        [dateFormatter setDateFormat:@"yy/M/d"];
        dateString = [dateFormatter stringFromDate:self];
    }
    
    return dateString;
}

+ (NSString *)getWeekDay:(NSInteger)var{
    switch (var) {
        case 1:
            return @"星期日";
            break;
        case 2:
            return @"星期一";
            break;
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            break;
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
        case 7:
            return @"星期六";
            break;
    }
    return nil;
}

+ (NSString *)getSecondWith:(int)second{
    BOOL isHH = NO;
    NSString *tmphh = [NSString stringWithFormat:@"%d",second/3600];  
    if (tmphh.length == 1) {
        isHH = [tmphh intValue] > 0 ? YES : NO;
        tmphh = [NSString stringWithFormat:@"0%@",tmphh];
    }
    NSString *tmpmm = [NSString stringWithFormat:@"%d",(second/60)%60];  
    if (tmpmm.length == 1) {
        tmpmm = [NSString stringWithFormat:@"0%@",tmpmm];
    }
    NSString *tmpss = [NSString stringWithFormat:@"%d",second%60];  
    if (tmpss.length == 1) {
        tmpss = [NSString stringWithFormat:@"0%@",tmpss];
    }
    
    NSString *time = [NSString stringWithFormat:@"%@:%@",tmpmm,tmpss];
    if (isHH) {
        return [NSString stringWithFormat:@"%@:%@",tmphh,time];
    }else{
        return time;
    }
}

@end
