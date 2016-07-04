//
//  UserInfoDAO.h
//  SafeBoxBusinessLogicLayer
//
//  Created by 丁嘉睿 on 16/6/30.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+OTSharedInstance.h"

@class UserInfoModel;

@interface UserInfoDAO : NSObject <OTSharedInstance>

@property (nonatomic, strong) UserInfoModel *infoModel;

@end
