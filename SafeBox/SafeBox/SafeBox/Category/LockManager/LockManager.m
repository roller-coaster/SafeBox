//
//  LockManager.m
//  SafeBox
//
//  Created by 丁嘉睿 on 16/6/30.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "LockManager.h"
#import "AuthenticationViewController.h"
@implementation LockManager

+ (void)showLockViewWithController:(UIViewController *)controller{
    [LockManager loadLockPasswordWithBlock:^(BOOL isSave, NSString *password) {
        if ([password isKindOfClass:[NSString class]]) {
            
        }else{
            
        }
    }];
}

#pragma mark - 取归档文件
+ (void)loadLockPasswordWithBlock:(void(^)(BOOL isSave, NSString *password))block{
    if ([FileUtility ergodicFolder:FILE_NAME_Archiver].count > 0) {
        id obj = [ArchiverUtils UnarchiverObjectWithFilePath:[FILE_NAME_Archiver_PATH stringByAppendingPathComponent:ArchiverName]];
        [UserInfoDAO sharedInstance].infoModel = (UserInfoModel *)obj;
        if (block) block([UserInfoDAO sharedInstance].infoModel.isFingerprint, [UserInfoDAO sharedInstance].infoModel.loginPW);
    }else{
        if (block) block(NO, nil);
    }
}
@end
