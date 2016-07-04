//
//  ZXBasicVC.m
//  MiracleMessenger
//
//  Created by Jeans Huang on 14-6-16.
//  Copyright (c) 2014年 gzmiracle. All rights reserved.
//

#import "ZXBasicVC.h"
#import "ZXBasicVC+Navi.h"

@interface ZXBasicVC () <NaviProtocol>
{
    /** 记录热点、电话的变化 */
    BOOL isChangedStatusBar;
}

@end

@implementation ZXBasicVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self customInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)customInit
{
    if (IOS7_OR_LATER) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _isSetNavBackBar = YES;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self viewDidLoadNavi];
    _isSetNavBackBar = [self setNavBackBarTitle:_isSetNavBackBar];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeStatusBarFrame:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self viewWillAppearNavi:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self viewDidAppearNavi:animated];
    if (AppStatusBarHeight > 20 && isChangedStatusBar==NO) {
        [self changeViewFrame:20-AppStatusBarHeight];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self viewWillDisappearNavi:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self viewDidDisappearNavi:animated];
}


- (BOOL)isInteractived
{
    if ([self.navigationController isKindOfClass:[ZXNavController class]]) {
        ZXNavController *navi = (ZXNavController *)self.navigationController;
        return navi.isInteractived;
    }
    return NO;
}

- (ZXBasicVC *)presentingVC
{
    return (ZXBasicVC *)[[(ZXNavController *)self.presentingViewController viewControllers] lastObject];
}

#pragma mark - 监听状态栏改变
- (void)changeStatusBarFrame:(NSNotification *)notify
{
    CGRect newStatusBarFrame = [notify.userInfo[UIApplicationStatusBarFrameUserInfoKey] CGRectValue];
    /** 后台通话、热点等情况 */
    BOOL isChangeStatusBar = (CGRectGetHeight(newStatusBarFrame) > 20);
    CGFloat OffsetY = isChangeStatusBar?-20:+20;
    if (IOS7_OR_LATER) { // 即使设置了extendedLayoutIncludesOpaqueBars=NO/edgesForExtendedLayout=UIRectEdgeNone，对没有自动调整的部分View做必要的手动调整
        if (OffsetY < 0) {
            [self changeViewFrame:OffsetY];
        } else {
            if (isChangedStatusBar) {
                [self changeViewFrame:OffsetY];
            }
        }
    } else { // Custom Content对应的view整体调整
//        self.wantsFullScreenLayout = NO;
    }
}

- (void)changeViewFrame:(CGFloat)OffsetY
{
    isChangedStatusBar = YES;
    if (![self isMemberOfClass:[UIApplication sharedApplication].keyWindow.rootViewController.class]){
        
        CGRect newRect = self.view.frame;
        if (OffsetY < 0) {
            newRect.size.height += OffsetY;
            self.view.frame = newRect;
        }
        
        for (id obj in [self.view subviews]) {
            if ([obj isMemberOfClass:[UITableView class]]) {
                UITableView *tableView = obj;
                newRect = tableView.frame;
                newRect.size.height += OffsetY;
                tableView.frame = newRect;
            } else if ([obj isMemberOfClass:[UICollectionView class]]) {
                UICollectionView *collectionView = obj;
                newRect = collectionView.frame;
                newRect.size.height += OffsetY;
                collectionView.frame = newRect;
            }
        }
    }
}


@end
