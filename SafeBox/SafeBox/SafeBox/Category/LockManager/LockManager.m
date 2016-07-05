//
//  LockManager.m
//  SafeBox
//
//  Created by 丁嘉睿 on 16/6/30.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "LockManager.h"
#import "AuthenticationViewController.h"
#import "MViewController.h"
@implementation LockManager

#pragma mark - Public Methods
#pragma mark 显示锁屏界面
+ (void)showLockViewWithController:(UIViewController *)controller{
    [LockManager loadLockPasswordWithBlock:^(BOOL isFingerprint, NSString *password) {
        BOOL isYES = NO;
        if ([controller isKindOfClass:[AuthenticationViewController class]]) {
            isYES = YES;
        }
        AuthenticationViewController *authenticationVC = [[AuthenticationViewController alloc] init];
        authenticationVC.dismissBlock = ^(BOOL dismiss){
            if (!dismiss) {
                [LockManager dismissLockViewController:controller];
            }
        };
        if (isFingerprint) {
            
        }else{
            if ([password isKindOfClass:[NSString class]]) {
                if (!isYES) {
                    if ([controller isKindOfClass:[ZXBasicVC class]]) {
                        [(ZXBasicVC *)controller presentVC:authenticationVC animated:NO];
                    }else{
                        [controller presentViewController:authenticationVC animated:NO completion:nil];
                    }
                }
            }else{
                NSLog(@"我才不会再盘出来");
            }
        }
    }];
}

#pragma mark - Private Methods
#pragma mark 取归档文件
+ (void)loadLockPasswordWithBlock:(void(^)(BOOL isFingerprint, NSString *password))block{
    id obj = [ArchiverUtils UnarchiverObjectWithFilePath:[FILE_NAME_Archiver_PATH stringByAppendingPathComponent:ArchiverName]];
    if (obj) {
        UserInfoModel *model = (UserInfoModel *)obj;
        [UserInfoDAO sharedInstance].infoModel = [[UserInfoModel alloc] initWithLoginPW:model.loginPW isNeedFingerprint:model.isFingerprint];
        if (block) block([UserInfoDAO sharedInstance].infoModel.isFingerprint, [UserInfoDAO sharedInstance].infoModel.loginPW);
    }else{
        if (block) block(NO, nil);
    }
}

#pragma mark 移除锁屏界面
+ (void)dismissLockViewController:(UIViewController *)controller{
    if ([controller isKindOfClass:[ZXBasicVC class]]) {
        [(ZXBasicVC *)controller dismissVC:NO completion:nil];
    }else{
        [controller dismissViewControllerAnimated:NO completion:nil];
    }
}
@end
