//
//  ThreadDAO.m
//  SafeBoxBusinessLogicLayer
//
//  Created by 丁嘉睿 on 16/7/8.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "ThreadDAO.h"

@interface ThreadDAO ()
@property (strong, nonatomic) dispatch_queue_t globalQueue;
@property (strong, nonatomic) dispatch_queue_t mainQueue;
@end

@implementation ThreadDAO

+ (void)initialize {
    if (self == [ThreadDAO self])  {
        ThreadDAO *thread = [self sharedInstance];
        thread.mainQueue    = dispatch_get_main_queue();
        thread.globalQueue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
}

#pragma mark - /** 创建子线程 */
+ (void)executeInGlobalQueue:(dispatch_block_t)block
{
    NSParameterAssert(block);
    
    dispatch_async([ThreadDAO sharedInstance].globalQueue, block);
}
+ (void)executeInGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec
{
    
    NSParameterAssert(block);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * sec), [ThreadDAO sharedInstance].globalQueue, block);
}

#pragma mark /** 创建GCD自定义子线程 */
+ (void)executeInCustomGlobalQueue:(dispatch_queue_t)globalQueue block:(dispatch_block_t)block
{
    NSParameterAssert(block);
    dispatch_async(globalQueue, block);
}

#pragma mark /** 创建GCD同步自定义子线程 */
+ (void)executeInSyncCustomGlobalQueue:(dispatch_queue_t)globalQueue block:(dispatch_block_t)block
{
    NSParameterAssert(block);
    dispatch_sync(globalQueue, block);
}

+ (void)executeInCustomGlobalQueue:(dispatch_queue_t)globalQueue block:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec
{
    NSParameterAssert(block);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * sec), globalQueue, block);
}

#pragma mark - /** 创建主线程 */
+ (void)executeInMainQueue:(dispatch_block_t)block
{
    NSParameterAssert(block);
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async([ThreadDAO sharedInstance].mainQueue, block);
    }
}

+ (void)executeInSyncMainQueue:(dispatch_block_t)block
{
    NSParameterAssert(block);
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync([ThreadDAO sharedInstance].mainQueue, block);
    }
}

+ (void)executeInMainQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec
{
    
    NSParameterAssert(block);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * sec), [ThreadDAO sharedInstance].mainQueue, block);
}

#pragma mark - /** 创建线程 */
+ (void)executeInGlobalQueue:(dispatch_block_t)gBlock mainQueue:(dispatch_block_t)mBlock
{
    [self executeInGlobalQueue:^{
        gBlock();
        [self executeInMainQueue:mBlock];
    }];
    
}

+ (void)executeInCustomGlobalQueue:(dispatch_queue_t)globalQueue globalBlock:(dispatch_block_t)gBlock mainQueue:(dispatch_block_t)mBlock
{
    [self executeInCustomGlobalQueue:globalQueue block:^{
        gBlock();
        [self executeInMainQueue:mBlock];
    }];
}

#pragma mark - 挂起线程
+ (void)suspend:(dispatch_queue_t)queue
{
    dispatch_suspend(queue);
}

#pragma mark - 恢复线程
+ (void)resume:(dispatch_queue_t)queue
{
    dispatch_resume(queue);
}


@end
