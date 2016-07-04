//
//  UserInfoModel.m
//  SafeBoxBusinessLogicLayer
//
//  Created by 丁嘉睿 on 16/5/18.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

- (instancetype)initWithLoginPW:(NSString *)password isNeedFingerprint:(BOOL)isNeed{
    self = [super init];
    if (self) {
        _loginPW = password;
        _isFingerprint = isNeed;
    }return self;
}
@end
