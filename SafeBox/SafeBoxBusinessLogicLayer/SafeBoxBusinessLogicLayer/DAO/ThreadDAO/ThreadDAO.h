//
//  ThreadDAO.h
//  SafeBoxBusinessLogicLayer
//
//  Created by 丁嘉睿 on 16/7/8.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+OTSharedInstance.h"

@interface ThreadDAO : NSObject<OTSharedInstance>


@property (strong, readonly, nonatomic) dispatch_queue_t globalQueue;
@property (strong, readonly, nonatomic) dispatch_queue_t mainQueue;

/** 创建GCD子线程 */
+ (void)executeInGlobalQueue:(dispatch_block_t)block;
+ (void)executeInGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;
/** 创建GCD自定义子线程 */
+ (void)executeInCustomGlobalQueue:(dispatch_queue_t)globalQueue block:(dispatch_block_t)block;
/** 创建GCD同步自定义子线程 */
+ (void)executeInSyncCustomGlobalQueue:(dispatch_queue_t)globalQueue block:(dispatch_block_t)block;
+ (void)executeInCustomGlobalQueue:(dispatch_queue_t)globalQueue block:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;
/** 创建GCD主线程 */
+ (void)executeInMainQueue:(dispatch_block_t)block;
+ (void)executeInMainQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;
/** 创建GCD同步主线程（注意：在主线程调用会引起死锁） */
+ (void)executeInSyncMainQueue:(dispatch_block_t)block;

/** 创建线程 */
+ (void)executeInGlobalQueue:(dispatch_block_t)gBlock mainQueue:(dispatch_block_t)mBlock;
+ (void)executeInCustomGlobalQueue:(dispatch_queue_t)globalQueue globalBlock:(dispatch_block_t)gBlock mainQueue:(dispatch_block_t)mBlock;

/** 挂起线程 */
+ (void)suspend:(dispatch_queue_t)queue;

/** 恢复线程(挂起线程后，必须在销毁之前恢复线程) */
+ (void)resume:(dispatch_queue_t)queue;


@end
