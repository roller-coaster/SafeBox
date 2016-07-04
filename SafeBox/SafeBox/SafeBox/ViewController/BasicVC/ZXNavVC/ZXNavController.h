//
//  ZXNavController.h
//  MiracleMessenger
//
//  Created by Jeans Huang on 14-6-16.
//  Copyright (c) 2014年 gzmiracle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXNavController : UINavigationController<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

/** 是否正在执行滑动手势 */
@property (nonatomic, assign) BOOL isInteractived;

@end
