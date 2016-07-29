//
//  UserPasswordModel.h
//  SafeBoxBusinessLogicLayer
//
//  Created by 丁嘉睿 on 16/7/29.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "BaseModel.h"
#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>


#define Cancle_TEXT  @"用户取消验证Touch ID"
#define Authentication_Failed @"验证失败"

@interface UserPasswordModel : BaseModel

/** 指纹解锁 */
@property (assign, nonatomic) BOOL isFingerprint;



/**
 *  @author djr
 *  
 *  指纹解锁
 *  @param prompt 提示
 *  @param isSupport YES不会弹出指纹解锁框，只会验证设置是否支持指纹解锁
 *  @param leftBtnTitle 左边按钮文字（为nil的时候，只显示取消按钮）
 *  @param result result
 */
+ (void)showFingerprintWithPrompt:(NSString *)prompt isValidationSupport:(BOOL)isSupport leftBtnTitle:(NSString *)leftBtnTitle resultBlock:(void(^)(BOOL success, NSString *errorStr))result;

/**
 *  @author djr
 *  
 *  关闭手势和指纹
 *  @param pw 是否需要清除手势密码
 */
- (void)clean;


@end
