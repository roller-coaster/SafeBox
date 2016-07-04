//
//  CustomVideoShowView.m
//  SafeBox
//
//  Created by 丁嘉睿 on 16/6/12.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "CustomVideoShowView.h"
#import "IMGCollectionViewCell.h"

typedef NS_ENUM(NSInteger, CellState) {
    //右上角编辑按钮的两种状态；
    //正常的状态，按钮显示“编辑”;
    NormalState,
    //正在删除时候的状态，按钮显示“完成”；
    DeleteState,
};

@interface CustomVideoShowView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/** collectionView */
@property (nonatomic, strong) UICollectionView *collectionView;

/** 编辑状态 */
@property(nonatomic,assign) CellState cellState;

/** 取消按钮 */
@property (nonatomic, strong) UIButton *cancelBtn;
/** 编辑按钮 */
@property (nonatomic, strong) UIButton *editingBtn;
@end

@implementation CustomVideoShowView

#pragma mark - public
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _dataSourceArr = [NSMutableArray array];
        _cellState = NormalState;
        self.backgroundColor = [UIColor clearColor];
        _itemSize = CGSizeMake(50.0f, 50.0f);
        [self createCustomViewWithFrame:frame];
    }return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
//    [self createCustomViewWithFrame:self.frame];
}

#pragma mark - UICollectionViewDataSource delaget
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = [IMGCollectionViewCell identifier];
    IMGCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (_cellState == NormalState) {
        cell.editingImg.hidden = YES;
    }else{
        cell.editingImg.hidden = NO;
    }
    cell.contentView.backgroundColor = [UIColor whiteColor];
    NSString *patch = self.dataSourceArr[indexPath.row];
    UIImage *image = [UIImage imageWithContentsOfFile:patch];
    [cell buildCellWithDataSource:image];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_cellState == NormalState) {
        _editingBtn.hidden = YES;
        _cancelBtn.selected = YES; 
    }else{
        
    }
    NSArray *indexPaths = [_collectionView indexPathsForVisibleItems];
    for (NSIndexPath *nosel in indexPaths) {
        IMGCollectionViewCell *cell = (IMGCollectionViewCell *)[collectionView cellForItemAtIndexPath:nosel];
        cell.selected = NO;
        [cell setCellLayerWithNeed:NO borderColor:[UIColor whiteColor] borderWidth:2.0f];
    }
    IMGCollectionViewCell *cell = (IMGCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = YES;
    [cell setCellLayerWithNeed:YES borderColor:[UIColor whiteColor] borderWidth:2.0f];

}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.itemSize;
}

//定义每个UICollectionView 的纵向间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0f;
}


//定义每个UICollectionView 的横向间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(15, 15, 0, 15);
}


#pragma mark - private mathods
#pragma mark 视图
- (void)createCustomViewWithFrame:(CGRect)frame{
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.itemSize = self.itemSize;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, frame.size.height / 2  + 30, frame.size.width, frame.size.height / 2 - 30) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor blackColor];
    [self addSubview:_collectionView];
    
    /** 注册cell */
    [_collectionView registerNib:[UINib nibWithNibName:[IMGCollectionViewCell identifier] bundle:nil] forCellWithReuseIdentifier:[IMGCollectionViewCell identifier]];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(_collectionView.frame) - 30, self.frame.size.width, 30)];
    topView.backgroundColor = [UIColor blackColor];
    [self createTopViewButtonWithView:topView];

    [self addSubview:topView];
}

#pragma mark 创建顶部2个按钮
- (void)createTopViewButtonWithView:(UIView *)topView{
    /** 取消按钮 */
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.frame = CGRectMake(10, 5, 40, 20);
    [_cancelBtn setTitle:@"走吧" forState:UIControlStateNormal];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateSelected];
    [_cancelBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_cancelBtn];
    
    /** 编辑按钮 */
    _editingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _editingBtn.frame = CGRectMake(CGRectGetWidth(topView.frame) - 50, 5, 40, 20);
    [_editingBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_editingBtn setTitle:@"完成" forState:UIControlStateSelected];
    [_editingBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [_editingBtn addTarget:self action:@selector(editingButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_editingBtn];
}

#pragma mark 取消按钮
- (void)cancelButtonAction{
    if (_cancelBtn.selected) {
        _cancelBtn.selected = NO;
        _editingBtn.hidden = NO;
        NSArray *indexPaths = [_collectionView indexPathsForVisibleItems];
        for (NSIndexPath *nosel in indexPaths) {
            IMGCollectionViewCell *cell = (IMGCollectionViewCell *)[_collectionView cellForItemAtIndexPath:nosel];
            cell.selected = NO;
            [cell setCellLayerWithNeed:NO borderColor:[UIColor whiteColor] borderWidth:2.0f];
        }
    } else{
        [UIView animateWithDuration:1.0f animations:^{
            self.center = CGPointMake(self.center.x, CGRectGetHeight(self.frame));
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

#pragma mark 编辑按钮
- (void)editingButtonAction:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if (_cellState == NormalState) {
        NSLog(@"编辑");
        btn.selected = YES;
        _cancelBtn.hidden = YES;
        _cellState = DeleteState;
    }else{
        NSLog(@"完成");
        _cellState = NormalState;
        _cancelBtn.hidden = NO;
        btn.selected = NO;
    }
    [_collectionView reloadData];
}

#pragma mark 创建数据源
- (void)createDataSource{
    [_collectionView reloadData];
}
@end
