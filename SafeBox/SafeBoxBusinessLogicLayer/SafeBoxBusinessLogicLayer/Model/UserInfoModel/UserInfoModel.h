//
//  UserInfoModel.h
//  SafeBoxBusinessLogicLayer
//
//  Created by 丁嘉睿 on 16/5/18.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "BaseModel.h"
#import "UserPasswordModel.h"

@interface UserInfoModel : BaseModel

/** 登陆密码 */
@property (nonatomic, copy) NSString *loginPW;

@property (strong ,nonatomic) UserPasswordModel *pwModel;

@end

