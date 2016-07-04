//
//  UserInfoModel.h
//  SafeBoxBusinessLogicLayer
//
//  Created by 丁嘉睿 on 16/5/18.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "BaseModel.h"

@interface UserInfoModel : BaseModel

/** 登陆密码 */
@property (nonatomic, copy) NSString *loginPW;

/** 是否指纹解锁 */
@property (nonatomic, assign) BOOL isFingerprint;

- (instancetype)initWithLoginPW:(NSString *)password isNeedFingerprint:(BOOL)isNeed;

@end
