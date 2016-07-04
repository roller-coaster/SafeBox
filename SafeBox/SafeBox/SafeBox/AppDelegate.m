//
//  AppDelegate.m
//  SafeBox
//
//  Created by 丁嘉睿 on 16/5/18.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "AppDelegate.h"
#import "ZXBasicVC.h"
#import "FingerprintLockCustomView.h"
#import "LockManager.h"

@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [FileUtility createFileWithName:FILE_NAME_ALL];
    [FileUtility createFileWithName:FILE_NAME_VIDEO];
    [FileUtility createFileWithName:FILE_NAME_PHOTOS];
    [FileUtility createFileWithName:FILE_NAME_Archiver];
    
//    self.fingerView = [[FingerprintLockCustomView alloc] initWithFrame:self.window.frame];
//    [self.window insertSubview:self.fingerView belowSubview:self.window.rootViewController.view];
    return YES;
}

/** applicationWillResignActive:和applicationDidBecomeActive:这两个方法代表着应用程序从活动状态过度到不活动状态，是启用或禁用任何动画、应用程序那的音频或其他处理应用程序表示（向用户）的项目的不错位置。
 */
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topRootViewController.presentedViewController) {
        topRootViewController = topRootViewController.presentedViewController;
    }
    [LockManager showLockViewWithController:topRootViewController];
    NSLog(@"用户按下主屏幕按钮调用 ，不要在此方法中假设将进入后台状态，只是一种临时变化，最终将恢复到活动状态");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"应用程序按下主屏幕按钮后想要将应用程序切换到前台时调用，应用程序启动时也会调用，可以在其中添加一些应用程序初始化代码");
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"应用程序在此方法中释放所有可在以后重新创建的资源，保存所有用户数据，关闭网络连接等。如果需要，也可以在这里请求在后台运行更长时间。如果在这里花费了太长时间（超过5秒），系统将断定应用程序的行为异常并终止他。");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
