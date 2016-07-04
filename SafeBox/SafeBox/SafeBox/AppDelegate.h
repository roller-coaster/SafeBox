//
//  AppDelegate.h
//  SafeBox
//
//  Created by 丁嘉睿 on 16/5/18.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FingerprintLockCustomView;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) FingerprintLockCustomView *fingerView;
@end

