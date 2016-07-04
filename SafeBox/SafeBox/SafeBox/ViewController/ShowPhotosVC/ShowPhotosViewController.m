//
//  ShowPhotosViewController.m
//  SafeBox
//
//  Created by 丁嘉睿 on 16/6/2.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "ShowPhotosViewController.h"
#import "IMGCollectionViewCell.h"
@interface ShowPhotosViewController ()

@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@end

@implementation ShowPhotosViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDataSource];

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH / 4, SCREEN_WIDTH / 4);
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    /** 注册cell */
    [self.collectionView registerNib:[UINib nibWithNibName:[IMGCollectionViewCell identifier] bundle:nil] forCellWithReuseIdentifier:[IMGCollectionViewCell identifier]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = [IMGCollectionViewCell identifier];
    IMGCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSString *patch = self.dataSourceArray[indexPath.row];
    UIImage *image = [UIImage imageWithContentsOfFile:patch];
    [cell buildCellWithDataSource:image];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREEN_WIDTH - 30) / 4, SCREEN_WIDTH / 4);
}
//定义每个UICollectionView 的纵向间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0f;
}


//定义每个UICollectionView 的横向间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 0, 5);
}
#pragma mark - private
#pragma mark 设置数据源
- (void)setDataSource{
    self.dataSourceArray = [NSMutableArray array];
    NSArray *imgs = [FileUtility ergodicFolder:FILE_NAME_PHOTOS_PATH];
    for (NSString *path in imgs) {
        if ([path hasSuffix:@"JPG"] || [path hasSuffix:@"png"] || [path hasSuffix:@"PNG"]) {
            [self.dataSourceArray addObject:path];
        }
    }
}
@end
