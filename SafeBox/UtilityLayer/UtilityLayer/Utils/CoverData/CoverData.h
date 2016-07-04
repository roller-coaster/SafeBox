//
//  CoverData.h
//  UtilityLayer
//
//  Created by 丁嘉睿 on 16/5/30.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoverData : NSObject

/**
 *  @author djr
 *  
 *  数据转换，根据参数创建字典数组
 *  @param array 数组地址&array
 *  @param value 字典
 */
+ (void)coverArray:(NSMutableArray **)array withObjectsAndKeys:(id)value, ... NS_REQUIRES_NIL_TERMINATION;

@end
