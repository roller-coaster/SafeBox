//
//  MyCollectionViewController.h
//  SafeBox
//
//  Created by 丁嘉睿 on 16/6/2.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "ZXBasicVC.h"

@interface MyCollectionViewController : ZXBasicVC<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>


@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewLayout *collectionViewLayout;

/** 设置TableView为空状态下背景视图*/
- (void)setEmptyDataWithCollentionView:(UICollectionView *)collectionView emptyDataSetSource:(id<DZNEmptyDataSetSource>)dataSource emptyDataSetDelegate:(id<DZNEmptyDataSetDelegate>)delegate;


@end
