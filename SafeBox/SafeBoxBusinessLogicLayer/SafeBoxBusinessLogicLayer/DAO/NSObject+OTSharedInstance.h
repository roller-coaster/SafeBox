//
//  NSObject+OTSharedInstance.h
//  SafeBoxBusinessLogicLayer
//
//  Created by 丁嘉睿 on 16/6/30.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (OTSharedInstance)

@end

@protocol OTSharedInstance <NSObject>

@optional
+ (instancetype)sharedInstance;
+ (void)freeSharedInstance;

@end
