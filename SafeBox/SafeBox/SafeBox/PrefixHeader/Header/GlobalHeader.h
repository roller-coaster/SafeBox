//
//  GlobalHeader.h
//  SafeBox
//
//  Created by 丁嘉睿 on 16/5/18.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#ifndef GlobalHeader_h
#define GlobalHeader_h
//! 系统版本
#define NLSystemVersionGreaterOrEqualThan(version) ([[[UIDevice currentDevice] systemVersion] floatValue] >= version)
#define IOS7_OR_LATER NLSystemVersionGreaterOrEqualThan(7.0)
#define IOS8_OR_LATER NLSystemVersionGreaterOrEqualThan(8.0)

//iPhoneModel
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6p ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6p_AmplifyMode ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define isDeviceiPhone UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone

// UI
#define APP_CELL_DEFAULT_FONT  [UIFont boldSystemFontOfSize:18.0f]

/** 主界面底部toolbar高度*/
#define kMainTabBarViewHeight ((SCREEN_HEIGHT*0.08) < 49.0 ? 49.0 : (SCREEN_HEIGHT*0.08))

/** 导航栏＋状态栏高度 20这个值不能使用AppStatusBarHeight替换因为热点和电话中 */
#define NaviBarAndStatusBarHeight  (44 + 20)
/** 状态栏高度 不能在设置界面的frame时使用 */
#define AppStatusBarHeight CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define MAINSTORYBOARD_IPHONE @"Main"
//! 当前设备frame
#define CURRENT_APP_FRAME               [UIScreen mainScreen].bounds
//! 当前屏幕内容frame，导航栏以下
#define CURRENT_APP_CONTENT_FRAME   CGRectMake(0, NaviBarAndStatusBarHeight, CURRENT_APP_FRAME.size.width,CURRENT_APP_FRAME.size.height - NaviBarAndStatusBarHeight)

#define kCheckStringIsNull(obj) [obj isKindOfClass:[NSString class]] ? ( obj.length > 0 ? obj : nil ) : nil
#define kCheckStringIsEmpty(obj) [obj isKindOfClass:[NSString class]] ? ( obj.length > 0 ? obj : @"" ) : @""
/** 布尔值字符串转换*/
#define kBoolValueString(value) value == YES ? @"true" : @"false"

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#endif /* GlobalHeader_h */
