//
//  AppInformation.h
//  MiracleMessenger
//
//  Created by LamTsanFeng on 15/4/27.
//  Copyright (c) 2015年 GZMiracle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface AppInformation : NSObject

/** app build版本 */
+ (NSString *)appBuildVersion;
/** app版本 */
+ (NSString *)appVersion;
/** app名字 */
+ (NSString *)appName;
/** Bunlde ID */
+ (NSString *)appBundleIdentifier;

/** App是否发布到苹果Appstore版本 */
+ (BOOL)appReleaseToAppStore;
/** AppStore应用地址*/
+ (NSString *)appStoreAppURL;
/** AppStore应用版本查询请求地址*/
+ (NSString *)appStoreAppVersionURL;

/** app tokenId */
+ (NSString *)appTokenId;
/** 写入app tokenId */
+ (void)setAppTokenId:(NSString *)tokenId;
/** 是否ipad */
+ (BOOL)isIpad;

/** 设备别名 */
+ (NSString *)deviceName;
/** 设备名称 */
+ (NSString *)devicefulName;
/** 是否模拟器 */
+ (BOOL)isSimulator;
/** 操作系统*/
+ (NSString *)os;
/** 型号 */
+ (NSString *)model;
/** 地方型号  （国际化区域名称） */
+ (NSString *)local;


/** app UUID */
+ (NSString *)appUUID;
/** 设备分辨率 */
+ (CGSize)appPixel;

/** 耳机模式 */
+ (void)earphoneMode;
/** 扬声器模式 */
+ (void)speakerMode;
@end
