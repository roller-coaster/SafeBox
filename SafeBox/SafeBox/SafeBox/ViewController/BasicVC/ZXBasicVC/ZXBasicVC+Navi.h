//
//  ZXBasicVC+Navi.h
//  MEMobile
//
//  Created by LamTsanFeng on 16/2/22.
//  Copyright © 2016年 GZMiracle. All rights reserved.
//

#import "ZXBasicVC.h"

@interface ZXBasicVC (Navi)

// ------------------- 页面推送 -------------
/** 新推送方式 */
- (void)presentVC:(UIViewController *)viewController animated:(BOOL)animated;
- (void)presentVC:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;

/** 销毁 */
- (void)dismissVC:(BOOL)flag;
- (void)dismissVC:(BOOL)flag completion:(void (^)(void))completion;

/** 返回当前navi最顶 */
- (void)popToRootVC:(BOOL)animated;

/** 推送界面＋参数 */
- (void)pushVC:(ZXBasicVC *)VC completion:(vcCompletionBlock)completionBLock;
/** 推送界面 */
- (void)pushVC:(ZXBasicVC *)VC;
- (void)pushVC:(ZXBasicVC *)VC animated:(BOOL)animated;
/** 推送多个界面（动画以最后一个VC显示） */
- (void)pushMultipleVC:(NSArray *)VCs;
- (void)pushMultipleVC:(NSArray *)VCs animated:(BOOL)animated;

/** 返回到某个界面＋参数 */
- (void)popToVCWithClassName:(Class)className completion:(vcCompletionBlock)completionBLock animated:(BOOL)animated;
/** 返回到某个界面 */
- (void)popToVCWithClassName:(Class)className animated:(BOOL)animated;
/** 返回上一个界面＋参数 */
- (void)popToVCWithCompletion:(vcCompletionBlock)completionBLock animated:(BOOL)animated;
/** 返回上一个界面 */
- (void)popToVC:(BOOL)animated;


@end

@protocol NaviProtocol <NSObject>

@optional
- (void)viewDidLoadNavi;
- (void)viewWillAppearNavi:(BOOL)animated;
- (void)viewDidAppearNavi:(BOOL)animated;
- (void)viewWillDisappearNavi:(BOOL)animated;
- (void)viewDidDisappearNavi:(BOOL)animated;

- (BOOL)setNavBackBarTitle:(BOOL)isSetNavBackBar;
@end
