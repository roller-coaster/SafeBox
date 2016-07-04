//
//  ValidationFingerprint.h
//  MEMobile
//
//  Created by 丁嘉睿 on 16/5/27.
//  Copyright © 2016年 GZMiracle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>

@interface ValidationFingerprint : NSObject

/**
 *  @author djr
 *  
 *  验证设备是否支持指纹解锁（必须先验证设备是否支持指纹解锁，才能使用指纹解锁功能）
 *  @param block block(error的错误消息参考指纹)
 */
+ (void)validationTheDeviceIsSupportTheFingerprintBlock:(void(^)(BOOL isSupport,NSError *error))block;

/**
 *  @author djr
 *  
 *  指纹解锁
 *  @param prompt 提示
 *  @param leftButtonTitle 左边按钮文字（为nil的时候，只显示取消按钮）
 *  @param result result
 */
+ (void)settingFingerprintWithPrompt:(NSString *)prompt leftButtonTitle:(NSString *)leftButtonTitle reslutBlock:(void(^)(BOOL success, NSError *error))result;


@end
