//
//  MyCollectionViewController.m
//  SafeBox
//
//  Created by 丁嘉睿 on 16/6/2.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "MyCollectionViewCell.h"

@interface MyCollectionViewController ()

@end

@implementation MyCollectionViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCollectionView];
    [self registerCell];
}

#pragma mark - 初始initCollectionView
- (void)initCollectionView
{
    if (!self.collectionViewLayout) {
        self.collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    }
    self.collectionView = [[UICollectionView alloc] initWithFrame:CURRENT_APP_CONTENT_FRAME collectionViewLayout:self.collectionViewLayout];
    [self.view addSubview:self.collectionView];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

#pragma mark - 注册cell
- (void)registerCell
{
    [self.collectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:[MyCollectionViewCell identifier]];
}


/** 设置TableView为空状态下背景视图*/
- (void)setEmptyDataWithCollentionView:(UICollectionView *)collectionView emptyDataSetSource:(id<DZNEmptyDataSetSource>)dataSource emptyDataSetDelegate:(id<DZNEmptyDataSetDelegate>)delegate
{
    collectionView.emptyDataSetSource = dataSource;
    collectionView.emptyDataSetDelegate = delegate;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [MyCollectionViewCell identifier];
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    return cell;
}

@end
