//
//  BaseModel.h
//  SafeBoxBusinessLogicLayer
//
//  Created by 丁嘉睿 on 16/5/18.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import <Foundation/Foundation.h>

#define varString(var) [NSString stringWithFormat:@"%s",#var]
/** 
 * progerty:变量 &str:赋值地址
 * 例子：
 * NSString *name;
 * setPropertyName(abc.abc, &name);
 */
#define getPropertyName(property, str) \
if (0) {} else {\
/** 使宏判断传参是否正确 */\
NSString *propertyName = @"";\
[NSString stringWithFormat:@"%@", property];\
NSString *var = varString(property);\
/** .语法获取最后一个变量 */\
NSArray *tmpArray = [var componentsSeparatedByString:@"."];\
if (tmpArray.count > 0) {\
propertyName = tmpArray.lastObject;\
} else { /** 空格语法获取最后一个变量 */\
NSArray *spArray = [var componentsSeparatedByString:@" "];\
if (spArray.count > 0) {\
NSString *tmpStr = spArray.lastObject;\
/** 去掉多余符号 */\
tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"]" withString:@""];\
tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"}" withString:@""];\
propertyName = [tmpStr stringByReplacingOccurrencesOfString:@" " withString:@""];\
}\
}\
*str = [propertyName copy];\
}

@interface BaseModel : NSObject <NSSecureCoding>

/** 深复制 */
- (id)deepCopy;

@end
