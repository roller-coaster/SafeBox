//
//  UserPasswordModel.m
//  SafeBoxBusinessLogicLayer
//
//  Created by 丁嘉睿 on 16/7/29.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "UserPasswordModel.h"

@implementation UserPasswordModel



#pragma mark - Public Methods
#pragma mark 指纹解锁
+ (void)showFingerprintWithPrompt:(NSString *)prompt isValidationSupport:(BOOL)isSupport leftBtnTitle:(NSString *)leftBtnTitle resultBlock:(void (^)(BOOL, NSString *))result{
    if (![prompt isKindOfClass:[NSString class]]) return;
    if (![leftBtnTitle isKindOfClass:[NSString class]]) {
        leftBtnTitle = @"";
    }
    LAContext *context = [[LAContext alloc] init];
    context.localizedFallbackTitle = leftBtnTitle;
    NSError *aError = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&aError]) {
        if (isSupport) {/** 验证是否支持指纹解锁 */
            if (result) result(YES, nil);
            return;
        }
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:prompt reply:^(BOOL success, NSError * _Nullable error) {
            if (success && error == nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (result) result(YES, nil);
                }) ;
            }else{
                NSString *errStr = nil;
                switch (error.code) {
                    case LAErrorAppCancel:
                    case LAErrorSystemCancel:
                    {
                        /** LAErrorAppCancel和LAErrorSystemCancel相似，都是当前软件被挂起取消了授权，但是前者是用户不能控制的挂起，例如突然来了电话，电话应用进入前台，APP被挂起。后者是用户自己切到了别的应用，例如按home键挂起。
                         */
                        //                        errStr = @"切换到其他APP，系统取消验证Touch ID";
                        errStr = Authentication_Failed;
                    }
                        break;
                    case LAErrorUserCancel:
                    {
                        errStr = Cancle_TEXT;
                    }
                        break;
                    case LAErrorUserFallback:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //用户选择输入密码，切换主线程处理
                        }];
                        //                        errStr = @"用户选择输入密码，切换主线程处理";
                        errStr = Authentication_Failed;
                    }
                        break;
                    case LAErrorTouchIDLockout:
                    {
                        //                        errStr = @"用户多次连续使用Touch ID失败，Touch ID被锁，需要用户输入密码解锁!";
                        errStr = Authentication_Failed;
                    }
                        break;
                    case LAErrorInvalidContext:
                    {
                        //                       errStr = @"授权过程中,LAContext对象被释放掉了，造成的授权失败。"; 
                        errStr = Authentication_Failed;
                    }
                        break;
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程处理 
                        }];
                        //                        errStr = @"其他情况，切换主线程处理";
                        errStr = Authentication_Failed;
                        break;
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (result) result(NO,errStr);
                });
            }
        }];
    }else{
        NSString *errStr = nil;
        //不支持指纹识别，LOG出错误详情
        switch (aError.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                errStr = @"TouchID is not enrolled";
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                errStr = @"A passcode has not been set";
                break;
            }
            default:
            {
                errStr = @"TouchID not available";
                break;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result) result(NO,errStr);
        });
    }
}

/**  如果在applicationDidBecomeActive中调用evaluatePolicy:localizedReason:reply弹出Touch ID验证alert的话, 如果用户解锁成功或者点击了Cancel, 那么就进入了死循环: cancel掉Touch ID的alert会触发applicationDidBecomeActive, 程序在applicationDidBecomeActive中弹出Touch ID, 用户点击Cancel...... 
 所以考虑把Touch ID验证放在applicationWillEnterForeground中. 但问题来了, app第一次打开没有触发调用TouchID 方法的，或者如果另外一个app使用openURL方式跳到本app, 本app做一下处理后再跳回到跳到本程序的那个app. 这个场景下, 是不能弹出Touch ID的, 但是上面提到Touch ID是在applicationWillEnterForeground中调用的, 那时还尚未调用application:openURL:sourceApplication:annotation:, 程序不知道自己是正常启动还是被其他app使用openURL打开的, 怎么办?
 解决方法有两个:（本Demo 采用第二种方法）
 首先, 在application:openURL:sourceApplication:annotation:中设置标志位是必须的.
 1. 如果本app做的处理不耗时的话, 例如只是保存个图片什么的, 耗时一般不会超过1秒, 可以考虑在applicationWillEnterForeground中等待一小段时间后判断是不是openURL启动的, 再弹出Touch ID.
 2. 把Touch ID放到applicationDidBecomeActive, 设置标志位, 比如起名_ignoreNextApplicationDidBecomeActive. 在reply回调中, 判断用户是否点击了Cancel, 如果是的话, 将该标志位赋为YES. 下次进入applicationDidBecomeActive判断该标志位如果为YES, 将该标志位设为NO; 如果为NO, 则弹出Touch ID. */

- (void)clean{
    _isFingerprint = NO;
}

@end
