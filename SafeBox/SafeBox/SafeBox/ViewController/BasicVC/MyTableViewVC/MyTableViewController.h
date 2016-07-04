//
//  MyTableViewController.h
//  MiracleMessenger
//
//  Created by GZMLUser on 15-4-21.
//  Copyright (c) 2015年 GZMiracle. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ZXBasicVC.h"
#import "MJRefresh.h"
#import "UIScrollView+EmptyDataSet.h"

#define kContactCellHeight 44.0

@interface MyTableViewController : ZXBasicVC <UITableViewDataSource, UITableViewDelegate,  UIGestureRecognizerDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) UITableViewStyle myStyle;

- (id)initWithStyle:(UITableViewStyle)style;

/** 默认1秒后取消选中  */
- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath;
/** 取消选中 */
- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath afterDelay:(NSTimeInterval)seconds;

/** 初始化下拉、上拉刷新功能*/
- (void)initRefreshControlWithTableView:(UITableView *)tableView IsHeadRefresh:(BOOL)isHeadRefresh refreshingBlock:(void(^)(MJRefreshBaseView *refresher))block;

@end