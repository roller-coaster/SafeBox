//
//  AppInformation.m
//  MiracleMessenger
//
//  Created by LamTsanFeng on 15/4/27.
//  Copyright (c) 2015年 GZMiracle. All rights reserved.
//

#import "AppInformation.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioSession.h>
#import <UIKit/UIKit.h>
#import <sys/sysctl.h>

#define kAPPSTORE_APPID @"1021141442"
#define kAPPSTORE_APPURL [NSString stringWithFormat:@"https://itunes.apple.com/us/app/mu-biao-yi/id%@?l=zh&ls=1&mt=8", kAPPSTORE_APPID]
#define kAPPSTORE_APPVERSION_URL [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", kAPPSTORE_APPID]

/** AppUUID标识Key NSUserDefault获取使用 */
#define kAPPUUID  @"appUUID"

@implementation AppInformation

/** app build版本 */
+ (NSString *)appBuildVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:(id)kCFBundleVersionKey];
}
// app版本
+ (NSString *)appVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}
/** app名字 */
+ (NSString *)appName
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:(id)kCFBundleNameKey];
}
/** Bunlde ID */
+ (NSString *)appBundleIdentifier {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:(id)kCFBundleIdentifierKey];
}
/** App是否发布到苹果Appstore版本 */
+ (BOOL)appReleaseToAppStore {
    return ([[AppInformation appBundleIdentifier] isEqualToString:@"com.gzmiracle.MEMobile"]);
}
/** AppStore应用地址*/
+ (NSString *)appStoreAppURL {
    return kAPPSTORE_APPURL;
}
/** AppStore应用版本查询请求地址*/
+ (NSString *)appStoreAppVersionURL {
    return kAPPSTORE_APPVERSION_URL;
}
/** app tokenId */
+ (NSString *)appTokenId
{   [NSUserDefaults standardUserDefaults];
    NSString *tokenId = [[NSUserDefaults standardUserDefaults] objectForKey:@"tokenCode"];
    return tokenId == nil ? @"" : tokenId;
}
/** 写入app tokenId */
+ (void)setAppTokenId:(NSString *)tokenId
{
    tokenId = tokenId == nil ? @"" : tokenId;
    [[NSUserDefaults standardUserDefaults] setObject:tokenId forKey:@"tokenCode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/** 是否ipad */
+ (BOOL)isIpad
{
    return (([[UIDevice currentDevice] userInterfaceIdiom]) == UIUserInterfaceIdiomPad);
}

/** 设备别名 */
+ (NSString *)deviceName
{
    return [UIDevice currentDevice].name;
}
/** 设备名称 */
+ (NSString *)devicefulName
{
    NSString *platform = [self platform];
    
    //iPhone
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 1";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4s";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5C";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5C";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 Plus";
    
    //iPot Touch
    if ([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch";
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2";
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3";
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4";
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5";
    
    //iPad
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini 1";
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini 1";
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini 1";
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPad air";
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPad air";
    if ([platform isEqualToString:@"iPad4,3"]) return @"iPad air";
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPad mini 2";
    if ([platform isEqualToString:@"iPad4,5"]) return @"iPad mini 2";
    if ([platform isEqualToString:@"iPad4,6"]) return @"iPad mini 2";
    if ([platform isEqualToString:@"iPad4,7"]) return @"iPad mini 3";
    if ([platform isEqualToString:@"iPad4,8"]) return @"iPad mini 3";
    if ([platform isEqualToString:@"iPad4,9"]) return @"iPad mini 3";
    if ([platform isEqualToString:@"iPad5,3"]) return @"iPad air 2";
    if ([platform isEqualToString:@"iPad5,4"]) return @"iPad air 2";
    if ([platform isEqualToString:@"i386"])    return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])  return @"Simulator";
    if ([platform isEqualToString:@"iPhone Simulator"])  return @"Simulator";
    return platform;
}
/** 是否模拟器 */
+ (BOOL)isSimulator
{
    if ([[self devicefulName] isEqualToString:@"Simulator"]) {
        return YES;
    }
    return NO;
}
/** 操作系统*/
+ (NSString *)os
{
    return [UIDevice currentDevice].systemVersion;
}
/** 型号 */
+ (NSString *)model
{
    return [[UIDevice currentDevice] model];
}
/** 地方型号  （国际化区域名称） */
+ (NSString *)local
{
    return [[UIDevice currentDevice] localizedModel];
}

+(NSString*)platform{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    //NSString *platform = [NSString stringWithCString:machine];
    NSString* platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

/** app UUID */
+ (NSString *)appUUID
{   
    NSString *appUUID = [[NSUserDefaults standardUserDefaults] objectForKey:kAPPUUID];
    if (appUUID == nil) {
        appUUID = [AppInformation createUUID];
        [[NSUserDefaults standardUserDefaults] setObject:appUUID forKey:kAPPUUID];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return appUUID;
}

+ (NSString *)createUUID {
    // Create universally unique identifier (object)
    CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
    
    // Get the string representation of CFUUID object.
    //NSString *uuidStr = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuidObject));
    
    NSString *uuidStr = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuidObject);
    
    // If needed, here is how to get a representation in bytes, returned as a structure
    // typedef struct {
    //   UInt8 byte0;
    //   UInt8 byte1;
    //   …
    //   UInt8 byte15;
    // } CFUUIDBytes;
    // CFUUIDBytes bytes = CFUUIDGetUUIDBytes(uuidObject);
    
    CFRelease(uuidObject);
    
    return [uuidStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
}



/** 设备分辨率 */
+ (CGSize)appPixel
{
    CGRect rect_screen = [[UIScreen mainScreen]bounds];
    CGSize size_screen = rect_screen.size;
    
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    
    CGFloat width = size_screen.width*scale_screen;
    CGFloat height = size_screen.height*scale_screen;
    
    return CGSizeMake(width, height);
}

/** 耳机模式 */
+ (void)earphoneMode
{
    //耳机模式
//    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_None;
//    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}
/** 扬声器模式 */
+ (void)speakerMode
{
    //扬声器模式
//    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
//    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}



@end
