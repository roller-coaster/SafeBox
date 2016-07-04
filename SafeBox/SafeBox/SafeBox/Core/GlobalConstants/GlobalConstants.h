//
//  GlobalConstants.h
//  SafeBox
//
//  Created by 丁嘉睿 on 16/5/18.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalConstants : NSObject

+ (GlobalConstants *)sharedGlobalConstants;

/** 保存推送vc的堆栈 */
@property (nonatomic, strong) NSMutableArray *arrayVCs;

@end
