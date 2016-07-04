//
//  NSObject+OTSharedInstance.m
//  SafeBoxBusinessLogicLayer
//
//  Created by 丁嘉睿 on 16/6/30.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "NSObject+OTSharedInstance.h"
#import <objc/runtime.h>

#define SHARED_INSTANCE_KEY @"kOTSharedInstance"

@implementation NSObject (OTSharedInstance)


+ (instancetype)sharedInstance
{
    Class selfClass = [self class];
    id instance = objc_getAssociatedObject(selfClass, SHARED_INSTANCE_KEY);
    if (!instance)
    {
        instance = [[selfClass alloc] init];
        objc_setAssociatedObject(selfClass, SHARED_INSTANCE_KEY, instance, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        NSLog(@"单例类 %@ 创建", selfClass);
    }
    return instance;
}

/** 内存不够用的话可能需要释放单例 */
+ (void)freeSharedInstance
{
    Class selfClass = [self class];
    id instance = objc_getAssociatedObject(selfClass, SHARED_INSTANCE_KEY);
    if (instance) {        
        objc_setAssociatedObject(selfClass, SHARED_INSTANCE_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        NSLog(@"单例类 %@ 销毁", selfClass);
    }
}

@end
