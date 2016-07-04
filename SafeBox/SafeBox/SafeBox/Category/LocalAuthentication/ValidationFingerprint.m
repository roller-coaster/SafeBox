//
//  ValidationFingerprint.m
//  MEMobile
//
//  Created by 丁嘉睿 on 16/5/27.
//  Copyright © 2016年 GZMiracle. All rights reserved.
//

#import "ValidationFingerprint.h"

@interface ValidationFingerprint ()


@end

@implementation ValidationFingerprint

#pragma mark - 验证设备是否支持指纹解锁（必须先验证设备是否支持指纹解锁，才能使用指纹解锁功能）
+ (void)validationTheDeviceIsSupportTheFingerprintBlock:(void (^)(BOOL, NSError *))block{
    LAContext *context = [[LAContext alloc] init];
    NSError *aError = nil;
    BOOL support = NO;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&aError]) {
        support = YES;
    }
    if (block) {
        block(support,aError);
    }
}

+ (void)settingFingerprintWithPrompt:(NSString *)prompt leftButtonTitle:(NSString *)leftButtonTitle reslutBlock:(void (^)(BOOL, NSError *))result{
    if (prompt.length == 0) {
        if (result) {
            result(NO,nil);
        }
        return;
    }
    LAContext *context = [[LAContext alloc] init];
    if (leftButtonTitle.length == 0) {
        leftButtonTitle = @"";
    }
    context.localizedFallbackTitle = leftButtonTitle;
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:prompt reply:^(BOOL success, NSError * _Nullable error) {
        if (result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                result(success, error);
            });
        }
    }];
}



/**  如果在applicationDidBecomeActive中调用evaluatePolicy:localizedReason:reply弹出Touch ID验证alert的话, 如果用户解锁成功或者点击了Cancel, 那么就进入了死循环: cancel掉Touch ID的alert会触发applicationDidBecomeActive, 程序在applicationDidBecomeActive中弹出Touch ID, 用户点击Cancel...... 
 所以考虑把Touch ID验证放在applicationWillEnterForeground中. 但问题来了, app第一次打开没有触发调用TouchID 方法的，或者如果另外一个app使用openURL方式跳到本app, 本app做一下处理后再跳回到跳到本程序的那个app. 这个场景下, 是不能弹出Touch ID的, 但是上面提到Touch ID是在applicationWillEnterForeground中调用的, 那时还尚未调用application:openURL:sourceApplication:annotation:, 程序不知道自己是正常启动还是被其他app使用openURL打开的, 怎么办?
 解决方法有两个:（本Demo 采用第二种方法）
 首先, 在application:openURL:sourceApplication:annotation:中设置标志位是必须的.
 1. 如果本app做的处理不耗时的话, 例如只是保存个图片什么的, 耗时一般不会超过1秒, 可以考虑在applicationWillEnterForeground中等待一小段时间后判断是不是openURL启动的, 再弹出Touch ID.
 2. 把Touch ID放到applicationDidBecomeActive, 设置标志位, 比如起名_ignoreNextApplicationDidBecomeActive. 在reply回调中, 判断用户是否点击了Cancel, 如果是的话, 将该标志位赋为YES. 下次进入applicationDidBecomeActive判断该标志位如果为YES, 将该标志位设为NO; 如果为NO, 则弹出Touch ID. */
@end
