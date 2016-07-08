//
//  ZXBasicVC.h
//  MiracleMessenger
//
//  Created by Jeans Huang on 14-6-16.
//  Copyright (c) 2014年 gzmiracle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXNavController.h"

#define WeakSelf __weak typeof(self) weakSelf = self;


/** 传递vc block */
typedef void(^vcCompletionBlock)(UIViewController *targetVC);

@interface ZXBasicVC : UIViewController

/** 当前VC的present推送者 没有present则返回nil */
@property (nonatomic, readonly) ZXBasicVC *presentingVC;

/** 传参block */
@property(copy, nonatomic)  vcCompletionBlock completionBlock;
/** 是否设置导航栏的返回按钮 默认yes */
@property (nonatomic, assign) BOOL isSetNavBackBar;

/** 是否正在执行滑动手势 */
@property (nonatomic, readonly) BOOL isInteractived;
@end
