//
//  ShowManagerViewController.m
//  SafeBox
//
//  Created by 丁嘉睿 on 16/7/8.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "ShowManagerViewController.h"
#import "ShowManagerCollectionViewCell.h"

#define PROMPT_TEXT @"无照片或视频"

@interface ShowManagerViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ShowManagerViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self registerCell];
    
    [self setEmptyDataWithCollentionView:self.collectionView emptyDataSetSource:self emptyDataSetDelegate:self];
}


#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ShowManagerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ShowManagerCollectionViewCell identifier] forIndexPath:indexPath];
    [cell setItem:_dataArray[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = (SCREEN_WIDTH - 30) / 3;
    FileItem *item = _dataArray[indexPath.row];
    CGSize size = CGSizeMake(100.0f, 100.0f);
    if (item.fileType == FileType_photo) {
        FileImageItem *imageItem = (FileImageItem *)item;
        if (imageItem.imageWidth < width) {
            size = [UIImage scaleImageSizeBySize:CGSizeMake(imageItem.imageWidth, imageItem.imageHeight) targetSize:CGSizeMake(width, imageItem.imageHeight) isBoth:YES];
        }else{
            size = [UIImage imageSizeBySize:CGSizeMake(imageItem.imageWidth, imageItem.imageHeight) maxWidth:width];
        }
    }else if (item.fileType == FileType_photo){

    }
    return size;
}
//定义每个UICollectionView 的纵向间距
//-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    return 0.0f;
//}


//定义每个UICollectionView 的横向间距
//-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//    return 5.0f;
//}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 0, 5);
}

#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSMutableAttributedString *attributedString = nil;
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    paragraph.paragraphSpacingBefore = -3.f;
    font = [UIFont boldSystemFontOfSize:15.0];
    textColor = [UIColor colorFromHexString:@"545454"];
    
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    if (paragraph) [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];
    
    text = PROMPT_TEXT;
    
    //    if (text) {
    attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    //    }
    return attributedString;
}

#pragma mark - Private Methods
#pragma mark 注册cell
- (void)registerCell{
    [self.collectionView registerNib:[UINib nibWithNibName:[ShowManagerCollectionViewCell identifier] bundle:nil] forCellWithReuseIdentifier:[ShowManagerCollectionViewCell identifier]];
}

#pragma mark - Public Methods
- (void)setShowManagerCollectionViewControllerWithFilePath:(NSString *)path{
    _dataArray = [NSMutableArray array];
    WeakSelf
    if (path.length == 0) return;
    self.title = @"文件预览";
    [ThreadDAO executeInGlobalQueue:^{
        if (!weakSelf) return ;
        NSArray *files = [FileUtility ergodicFolder:path];
        for (NSString *path in files) {
            if ([FileItem analyseFileType:path] == FileType_photo) {
                weakSelf.title = @"图片预览";
                FileImageItem *imageItem = [[FileImageItem alloc] initWithFilePath:path];
                [weakSelf.dataArray addObject:imageItem];
            }else if ([FileItem analyseFileType:path] == FileType_video){
                weakSelf.title = @"视频预览";
                FileItem *item = [[FileItem alloc] initWithFilePath:path];
                [weakSelf.dataArray addObject:item];
            }
        }
        [ThreadDAO executeInMainQueue:^{
            [weakSelf.collectionView reloadData];
        }];
    }];
}
@end
