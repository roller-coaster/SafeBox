//
//  CoverData.m
//  UtilityLayer
//
//  Created by 丁嘉睿 on 16/5/30.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "CoverData.h"

@implementation CoverData

#pragma mark - /** 数据转换，根据参数创建字典数组 */
+ (void)coverArray:(NSMutableArray **)array withObjectsAndKeys:(id)value, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray *objects = nil;
    NSMutableArray *keys = nil;
    va_list args;
    id arg;
    int index=1;
    if (value) {
        objects = [NSMutableArray array];
        keys = [NSMutableArray array];
        va_start(args, value);
        arg = value;
        do {
            if (index%2) {
                [objects addObject:arg];
            } else {
                [keys addObject:arg];
            }
            index++;
        } while ((arg = va_arg(args,id)));
        va_end(args);
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    if (dic.count) {
        if (*array == nil) {
            *array = [NSMutableArray array];
        }
        [*array addObject:dic];
    }
}

@end
