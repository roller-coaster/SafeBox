//
//  ZXNavController.m
//  MiracleMessenger
//
//  Created by Jeans Huang on 14-6-16.
//  Copyright (c) 2014年 gzmiracle. All rights reserved.
//

#import "ZXNavController.h"

@interface ZXNavController ()

@end

@implementation ZXNavController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.delegate = self;
    
    [self.navigationItem setHidesBackButton:YES];
    [self.view setBackgroundColor:[UIColor colorWithRed:191.0/255.0 green:191.0/255.0 blue:196.0/255.0 alpha:.6f]];
    if (IOS7_OR_LATER)
        [self setDefaultNavBarStyle];
    else {
//        [self.navigationBar setBackgroundImage:imageName(@"topNavBar_bg") forBarMetrics:UIBarMetricsDefault];
    }

}

- (void)dealloc
{
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)interactivePopToVC:(UIGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            _isInteractived = YES;
            break;
        case UIGestureRecognizerStateChanged:
            if (_isInteractived == NO) {
                _isInteractived = YES;
            }
            break;
        case UIGestureRecognizerStateEnded:
        {
            _isInteractived = NO;
        }
            break;
        case UIGestureRecognizerStateCancelled:
            _isInteractived = NO;
            break;
        case UIGestureRecognizerStateFailed:
            _isInteractived = NO;
            break;
        default:
            break;
    }
}

#pragma mark - 重写推送界面
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //在切换界面的过程中禁止滑动手势，避免界面卡死
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark - UINavigationController Delegate Methods
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //开启iOS7的滑动返回效果
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //只有在二级页面生效
        if ([self.viewControllers count] == 2 && self.interactivePopGestureRecognizer.delegate == nil) {
            self.interactivePopGestureRecognizer.delegate = self;
            [self.interactivePopGestureRecognizer addTarget:self action:@selector(interactivePopToVC:)];
        } else if ([self.viewControllers count] == 1 && self.interactivePopGestureRecognizer.delegate) {
            self.interactivePopGestureRecognizer.delegate = nil;
            [self.interactivePopGestureRecognizer removeTarget:self action:@selector(interactivePopToVC:)];
        }
        BOOL isOn = YES;
        if ([viewController isKindOfClass:[ZXBasicVC class]]) {
            ZXBasicVC *basicVC = (ZXBasicVC *)viewController;
            //判断是否存在返回按钮
            isOn = basicVC.isSetNavBackBar;
        }
        //开启滑动手势
        self.interactivePopGestureRecognizer.enabled = isOn;
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if([viewController isKindOfClass:[ZXBasicVC class]])
    {
        /** 处理推送VC传参 */
        ZXBasicVC *targetVC = (ZXBasicVC *)viewController;
        if (targetVC.completionBlock) {
            targetVC.completionBlock(viewController);
            targetVC.completionBlock = nil;
        }
    }
}

#pragma mark - private fucation
- (void)setDefaultNavBarStyle {
    
//    [self.navigationBar setBarTintColor:[ThemeManager themeColorFromType:themeColorType_NavigationBarTintColor]];
//    //[self.navigationBar setTranslucent:NO];
//    
//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [ThemeManager themeColorFromType:themeColorType_NavigationBarTextColor], NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0]}];
//    
//    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:@{NSForegroundColorAttributeName: [ThemeManager themeColorFromType:themeColorType_NavigationBarButtonTextColor]} forState:UIControlStateNormal];
    
}

#pragma mark - gesturedelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.viewControllers.count == 1) {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return  YES;
}

@end
